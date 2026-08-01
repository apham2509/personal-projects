import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/features/personalisation/domain/safety_constraints.dart';
import 'package:pawsense/features/play/domain/play_tuning.dart';
import 'package:pawsense/features/play/domain/session_models.dart';
import 'package:pawsense/features/play/game/game_session_controller.dart';
import 'package:pawsense/shared/models/enums.dart';
import 'package:pawsense/shared/models/trial_configuration.dart';

import 'fakes.dart';

void main() {
  const width = 1200.0;
  const height = 800.0;
  const frame = 1 / 60;

  const config = TrialConfiguration(
    preyType: PreyType.mouse,
    movementStyle: MovementStyle.smooth,
    speedLevel: SpeedLevel.slow,
    sizeLevel: SizeLevel.large,
    soundMode: SoundMode.silent,
    spawnZone: SpawnZone.centre,
  );

  SessionPlan plan({
    SessionMode mode = SessionMode.freePlay,
    int duration = 180,
    RewardSchedule rewards = RewardSchedule.none,
    int maxReminders = 3,
  }) => SessionPlan(
    mode: mode,
    catId: 'cat-1',
    plannedDurationSeconds: duration,
    soundEnabled: true,
    seed: 42,
    initialDifficulty: 2,
    rewardSchedule: rewards,
    maxRewardReminders: maxReminders,
    isCalibration: false,
  );

  (GameSessionController, RecordingDelegate, FakeAudio, FixedTrialSource)
  build({SessionPlan? sessionPlan}) {
    final delegate = RecordingDelegate();
    final audio = FakeAudio();
    final source = FixedTrialSource(config);
    final controller = GameSessionController(
      plan: sessionPlan ?? plan(),
      tuning: defaultPlayTuning,
      constraints: const SafetyConstraints(),
      trialSource: source,
      audio: audio,
      delegate: delegate,
      screenWidth: width,
      screenHeight: height,
    );
    controller.start();
    return (controller, delegate, audio, source);
  }

  void advance(GameSessionController controller, double seconds) {
    final frames = (seconds / frame).round();
    for (var i = 0; i < frames; i++) {
      controller.update(frame);
    }
  }

  /// Runs through the 3 s countdown and the spawn-in so a target is active.
  void toActiveTarget(GameSessionController controller) {
    advance(controller, defaultPlayTuning.countdownSeconds + 0.5);
  }

  test('countdown ticks 3-2-1 and the first target spawns after it', () {
    final (controller, delegate, _, _) = build();
    advance(controller, 3.4);
    expect(delegate.countdownTicks, [3, 2, 1]);
    expect(delegate.spawns, hasLength(1));
  });

  test('catch: reaction time from becameTouchable, capture flows', () {
    final (controller, delegate, _, _) = build();
    toActiveTarget(controller);
    final snapshot = controller.currentTargetSnapshot!;
    expect(snapshot.active, isTrue);

    controller.handlePointerDown(1, snapshot.centreX, snapshot.centreY);
    expect(delegate.captures, 1);
    expect(delegate.finalisedTrials, hasLength(1));
    final (trial, touches) = delegate.finalisedTrials.single;
    expect(trial.success, isTrue);
    expect(trial.timedOut, isFalse);
    expect(trial.reactionTimeMs, isNotNull);
    // ~3.5 s elapsed - 3 s countdown - 0.25 s spawn-in ≈ 250 ms.
    expect(trial.reactionTimeMs, inInclusiveRange(150, 400));
    expect(trial.isValidForLearning, isTrue);
    expect(touches.single.classification, TouchClassification.hit);
  });

  test('one paw interaction can never produce two catches', () {
    final (controller, delegate, _, _) = build();
    toActiveTarget(controller);
    final snapshot = controller.currentTargetSnapshot!;

    // Paw lands: several pads within the cluster window and radius.
    controller.handlePointerDown(1, snapshot.centreX, snapshot.centreY);
    controller.handlePointerDown(2, snapshot.centreX + 8, snapshot.centreY);
    controller.handlePointerDown(3, snapshot.centreX, snapshot.centreY + 9);
    expect(delegate.captures, 1);
    expect(delegate.finalisedTrials, hasLength(1));
    // The catch finalises the trial synchronously, so its batch holds
    // exactly the one hit; the trailing pads buffer for the next flush.
    final touches = delegate.finalisedTrials.single.$2;
    expect(
      touches.where((t) => t.classification == TouchClassification.hit),
      hasLength(1),
    );
    expect(controller.bufferedTouchCount, 2);

    // Let the next trial run to timeout; its batch carries the two pads,
    // deduplicated and attached to no trial.
    advance(controller, 14);
    final nextBatch = delegate.finalisedTrials[1].$2;
    final duplicates = nextBatch
        .where((t) => t.classification == TouchClassification.ignoredDuplicate)
        .toList();
    expect(duplicates, hasLength(2));
    expect(duplicates.every((t) => t.deduplicated), isTrue);
    expect(duplicates.every((t) => t.trialIndex == null), isTrue);
  });

  test('two separate paws: second lands as postCapture, not a catch', () {
    final (controller, delegate, _, _) = build();
    toActiveTarget(controller);
    final snapshot = controller.currentTargetSnapshot!;

    controller.handlePointerDown(1, snapshot.centreX, snapshot.centreY);
    // Second paw 300 px away (outside cluster radius) right after capture.
    controller.handlePointerDown(2, snapshot.centreX + 300, snapshot.centreY);
    expect(delegate.captures, 1);
  });

  test('touch during spawn-in does not count as a catch', () {
    final (controller, delegate, _, _) = build();
    // 3 s countdown + 0.1 s: target spawned but not touchable yet.
    advance(controller, 3.05 + 0.05);
    final snapshot = controller.currentTargetSnapshot!;
    expect(snapshot.active, isFalse);
    controller.handlePointerDown(1, snapshot.centreX, snapshot.centreY);
    expect(delegate.captures, 0);
    // It still counted as a meaningful interaction (a miss), not a hit.
    expect(delegate.finalisedTrials, isEmpty);
  });

  test('timeout after 12 s finalises the trial and moves on', () {
    final (controller, delegate, _, _) = build();
    toActiveTarget(controller);
    advance(controller, 12.1);
    expect(delegate.expiries, 1);
    expect(delegate.finalisedTrials, hasLength(1));
    final trial = delegate.finalisedTrials.single.$1;
    expect(trial.timedOut, isTrue);
    expect(trial.success, isFalse);
    expect(trial.isValidForLearning, isTrue);
    // Next trial spawns after the inter-trial delay.
    advance(controller, 1.5);
    expect(delegate.spawns, hasLength(2));
  });

  test('session completes at planned duration with All done cue', () {
    final (controller, delegate, audio, _) = build(
      sessionPlan: plan(duration: 60),
    );
    audio.cues.add(CueType.allDone);
    // Keep the cat "engaged" (and catching, so no timeout-frustration
    // builds up) until the duration cap ends the session.
    for (var i = 0; i < 13; i++) {
      advance(controller, 5);
      final snapshot = controller.currentTargetSnapshot;
      if (snapshot != null && snapshot.active) {
        controller.handlePointerDown(
          1000 + i,
          snapshot.centreX,
          snapshot.centreY,
        );
      } else {
        controller.handlePointerDown(1000 + i, 200.0 + i * 10, 600);
      }
      controller.handlePointerUp(1000 + i);
    }
    expect(controller.isEnded, isTrue);
    expect(delegate.summary!.status, SessionStatus.completed);
    expect(audio.playedCues, contains(CueType.allDone));
  });

  test('disengagement ladder: nudge, easier target, gentle end', () {
    final (controller, delegate, _, source) = build();
    toActiveTarget(controller);
    // No interaction at all: 12 s nudge (t≈15.5 total).
    advance(controller, 12);
    expect(delegate.nudges, 1);
    // 20 s idle retires the current target; the easy trial begins after
    // the inter-trial delay.
    advance(controller, 10.2);
    expect(source.easierRequests, 1);
    expect(delegate.spawns.last, FixedTrialSource.easy);
    // 30 s idle: session ends as disengaged.
    advance(controller, 10);
    expect(controller.isEnded, isTrue);
    expect(delegate.summary!.status, SessionStatus.disengaged);
    // The retired-by-disengagement trial (neither caught nor fully timed
    // out) is not learning-valid; earlier full timeouts are.
    final retired = delegate.finalisedTrials
        .map((entry) => entry.$1)
        .where((t) => !t.success && !t.timedOut)
        .toList();
    expect(retired, isNotEmpty);
    expect(retired.every((t) => !t.isValidForLearning), isTrue);
    expect(source.outcomes.every((t) => t.timedOut), isTrue);
  });

  test('interaction resets disengagement', () {
    final (controller, delegate, _, _) = build();
    toActiveTarget(controller);
    advance(controller, 10);
    final snapshot = controller.currentTargetSnapshot!;
    // A miss is meaningful engagement.
    controller.handlePointerDown(1, snapshot.centreX + 300, 600);
    advance(controller, 10);
    expect(delegate.nudges, 0);
  });

  test('owner exit: ownerGesture touches never count as misses', () {
    final (controller, delegate, _, _) = build();
    toActiveTarget(controller);
    controller.handlePointerDown(1, 40, 40); // top-left corner
    controller.handlePointerDown(2, width - 40, 40); // top-right corner
    controller.ownerRequestedEnd();
    expect(controller.isEnded, isTrue);
    expect(delegate.summary!.status, SessionStatus.ownerStopped);
    expect(delegate.summary!.misses, 0);
    final touches = delegate.finalisedTrials.single.$2;
    expect(
      touches.every(
        (t) => t.classification == TouchClassification.ownerGesture,
      ),
      isTrue,
    );
  });

  test('backgrounding ends the session as backgrounded', () {
    final (controller, delegate, _, _) = build();
    toActiveTarget(controller);
    controller.appBackgrounded();
    expect(delegate.summary!.status, SessionStatus.backgrounded);
  });

  test('trial cut short by session end is not learning-valid', () {
    final (controller, delegate, _, source) = build(
      sessionPlan: plan(duration: 10),
    );
    toActiveTarget(controller);
    advance(controller, 7); // session cap hits mid-trial
    expect(controller.isEnded, isTrue);
    final trial = delegate.finalisedTrials.single.$1;
    expect(trial.success, isFalse);
    expect(trial.timedOut, isFalse);
    expect(trial.isValidForLearning, isFalse);
    expect(source.outcomes, isEmpty);
  });

  test('reward reminders: every 3 catches, capped at max', () {
    final (controller, delegate, _, _) = build(
      sessionPlan: plan(
        rewards: RewardSchedule.everyThreeCatches,
        maxReminders: 2,
        duration: 300,
      ),
    );
    toActiveTarget(controller);
    for (var i = 0; i < 12; i++) {
      final snapshot = controller.currentTargetSnapshot;
      if (snapshot != null && snapshot.active) {
        controller.handlePointerDown(
          100 + i,
          snapshot.centreX,
          snapshot.centreY,
        );
      }
      advance(controller, 1.6); // through inter-trial + spawn-in
    }
    final catches = delegate.captures;
    expect(catches, greaterThanOrEqualTo(9));
    // 3rd and 6th catch remind; the cap (2) stops the 9th.
    expect(delegate.rewardReminders, 2);
    final flagged = delegate.finalisedTrials
        .where((entry) => entry.$1.rewardReminderShown)
        .length;
    expect(flagged, 2);
  });

  test('touch training: cue -> jittered delay -> spawn -> praise', () async {
    final delegate = RecordingDelegate();
    final audio = FakeAudio()
      ..cues.addAll([CueType.touch, CueType.good, CueType.allDone]);
    final source = FixedTrialSource(config);
    final controller = GameSessionController(
      plan: plan(mode: SessionMode.touchTraining),
      tuning: defaultPlayTuning,
      constraints: const SafetyConstraints(),
      trialSource: source,
      audio: audio,
      delegate: delegate,
      screenWidth: width,
      screenHeight: height,
    );
    controller.start();

    advance(controller, 3.05);
    // Cue future completes in a microtask; let it settle.
    await Future<void>.delayed(Duration.zero);
    expect(audio.playedCues, contains(CueType.touch));
    expect(delegate.spawns, isEmpty, reason: 'delay before spawn');

    advance(controller, 0.8); // beyond max 700 ms jitter
    expect(delegate.spawns, hasLength(1));

    advance(controller, 0.3); // spawn-in
    final snapshot = controller.currentTargetSnapshot!;
    controller.handlePointerDown(1, snapshot.centreX, snapshot.centreY);
    expect(audio.playedCues, contains(CueType.good));
    final trial = delegate.finalisedTrials.single.$1;
    expect(trial.cueType, CueType.touch);
    expect(trial.praiseCueType, CueType.good);
  });

  test('same seed reproduces identical spawn sequences', () {
    final (c1, d1, _, _) = build();
    final (c2, d2, _, _) = build();
    for (var i = 0; i < 60 * 20; i++) {
      c1.update(frame);
      c2.update(frame);
    }
    expect(d1.spawnPositions, d2.spawnPositions);
    expect(d1.spawns, d2.spawns);
  });

  test('spawn positions stay within safe bounds for every zone', () {
    for (final zone in SpawnZone.values) {
      final delegate = RecordingDelegate();
      final source = FixedTrialSource(config.copyWith(spawnZone: zone));
      final controller = GameSessionController(
        plan: plan(duration: 300),
        tuning: defaultPlayTuning,
        constraints: const SafetyConstraints(),
        trialSource: source,
        audio: FakeAudio(),
        delegate: delegate,
        screenWidth: width,
        screenHeight: height,
      );
      controller.start();
      // Collect several spawns by timing out trials.
      advance(controller, 3.5);
      for (var i = 0; i < 4; i++) {
        advance(controller, 13.5);
      }
      final radiusUnits = defaultPlayTuning.sizeFractionLarge / 2;
      final bounds = controller.safeBounds(radiusUnits);
      for (final position in delegate.spawnPositions) {
        expect(
          bounds.contains(position),
          isTrue,
          reason: 'zone $zone spawned outside safe bounds: $position',
        );
      }
    }
  });

  test('touch event buffer is bounded', () {
    final (controller, _, _, _) = build(sessionPlan: plan(duration: 300));
    toActiveTarget(controller);
    for (var i = 0; i < 2000; i++) {
      controller.handlePointerDown(i, 400 + (i % 50) * 8.0, 600);
    }
    expect(controller.bufferedTouchCount, lessThanOrEqualTo(512));
  });
}
