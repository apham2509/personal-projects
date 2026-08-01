import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;

import '../../../core/database/app_database.dart';
import '../../../core/utils/l10n_ext.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/models/enums.dart';
import '../../../shared/providers/core_providers.dart';
import '../domain/cue_recorder.dart';

final cueRecorderProvider = Provider<CueRecorder>((ref) {
  final recorder = RecordPackageCueRecorder();
  ref.onDispose(recorder.dispose);
  return recorder;
});

/// Opens the OS settings app (for permanently denied microphone access).
/// Wrapped in a provider so widget tests can fake it.
final openAppSettingsProvider = Provider<Future<bool> Function()>(
  (ref) => permission_handler.openAppSettings,
);

/// Record, preview, re-record, and delete the five owner voice cues for one
/// cat. Recordings stay in the app's profile directory and never leave the
/// device.
class VoiceCuesScreen extends ConsumerStatefulWidget {
  const VoiceCuesScreen({super.key, required this.catId});

  final String catId;

  @override
  ConsumerState<VoiceCuesScreen> createState() => _VoiceCuesScreenState();
}

class _VoiceCuesScreenState extends ConsumerState<VoiceCuesScreen> {
  CueType? _recording;
  bool _permissionDenied = false;
  bool _busy = false;

  Future<void> _toggleRecording(CueType cueType) async {
    if (_busy) return;
    final recorder = ref.read(cueRecorderProvider);

    if (_recording == cueType) {
      // Stop and save.
      setState(() => _busy = true);
      try {
        final result = await recorder.stop();
        if (result != null) {
          await ref
              .read(voiceCueRepositoryProvider)
              .saveRecording(
                catId: widget.catId,
                cueType: cueType,
                temporaryRecording: File(result.path),
                durationMs: result.durationMs,
              );
        }
      } finally {
        if (mounted) {
          setState(() {
            _recording = null;
            _busy = false;
          });
        }
      }
      return;
    }

    if (_recording != null) return; // one recording at a time

    if (!await recorder.hasPermission()) {
      if (mounted) setState(() => _permissionDenied = true);
      return;
    }
    if (!mounted) return;
    setState(() => _permissionDenied = false);

    final files = ref.read(fileServiceProvider);
    final tempPath =
        '${files.documentsDir.path}/recording_${cueType.name}.m4a.tmp';
    await recorder.start(tempPath);
    if (mounted) setState(() => _recording = cueType);
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
                        const SizedBox(height: 10),
                        OutlinedButton(
                          onPressed: () => ref.read(openAppSettingsProvider)(),
                          child: Text(l10n.voiceOpenSettings),
                        ),
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
                      _recording != null && _recording != cueType,
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
