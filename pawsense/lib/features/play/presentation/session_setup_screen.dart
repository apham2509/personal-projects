import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/l10n_ext.dart';
import '../../../shared/models/enums.dart';
import '../../../shared/providers/core_providers.dart';
import 'session_launch.dart';

final _trainingRecordingsProvider = StreamProvider.autoDispose
    .family<Set<CueType>, String>((ref, catId) {
      final files = ref.watch(fileServiceProvider);
      return ref
          .watch(voiceCueRepositoryProvider)
          .watchForCat(catId)
          .map(
            (rows) => {
              for (final cue in rows)
                if (files.resolve(cue.filePath).existsSync()) cue.cueType,
            },
          );
    });

/// Owner-facing pre-session configuration: duration, sound, adaptive vs
/// manual factors, and a safety reminder. Mode comes from the entry point.
class SessionSetupScreen extends ConsumerStatefulWidget {
  const SessionSetupScreen({
    super.key,
    required this.mode,
    required this.catId,
  });

  final SessionMode mode;

  /// Null for mixed sessions.
  final String? catId;

  @override
  ConsumerState<SessionSetupScreen> createState() => _SetupState();
}

class _SetupState extends ConsumerState<SessionSetupScreen> {
  int? _durationSeconds;
  bool? _soundEnabled;
  bool _manual = false;
  PreyType _manualPrey = PreyType.mouse;
  MovementStyle _manualMovement = MovementStyle.smooth;
  SpeedLevel _manualSpeed = SpeedLevel.slow;
  SizeLevel _manualSize = SizeLevel.large;

  bool get _supportsManual =>
      widget.mode == SessionMode.freePlay && widget.catId != null;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider).value;
    final catAsync = widget.catId == null
        ? null
        : ref.watch(catProfileProvider(widget.catId!));
    if (settings == null || (catAsync != null && catAsync.value == null)) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final cat = catAsync?.value;
    final duration = _durationSeconds ?? settings.defaultSessionDurationSeconds;
    final soundLocked =
        cat != null && cat.soundSensitivity == SoundSensitivity.easilyStartled;
    final sound = !soundLocked && (_soundEnabled ?? settings.soundEnabled);

    final title = switch (widget.mode) {
      SessionMode.freePlay => l10n.setupTitlePlay,
      SessionMode.touchTraining => l10n.setupTitleTrain,
      SessionMode.calibration => l10n.setupTitleCalibration,
      SessionMode.mixed => l10n.mixedTitle,
    };

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              if (widget.mode == SessionMode.touchTraining &&
                  widget.catId != null) ...[
                _TrainingGuide(catId: widget.catId!, soundEnabled: sound),
                const SizedBox(height: 24),
              ],
              if (widget.mode == SessionMode.mixed) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(l10n.mixedInfoBody),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (widget.mode == SessionMode.calibration) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(l10n.setupCalibrationInfo),
                  ),
                ),
                if (widget.catId != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () async {
                        await ref
                            .read(catProfileRepositoryProvider)
                            .setCalibrationState(
                              widget.catId!,
                              CalibrationState.skipped,
                            );
                        if (context.mounted) context.pop();
                      },
                      child: Text(l10n.setupSkipCalibration),
                    ),
                  ),
                const SizedBox(height: 16),
              ],
              Text(
                l10n.setupDuration,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final seconds in const [60, 120, 180, 300])
                    ChoiceChip(
                      selected: duration == seconds,
                      label: Text(l10n.durationMinutes(seconds ~/ 60)),
                      onSelected: (_) =>
                          setState(() => _durationSeconds = seconds),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              SwitchListTile(
                title: Text(l10n.setupSound),
                subtitle: Text(
                  soundLocked ? l10n.setupSoundLocked : l10n.setupSoundBody,
                ),
                value: sound,
                onChanged: soundLocked
                    ? null
                    : (value) => setState(() => _soundEnabled = value),
              ),
              if (_supportsManual) ...[
                SwitchListTile(
                  title: Text(l10n.setupManualToggle),
                  subtitle: Text(l10n.setupManualBody),
                  value: _manual,
                  onChanged: (value) => setState(() => _manual = value),
                ),
                if (_manual) ...[
                  const SizedBox(height: 8),
                  _factorRow<PreyType>(
                    l10n.setupManualPrey,
                    PreyType.values,
                    _manualPrey,
                    (v) => switch (v) {
                      PreyType.mouse => l10n.preyMouse,
                      PreyType.moth => l10n.preyMothBug,
                      PreyType.fish => l10n.preyFish,
                    },
                    (v) => setState(() => _manualPrey = v),
                  ),
                  _factorRow<MovementStyle>(
                    l10n.setupManualMovement,
                    MovementStyle.values,
                    _manualMovement,
                    (v) => switch (v) {
                      MovementStyle.smooth => l10n.movementSmooth,
                      MovementStyle.stopAndGo => l10n.movementStopGo,
                      MovementStyle.unpredictable => l10n.movementUnpredictable,
                    },
                    (v) => setState(() => _manualMovement = v),
                  ),
                  _factorRow<SpeedLevel>(
                    l10n.setupManualSpeed,
                    SpeedLevel.values,
                    _manualSpeed,
                    (v) => switch (v) {
                      SpeedLevel.slow => l10n.speedSlow,
                      SpeedLevel.medium => l10n.speedMedium,
                      SpeedLevel.fast => l10n.speedFast,
                    },
                    (v) => setState(() => _manualSpeed = v),
                  ),
                  _factorRow<SizeLevel>(
                    l10n.setupManualSize,
                    SizeLevel.values,
                    _manualSize,
                    (v) => switch (v) {
                      SizeLevel.small => l10n.bodySmall,
                      SizeLevel.medium => l10n.bodyMedium,
                      SizeLevel.large => l10n.bodyLarge,
                    },
                    (v) => setState(() => _manualSize = v),
                  ),
                ],
              ],
              const SizedBox(height: 24),
              Card(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.shield_outlined),
                      const SizedBox(width: 12),
                      Expanded(child: Text(l10n.setupSafetyReminder)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.touch_app_outlined),
                title: Text(l10n.setupExitTitle),
                subtitle: Text(l10n.setupExitBody),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  final launch = SessionLaunch(
                    mode: widget.mode,
                    catId: widget.catId,
                    durationSeconds: duration,
                    soundEnabled: sound,
                    manualConfig: _manual && _supportsManual
                        ? ManualFactors(
                            preyType: _manualPrey,
                            movementStyle: _manualMovement,
                            speedLevel: _manualSpeed,
                            sizeLevel: _manualSize,
                          )
                        : null,
                  );
                  context.pushReplacement('/play', extra: launch);
                },
                icon: const Icon(Icons.play_arrow),
                label: Text(l10n.setupStart),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _factorRow<T>(
    String label,
    List<T> values,
    T selected,
    String Function(T) labelOf,
    ValueChanged<T> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final value in values)
                ChoiceChip(
                  selected: value == selected,
                  label: Text(labelOf(value)),
                  onSelected: (_) => onChanged(value),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrainingGuide extends ConsumerWidget {
  const _TrainingGuide({required this.catId, required this.soundEnabled});

  final String catId;
  final bool soundEnabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final cues = ref.watch(_trainingRecordingsProvider(catId));
    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.record_voice_over_outlined,
              color: theme.colorScheme.onPrimaryContainer,
              size: 28,
            ),
            const SizedBox(height: 12),
            Text(l10n.setupTrainingTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(l10n.setupTrainingLoop),
            const SizedBox(height: 16),
            if (!soundEnabled)
              Text(l10n.setupTrainingSilent)
            else
              cues.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => Text(l10n.errorGenericBody),
                data: (available) => Text(
                  !available.contains(CueType.touch)
                      ? l10n.setupTrainingNeedsTouch
                      : !available.contains(CueType.good) &&
                            !available.contains(CueType.goodJob)
                      ? l10n.setupTrainingNeedsPraise
                      : l10n.setupTrainingReady,
                ),
              ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => context.push('/cats/$catId/voice'),
              icon: const Icon(Icons.mic_none_rounded),
              label: Text(l10n.setupRecordCues),
            ),
          ],
        ),
      ),
    );
  }
}
