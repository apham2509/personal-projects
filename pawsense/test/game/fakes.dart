import 'dart:async';

import 'package:pawsense/core/utils/vec2.dart';
import 'package:pawsense/features/play/domain/session_models.dart';
import 'package:pawsense/features/play/game/game_session_controller.dart';
import 'package:pawsense/shared/models/enums.dart';
import 'package:pawsense/shared/models/trial_configuration.dart';

class FixedTrialSource extends TrialSource {
  FixedTrialSource(this.configuration);

  final TrialConfiguration configuration;
  final List<TrialRecord> outcomes = [];

  static const easy = TrialConfiguration(
    preyType: PreyType.mouse,
    movementStyle: MovementStyle.smooth,
    speedLevel: SpeedLevel.slow,
    sizeLevel: SizeLevel.large,
    soundMode: SoundMode.silent,
    spawnZone: SpawnZone.centre,
  );

  int easierRequests = 0;

  @override
  TrialConfiguration next({
    required int difficulty,
    required List<TrialConfiguration> history,
  }) => configuration;

  @override
  TrialConfiguration easier({required List<TrialConfiguration> history}) {
    easierRequests++;
    return easy;
  }

  @override
  void onTrialOutcome(TrialRecord outcome) => outcomes.add(outcome);
}

class FakeAudio implements SessionAudio {
  final Set<CueType> cues = {};
  final List<CueType> playedCues = [];
  final List<SessionEffect> playedEffects = [];

  /// When non-null, cue playback completes only when this completer does.
  Completer<void>? pendingCue;

  @override
  bool hasCue(CueType type) => cues.contains(type);

  @override
  Future<void> playCue(CueType type) {
    playedCues.add(type);
    return pendingCue?.future ?? Future.value();
  }

  @override
  void playEffect(SessionEffect effect, {PreyType? prey}) {
    playedEffects.add(effect);
  }
}

class RecordingDelegate implements SessionDelegate {
  final List<int> countdownTicks = [];
  final List<TrialConfiguration> spawns = [];
  final List<Vec2> spawnPositions = [];
  int captures = 0;
  int expiries = 0;
  int nudges = 0;
  int rewardReminders = 0;
  final List<(TrialRecord, List<TouchRecord>)> finalisedTrials = [];
  SessionSummary? summary;

  @override
  void onCountdownTick(int secondsRemaining) =>
      countdownTicks.add(secondsRemaining);

  @override
  void onSpawnTarget({
    required TrialConfiguration configuration,
    required int pathSeed,
    required Vec2 unitPosition,
    required double diameterPx,
  }) {
    spawns.add(configuration);
    spawnPositions.add(unitPosition);
  }

  @override
  void onTargetCaptured() => captures++;

  @override
  void onTargetExpired() => expiries++;

  @override
  void onAttentionNudge() => nudges++;

  @override
  void onRewardReminder() => rewardReminders++;

  @override
  void onTrialFinalised(TrialRecord trial, List<TouchRecord> touches) {
    finalisedTrials.add((trial, touches));
  }

  @override
  void onSessionEnded(SessionSummary sessionSummary) {
    summary = sessionSummary;
  }
}
