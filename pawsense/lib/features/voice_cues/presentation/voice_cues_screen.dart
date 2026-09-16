import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/audio/audio_service.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/l10n_ext.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/models/enums.dart';
import '../../../shared/providers/core_providers.dart';
import '../domain/cue_recorder.dart';

final cueRecorderProvider = Provider.autoDispose<CueRecorder>((ref) {
  final recorder = RecordPackageCueRecorder();
  ref.onDispose(recorder.dispose);
  return recorder;
});

/// Record, preview, re-record, and delete the five owner voice cues for one
/// cat. Recordings stay in the app's profile directory and never leave the
/// device.
class VoiceCuesScreen extends ConsumerStatefulWidget {
  const VoiceCuesScreen({super.key, required this.catId});

  final String catId;

  @override
  ConsumerState<VoiceCuesScreen> createState() => _VoiceCuesScreenState();
}

class _VoiceCuesScreenState extends ConsumerState<VoiceCuesScreen>
    with WidgetsBindingObserver {
  late final CueRecorder _recorder;
  late final AudioService _audio;
  CueType? _recording;
  bool _permissionDenied = false;
  bool _busy = false;
  bool _disposed = false;
  int _operation = 0;
  String? _temporaryPath;
  Timer? _recordingLimit;

  @override
  void initState() {
    super.initState();
    _recorder = ref.read(cueRecorderProvider);
    _audio = ref.read(audioServiceProvider);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    _cancelRecording();
    _audio.stopCue().ignore();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      _cancelRecording();
      _audio.stopCue().ignore();
    }
  }

  void _cancelRecording() {
    _operation++;
    _recordingLimit?.cancel();
    _recording = null;
    // A pending start/stop owns its cleanup and checks the operation token.
    if (!_busy) {
      _busy = true;
      _discardRecording().whenComplete(() {
        _busy = false;
        if (!_disposed && mounted) setState(() {});
      }).ignore();
    }
    if (!_disposed && mounted) setState(() {});
  }

  Future<void> _discardRecording() async {
    try {
      await _recorder.cancel();
    } on Exception {
      // The plugin may already have stopped or disposed after navigation.
    } finally {
      final path = _temporaryPath;
      _temporaryPath = null;
      if (path != null) {
        final file = File(path);
        if (file.existsSync()) file.deleteSync();
      }
    }
  }

  void _showRecordingError() {
    if (_disposed || !mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.errorGenericBody)));
  }

  Future<void> _toggleRecording(CueType cueType) async {
    if (_busy) return;
    if (_recording != null && _recording != cueType) return;
    final operation = ++_operation;
    bool current() => !_disposed && mounted && operation == _operation;
    setState(() => _busy = true);

    if (_recording == cueType) {
      // Stop and save.
      _recordingLimit?.cancel();
      final repository = ref.read(voiceCueRepositoryProvider);
      try {
        final result = await _recorder.stop();
        if (current() && result != null) {
          await repository.saveRecording(
            catId: widget.catId,
            cueType: cueType,
            temporaryRecording: File(result.path),
            durationMs: result.durationMs,
          );
          _temporaryPath = null;
        }
      } on Exception {
        _showRecordingError();
      } finally {
        await _discardRecording();
        if (!_disposed && mounted) {
          setState(() {
            _recording = null;
            _busy = false;
          });
        }
      }
      return;
    }

    try {
      if (!await _recorder.hasPermission()) {
        if (current()) setState(() => _permissionDenied = true);
        return;
      }
      if (!current()) return;
      setState(() => _permissionDenied = false);
      final files = ref.read(fileServiceProvider);
      final tempPath =
          '${files.documentsDir.path}/recording_${widget.catId}_${cueType.name}.m4a.tmp';
      _temporaryPath = tempPath;
      await _recorder.start(tempPath);
      if (!current()) return;
      setState(() => _recording = cueType);
      // Short cues fit the session playback window and avoid an open-ended mic.
      _recordingLimit = Timer(const Duration(seconds: 5), () {
        if (current()) _toggleRecording(cueType);
      });
    } on Exception {
      await _discardRecording();
      _showRecordingError();
    } finally {
      if (!current()) await _discardRecording();
      _busy = false;
      if (!_disposed && mounted) setState(() {});
    }
  }

  Future<void> _preview(VoiceCue cue) async {
    final absolute = ref.read(fileServiceProvider).resolve(cue.filePath).path;
    await ref.read(audioServiceProvider).playCueFile(absolute);
  }

  Future<void> _delete(CueType cueType) async {
    await ref.read(voiceCueRepositoryProvider).deleteCue(widget.catId, cueType);
  }

  String _cueLabel(AppLocalizations l10n, CueType type, String catName) =>
      switch (type) {
        CueType.catName => l10n.cueCatName(catName),
        CueType.touch => l10n.cueTouch,
        CueType.good => l10n.cueGood,
        CueType.goodJob => l10n.cueGoodJob,
        CueType.allDone => l10n.cueAllDone,
      };

  String _cueHint(AppLocalizations l10n, CueType type) => switch (type) {
    CueType.catName => l10n.cueCatNameHint,
    CueType.touch => l10n.cueTouchHint,
    CueType.good => l10n.cueGoodHint,
    CueType.goodJob => l10n.cueGoodJobHint,
    CueType.allDone => l10n.cueAllDoneHint,
  };

  @override
  Widget build(BuildContext context) {
    // Keep the recorder alive only while this screen is present.
    ref.watch(cueRecorderProvider);
    final l10n = context.l10n;
    final catAsync = ref.watch(catProfileProvider(widget.catId));
    final cuesAsync = ref.watch(_cuesProvider(widget.catId));

    final cat = catAsync.value;
    if (cat == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final cues = {
      for (final cue in cuesAsync.value ?? const <VoiceCue>[]) cue.cueType: cue,
    };

    return Scaffold(
      appBar: AppBar(title: Text(l10n.voiceTitle(cat.name))),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  l10n.voiceIntro,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              if (_permissionDenied)
                Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.voiceMicDeniedTitle,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(l10n.voiceMicDeniedBody),
                      ],
                    ),
                  ),
                ),
              for (final cueType in CueType.values)
                _CueTile(
                  label: _cueLabel(l10n, cueType, cat.name),
                  hint: _cueHint(l10n, cueType),
                  cue: cues[cueType],
                  isRecording: _recording == cueType,
                  recordingElsewhere:
                      _busy || (_recording != null && _recording != cueType),
                  onRecordToggle: () => _toggleRecording(cueType),
                  onPreview: cues[cueType] == null
                      ? null
                      : () => _preview(cues[cueType]!),
                  onDelete: cues[cueType] == null
                      ? null
                      : () => _delete(cueType),
                ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  l10n.voicePrivacyNote,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final _cuesProvider = StreamProvider.family<List<VoiceCue>, String>(
  (ref, catId) => ref.watch(voiceCueRepositoryProvider).watchForCat(catId),
);

class _CueTile extends StatelessWidget {
  const _CueTile({
    required this.label,
    required this.hint,
    required this.cue,
    required this.isRecording,
    required this.recordingElsewhere,
    required this.onRecordToggle,
    required this.onPreview,
    required this.onDelete,
  });

  final String label;
  final String hint;
  final VoiceCue? cue;
  final bool isRecording;
  final bool recordingElsewhere;
  final VoidCallback onRecordToggle;
  final VoidCallback? onPreview;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final recorded = cue != null;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(label, style: theme.textTheme.titleMedium),
                      const SizedBox(width: 8),
                      if (recorded)
                        Icon(
                          Icons.check_circle,
                          size: 18,
                          color: theme.colorScheme.primary,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isRecording ? l10n.voiceRecordingNow : hint,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isRecording ? theme.colorScheme.error : null,
                    ),
                  ),
                  if (recorded && !isRecording)
                    Text(
                      l10n.voiceDuration(
                        (cue!.durationMs / 1000).toStringAsFixed(1),
                      ),
                      style: theme.textTheme.bodySmall,
                    ),
                ],
              ),
            ),
            if (onPreview != null && !isRecording)
              IconButton(
                tooltip: l10n.voicePreview,
                onPressed: onPreview,
                icon: const Icon(Icons.play_arrow),
              ),
            if (onDelete != null && !isRecording)
              IconButton(
                tooltip: l10n.actionDelete,
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete_outline,
                  color: theme.colorScheme.error,
                ),
              ),
            const SizedBox(width: 4),
            FilledButton.icon(
              onPressed: recordingElsewhere ? null : onRecordToggle,
              style: isRecording
                  ? FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.error,
                      foregroundColor: theme.colorScheme.onError,
                    )
                  : null,
              icon: Icon(isRecording ? Icons.stop : Icons.mic),
              label: Text(
                isRecording
                    ? l10n.voiceStop
                    : (recorded ? l10n.voiceReRecord : l10n.voiceRecord),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
