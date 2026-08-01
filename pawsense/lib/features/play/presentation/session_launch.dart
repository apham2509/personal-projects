import 'dart:io';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_config.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/random/seeded_random.dart';
import '../../../core/utils/vec2.dart';
import '../../../shared/models/enums.dart';
import '../../../shared/models/trial_configuration.dart';
import '../../../shared/providers/core_providers.dart';
import '../../calibration/domain/calibration_scheduler.dart';
import '../../personalisation/domain/algorithm_version.dart' as algo;
import '../../personalisation/domain/difficulty_controller.dart';
import '../../personalisation/domain/personalisation_policy.dart';
import '../../personalisation/domain/preference_scoring.dart';
import '../../personalisation/domain/safety_constraints.dart';
import '../data/session_repository.dart';
import '../domain/play_tuning.dart';
import '../domain/session_models.dart';
import '../domain/trial_sources.dart';
import '../game/game_session_controller.dart';

/// Owner choices carried from the setup screen into the play screen.
class SessionLaunch {
  const SessionLaunch({
    required this.mode,
    required this.catId,
    required this.durationSeconds,
    required this.soundEnabled,
    this.manualConfig,
    this.replayConfig,
  });

  final SessionMode mode;

  /// Null for mixed sessions.
  final String? catId;
  final int durationSeconds;
  final bool soundEnabled;

  /// Non-null when the owner picked fixed factors instead of adaptive.
  final ManualFactors? manualConfig;

  /// Developer tools: exact configuration replay.
  final TrialConfiguration? replayConfig;
}

class ManualFactors {
  const ManualFactors({
    required this.preyType,
    required this.movementStyle,
    required this.speedLevel,
    required this.sizeLevel,
  });

  final PreyType preyType;
  final MovementStyle movementStyle;
  final SpeedLevel speedLevel;
  final SizeLevel sizeLevel;
}

/// Everything the play screen needs, built once per session.
class BuiltSession {
  const BuiltSession({
    required this.controller,
    required this.tuning,
    required this.highContrast,
  });

  final GameSessionController controller;
  final PlayTuning tuning;
  final bool highContrast;
}

final sessionRunnerFactoryProvider = Provider<SessionRunnerFactory>(
  SessionRunnerFactory.new,
);

/// Builds live sessions (wiring repositories, audio, trial sources, and the
/// persistence delegate) and finalises them.
class SessionRunnerFactory {
  SessionRunnerFactory(this._ref);

  final Ref _ref;

  _LiveSession? _live;

  Future<BuiltSession> build({
    required SessionLaunch launch,
    required Size screenSize,
    required SessionDelegate delegate,
  }) async {
    final clock = _ref.read(clockProvider);
    final settings = await _ref.read(settingsRepositoryProvider).get();
    final sessionRepo = _ref.read(sessionRepositoryProvider);
    final preferenceRepo = _ref.read(preferenceRepositoryProvider);
    final audio = _ref.read(audioServiceProvider);
    await audio.preload();

    final seed = freshSeed(clock.nowUtc());
    const tuning = defaultPlayTuning;

    // Profile-derived pieces (mixed sessions have none).
    var constraints = const SafetyConstraints();
    var initialDifficulty = MixedTrialSource.fixedDifficulty;
    Map<CueType, String> cueFiles = const {};
    final catId = launch.catId;
    if (catId != null) {
      final cat = await _ref.read(catProfileRepositoryProvider).getById(catId);
      if (cat == null) {
        throw StateError('cat $catId missing at session start');
      }
      constraints = SafetyConstraints.fromAnswers(
        soundSensitivity: cat.soundSensitivity,
        visionConsideration: cat.visionConsideration,
        mobilityConsideration: cat.mobilityConsideration,
      );
      initialDifficulty = cat.currentDifficulty;
      // Seed questionnaire priors once, before the first-ever trial.
      await preferenceRepo.seedPriorsIfEmpty(
        catId,
        seedsFromAnswers(
          favouritePrey: cat.favouritePrey,
          energyLevel: cat.energyLevel,
          soundSensitivity: cat.soundSensitivity,
        ),
      );
      cueFiles = await _ref
          .read(voiceCueRepositoryProvider)
          .cueFilePaths(catId);
    }

    final plan = SessionPlan(
      mode: launch.mode,
      catId: catId,
      plannedDurationSeconds: launch.durationSeconds.clamp(
        30,
        tuning.maxSessionSeconds,
      ),
      soundEnabled: launch.soundEnabled && settings.soundEnabled,
      seed: seed,
      initialDifficulty: initialDifficulty,
      rewardSchedule: settings.rewardSchedule,
      maxRewardReminders: settings.maxRewardReminders,
      isCalibration: launch.mode == SessionMode.calibration,
    );

    final sourceRng = SeededRandom(seed).fork();
    final TrialSource source;
    switch (launch.mode) {
      case SessionMode.calibration:
        final schedule = const CalibrationScheduler().generate(
          seed: seed,
          constraints: constraints,
        );
        source = CalibrationTrialSource(
          schedule: schedule,
          constraints: constraints,
        );
        if (catId != null) {
          await _ref
              .read(catProfileRepositoryProvider)
              .setCalibrationState(catId, CalibrationState.inProgress);
        }
      case SessionMode.freePlay || SessionMode.touchTraining:
        if (launch.replayConfig != null) {
          source = ReplayTrialSource(launch.replayConfig!);
        } else if (launch.manualConfig != null) {
          final manual = launch.manualConfig!;
          source = ManualTrialSource(
            preyType: manual.preyType,
            movementStyle: manual.movementStyle,
            speedLevel: manual.speedLevel,
            sizeLevel: manual.sizeLevel,
            soundMode: plan.soundEnabled ? SoundMode.sound : SoundMode.silent,
            constraints: constraints,
            rng: sourceRng,
          );
        } else {
          source = AdaptiveTrialSource(
            snapshot: catId == null
                ? PreferenceSnapshot.empty
                : await preferenceRepo.loadSnapshot(catId),
            constraints: constraints,
            rng: sourceRng,
            soundEnabled: plan.soundEnabled,
            difficultyController: DifficultyController(
              initialDifficulty: initialDifficulty,
            ),
          );
        }
      case SessionMode.mixed:
        source = MixedTrialSource(
          rng: sourceRng,
          soundEnabled: plan.soundEnabled,
        );
    }

    final (sessionId, startedAt) = await sessionRepo.createSession(
      plan: plan,
      screenWidthLogical: screenSize.width,
      screenHeightLogical: screenSize.height,
      appVersion: appVersion,
      platform: Platform.operatingSystem,
      algorithmVersion: algo.algorithmVersion,
    );

    final live = _LiveSession(
      sessionId: sessionId,
      startedAt: startedAt,
      repo: sessionRepo,
      inner: delegate,
      audio: SessionAudioImpl(audio, cueFiles, _ref),
      calibrationCatId: launch.mode == SessionMode.calibration ? catId : null,
      ref: _ref,
    );
    _live = live;

    final controller = GameSessionController(
      plan: plan,
      tuning: tuning,
      constraints: constraints,
      trialSource: source,
      audio: live.audio,
      delegate: live,
      screenWidth: screenSize.width,
      screenHeight: screenSize.height,
    );
    live.controller = controller;

    return BuiltSession(
      controller: controller,
      tuning: tuning,
      highContrast: settings.highContrastMode || constraints.highContrast,
    );
  }

  /// Called by the play screen once the session has ended; waits for all
  /// pending writes and returns the session id for the results route.
  Future<String> finish(SessionSummary summary) async {
    final live = _live;
    if (live == null) {
      throw StateError('no live session to finish');
    }
    _live = null;
    await live.finish(summary);
    return live.sessionId;
  }
}

/// Bridges controller events to persistence: trial batches at boundaries,
/// transactional finalisation at the end. Forwards everything to the visual
/// delegate first so the cat never waits on a write.
class _LiveSession implements SessionDelegate {
  _LiveSession({
    required this.sessionId,
    required this.startedAt,
    required this.repo,
    required this.inner,
    required this.audio,
    required this.calibrationCatId,
    required this.ref,
  });

  final String sessionId;
  final DateTime startedAt;
  final SessionRepository repo;
  final SessionDelegate inner;
  final SessionAudioImpl audio;
  final String? calibrationCatId;
  final Ref ref;

  late GameSessionController controller;

  /// Writes are chained so batches persist in order without blocking the
  /// game loop.
  Future<void> _writeQueue = Future.value();

  @override
  void onCountdownTick(int secondsRemaining) =>
      inner.onCountdownTick(secondsRemaining);

  @override
  void onSpawnTarget({
    required TrialConfiguration configuration,
    required int pathSeed,
    required Vec2 unitPosition,
    required double diameterPx,
  }) => inner.onSpawnTarget(
    configuration: configuration,
    pathSeed: pathSeed,
    unitPosition: unitPosition,
    diameterPx: diameterPx,
  );

  @override
  void onTargetCaptured() => inner.onTargetCaptured();

  @override
  void onTargetExpired() => inner.onTargetExpired();

  @override
  void onAttentionNudge() => inner.onAttentionNudge();

  @override
  void onRewardReminder() => inner.onRewardReminder();

  @override
  void onTrialFinalised(TrialRecord trial, List<TouchRecord> touches) {
    inner.onTrialFinalised(trial, touches);
    _writeQueue = _writeQueue.then(
      (_) => repo.insertTrialWithTouches(
        sessionId: sessionId,
        sessionStartUtc: startedAt,
        trial: trial,
        touches: touches,
        algorithmVersion: algo.algorithmVersion,
      ),
    );
  }

  @override
  void onSessionEnded(SessionSummary summary) {
    inner.onSessionEnded(summary);
  }

  Future<void> finish(SessionSummary summary) async {
    await _writeQueue;
    await repo.finaliseSession(
      sessionId: sessionId,
      summary: summary,
      trials: controller.trials,
    );
    final catId = calibrationCatId;
    if (catId != null) {
      // Calibration counts as complete once most of the schedule ran.
      final validTrials = controller.trials
          .where((t) => t.isValidForLearning)
          .length;
      final finished =
          summary.status == SessionStatus.completed || validTrials >= 8;
      await ref
          .read(catProfileRepositoryProvider)
          .setCalibrationState(
            catId,
            finished ? CalibrationState.completed : CalibrationState.inProgress,
          );
    }
  }
}

/// Session audio over the app-wide [AudioService] plus this cat's cue files.
class SessionAudioImpl implements SessionAudio {
  SessionAudioImpl(this._service, this._cueFiles, this._ref);

  final AudioService _service;
  final Map<CueType, String> _cueFiles;
  final Ref _ref;

  @override
  bool hasCue(CueType type) => _cueFiles.containsKey(type);

  @override
  Future<void> playCue(CueType type) {
    final path = _cueFiles[type];
    if (path == null) return Future.value();
    final absolute = _ref.read(fileServiceProvider).resolve(path).path;
    return _service.playCueFile(absolute);
  }

  @override
  void playEffect(SessionEffect effect, {PreyType? prey}) {
    switch (effect) {
      case SessionEffect.capturePop:
        _service.playCapture();
      case SessionEffect.successChime:
        _service.playSuccessChime();
      case SessionEffect.attention:
        _service.playAttention();
      case SessionEffect.preyVoice:
        if (prey != null) _service.playPreyVoice(prey);
    }
  }
}
