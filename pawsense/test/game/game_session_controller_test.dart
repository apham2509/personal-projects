import 'dart:async';

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
    bool soundEnabled = true,
  }) => SessionPlan(
    mode: mode,
    catId: 'cat-1',
    plannedDurationSeconds: duration,
    soundEnabled: soundEnabled,
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

  void catchCurrentTarget(GameSessionController controller, int pointer) {
    final target = controller.currentTargetSnapshot!;
    expect(target.active, isTrue);
    controller.handlePointerDown(pointer, target.centreX, target.centreY);
    controller.handlePointerUp(pointer);
  }

  void catchFirstThree(GameSessionController controller) {
    toActiveTarget(controller);
    for (var i = 0; i < 3; i++) {
      catchCurrentTarget(controller, i + 1);
      if (i < 2) advance(controller, 1.6);
    }
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

  test('clustered pad catch supersedes the first miss without a penalty', () {
    final (controller, delegate, _, _) = build();
    toActiveTarget(controller);
    final target = controller.currentTargetSnapshot!;
    controller.handlePointerDown(
      1,
      target.centreX + target.hitboxRadius + 5,
      target.centreY,
    );
    advance(controller, 0.06);
    controller.handlePointerDown(
      2,
      target.centreX + target.hitboxRadius - 5,
      target.centreY,
    );
    final (trial, touches) = delegate.finalisedTrials.single;
    expect(trial.success, isTrue);
    expect(trial.missCount, 0);
    expect(trial.frustrationSeverity, 0);
    expect(touches.first.classification, TouchClassification.ignoredDuplicate);
    expect(touches.first.deduplicated, isTrue);
    expect(touches.last.classification, TouchClassification.hit);
    expect(
      touches.first.logicalInteractionId,
      touches.last.logicalInteractionId,
    );
  });

  test('fast paw sweep catches once between samples', () {
    final (controller, delegate, _, _) = build();
    toActiveTarget(controller);
    final target = controller.currentTargetSnapshot!;
    final reach = target.hitboxRadius + 30;
    controller.handlePointerDown(1, target.centreX - reach, target.centreY);
    advance(controller, 0.06);
    controller.handlePointerMove(1, target.centreX + reach, target.centreY);
    controller.handlePointerMove(1, target.centreX - reach, target.centreY);
    expect(delegate.captures, 1);
    expect(delegate.finalisedTrials.single.$1.missCount, 0);
    expect(
      delegate.finalisedTrials.single.$2.last.classification,
      TouchClassification.hit,
    );
  });

  test('slow swipe keeps its initial miss but movement adds no misses', () {
    final (controller, delegate, _, _) = build();
    toActiveTarget(controller);
    final target = controller.currentTargetSnapshot!;
    final reach = target.hitboxRadius + 40;
    controller.handlePointerDown(1, target.centreX - reach, target.centreY);
    advance(controller, 0.3);
    for (var i = 1; i <= 10; i++) {
      controller.handlePointerMove(
        1,
        target.centreX - reach + i,
        target.centreY,
      );
    }
    controller.handlePointerMove(1, target.centreX + reach, target.centreY);
    final (trial, touches) = delegate.finalisedTrials.single;
    expect(trial.missCount, 1);
    expect(touches, hasLength(2));
    expect(touches.first.classification, TouchClassification.miss);
    expect(touches.last.classification, TouchClassification.hit);
  });

  test('lift and new target both prevent stale swipe catches', () {
    final (controller, delegate, _, _) = build();
    toActiveTarget(controller);
    final target = controller.currentTargetSnapshot!;
    controller.handlePointerDown(
      1,
      target.centreX - target.hitboxRadius - 30,
      target.centreY,
    );
    controller.handlePointerUp(1);
    controller.handlePointerMove(1, target.centreX, target.centreY);
    expect(delegate.captures, 0);
    controller.handlePointerDown(2, target.centreX, target.centreY);
    expect(delegate.captures, 1);
    advance(controller, 1.5);
    final nextTarget = controller.currentTargetSnapshot!;
    expect(nextTarget.active, isTrue);
    controller.handlePointerMove(2, nextTarget.centreX, nextTarget.centreY);
    expect(delegate.captures, 1);
  });

  test(
    'pending misses flush on interruption without becoming learning-valid',
    () {
      final (controller, delegate, _, _) = build();
      toActiveTarget(controller);
      final target = controller.currentTargetSnapshot!;
      controller.handlePointerDown(
        1,
        target.centreX - target.hitboxRadius - 30,
        target.centreY,
      );
      controller.interrupt();
      final trial = delegate.finalisedTrials.single.$1;
      expect(trial.missCount, 1);
      expect(trial.isValidForLearning, isFalse);
      expect(delegate.summary!.status, SessionStatus.interrupted);
    },
  );

  test('cancelled contacts release tracking and cannot sweep', () {
    final (controller, delegate, _, _) = build();
    toActiveTarget(controller);
    final target = controller.currentTargetSnapshot!;
    controller.handlePointerDown(
      1,
      target.centreX - target.hitboxRadius - 30,
      target.centreY,
    );
    controller.handlePointerCancel(1);
    controller.handlePointerMove(1, target.centreX, target.centreY);
    expect(controller.processor.activePointerCount, 0);
    expect(delegate.captures, 0);
  });

  test('touch during spawn-in does not count as a catch', () {
    final (controller, delegate, _, _) = build();
    // 3 s countdown + 0.1 s: target spawned but not touchable yet.
    advance(controller, 3.05 + 0.05);
    final snapshot = controller.currentTargetSnapshot!;
    expect(snapshot.active, isFalse);
    controller.handlePointerDown(1, snapshot.centreX, snapshot.centreY);
    expect(delegate.captures, 0);
    // Spawn-in is not an accuracy trial: no miss, frustration or raw touch.
    expect(controller.bufferedTouchCount, 0);
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

  test('paw contacts in the blank gap after timeout are not misses', () {
    final (controller, delegate, _, _) = build();
    toActiveTarget(controller);
    advance(controller, 12.1);
    expect(delegate.finalisedTrials, hasLength(1));
    controller.handlePointerDown(1, 600, 400);
    expect(controller.bufferedTouchCount, 0);
    controller.ownerRequestedEnd();
    expect(delegate.summary!.misses, 0);
  });

  test(
    'paw contacts during Touch and anticipation delay are not misses',
    () async {
      final cue = Completer<void>();
      final audio = FakeAudio()
        ..cues.add(CueType.touch)
        ..pendingCue = cue;
      final delegate = RecordingDelegate();
      final controller = GameSessionController(
        plan: plan(mode: SessionMode.touchTraining),
        tuning: defaultPlayTuning,
        constraints: const SafetyConstraints(),
        trialSource: FixedTrialSource(config),
        audio: audio,
        delegate: delegate,
        screenWidth: width,
        screenHeight: height,
      );
      controller.start();
      advance(controller, 3.1);
      controller.handlePointerDown(1, 600, 400);
      expect(controller.bufferedTouchCount, 0);
      cue.complete();
      await Future<void>.delayed(Duration.zero);
      controller.handlePointerDown(2, 610, 410);
      expect(controller.bufferedTouchCount, 0);
      advance(controller, 1);
      final target = controller.currentTargetSnapshot!;
      controller.handlePointerDown(3, target.centreX, target.centreY);
      expect(delegate.finalisedTrials.single.$1.success, isTrue);
      expect(delegate.finalisedTrials.single.$1.missCount, 0);
      expect(delegate.finalisedTrials.single.$1.frustrationSeverity, 0);
    },
  );

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

  test(
    'interruption finalises the active trial once without a farewell cue',
    () {
      final (controller, delegate, audio, _) = build();
      audio.cues.add(CueType.allDone);
      toActiveTarget(controller);
      controller.interrupt();
      controller.interrupt();
      expect(delegate.summary!.status, SessionStatus.interrupted);
      expect(delegate.finalisedTrials, hasLength(1));
      expect(delegate.finalisedTrials.single.$1.isValidForLearning, isFalse);
      expect(audio.playedCues, isEmpty);
    },
  );

  for (final soundSwitch in [false, true]) {
    test(
      'recorded cues obey ${soundSwitch ? 'sound-sensitivity safety' : 'sound off'}',
      () {
        final delegate = RecordingDelegate();
        final audio = FakeAudio()..cues.addAll(CueType.values);
        final controller = GameSessionController(
          plan: plan(
            mode: SessionMode.touchTraining,
            soundEnabled: soundSwitch,
          ),
          tuning: defaultPlayTuning,
          constraints: SafetyConstraints(soundAllowed: !soundSwitch),
          trialSource: FixedTrialSource(config),
          audio: audio,
          delegate: delegate,
          screenWidth: width,
          screenHeight: height,
        );
        controller.start();
        toActiveTarget(controller);
        final target = controller.currentTargetSnapshot!;
        controller.handlePointerDown(1, target.centreX, target.centreY);
        controller.ownerRequestedEnd();
        expect(delegate.captures, 1);
        expect(audio.playedCues, isEmpty);
        expect(audio.playedEffects, isEmpty);
        expect(delegate.finalisedTrials.single.$1.cueType, isNull);
        expect(delegate.finalisedTrials.single.$1.praiseCueType, isNull);
      },
    );
  }

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
    for (var i = 0; i < 9; i++) {
      catchCurrentTarget(controller, 100 + i);
      final reminded = delegate.finalisedTrials.last.$1.rewardReminderShown;
      advance(controller, reminded ? 5.4 : 1.6);
    }
    final catches = delegate.captures;
    expect(catches, 9);
    // 3rd and 6th catch remind; the cap (2) stops the 9th.
    expect(delegate.rewardReminders, 2);
    final flagged = delegate.finalisedTrials
        .where((entry) => entry.$1.rewardReminderShown)
        .length;
    expect(flagged, 2);
    expect(
      delegate.spawns,
      hasLength(10),
      reason: 'no extra pause after the reminder cap',
    );
  });

  for (final rewards in [
    RewardSchedule.none,
    RewardSchedule.manualOnly,
    RewardSchedule.everyThreeCatches,
  ]) {
    test('ordinary catches keep normal pacing for ${rewards.name}', () {
      final (controller, delegate, _, _) = build(
        sessionPlan: plan(rewards: rewards),
      );
      toActiveTarget(controller);
      catchCurrentTarget(controller, 1);
      advance(controller, 1.05);
      expect(delegate.spawns, hasLength(1));
      advance(controller, 0.1);
      expect(delegate.spawns, hasLength(2));
      expect(delegate.rewardReminders, 0);
    });
  }

  test('shown reward reminder leaves five seconds before the next hunt', () {
    final (controller, delegate, _, _) = build(
      sessionPlan: plan(rewards: RewardSchedule.everyThreeCatches),
    );
    catchFirstThree(controller);
    expect(delegate.rewardReminders, 1);
    advance(controller, 4.8);
    expect(delegate.spawns, hasLength(3));
    expect(controller.currentTargetSnapshot, isNull);
    advance(controller, 0.3);
    expect(delegate.spawns, hasLength(4));
    expect(
      controller.disengagement.idleMs(controller.sessionMs),
      lessThan(200),
      reason: 'reward delivery must not count as lost engagement',
    );
  });

  test('reward pause finishes before the next Touch cue begins', () async {
    final (controller, delegate, audio, _) = build(
      sessionPlan: plan(
        mode: SessionMode.touchTraining,
        rewards: RewardSchedule.everyThreeCatches,
      ),
    );
    audio.cues.add(CueType.touch);
    advance(controller, 3.05);
    await Future<void>.delayed(Duration.zero);
    advance(controller, 1.1);
    for (var i = 0; i < 3; i++) {
      catchCurrentTarget(controller, i + 1);
      if (i < 2) {
        advance(controller, 1.2);
        await Future<void>.delayed(Duration.zero);
        advance(controller, 1.1);
      }
    }
    expect(delegate.rewardReminders, 1);
    expect(audio.playedCues.where((cue) => cue == CueType.touch), hasLength(3));
    advance(controller, 4.8);
    expect(audio.playedCues.where((cue) => cue == CueType.touch), hasLength(3));
    advance(controller, 0.3);
    expect(audio.playedCues.where((cue) => cue == CueType.touch), hasLength(4));
    expect(
      delegate.spawns,
      hasLength(3),
      reason: 'the next cue still precedes its prey',
    );
    await Future<void>.delayed(Duration.zero);
    advance(controller, 1.1);
    expect(delegate.spawns, hasLength(4));
  });

  test('reward pause still waits for longer recorded praise', () async {
    final (controller, delegate, audio, _) = build(
      sessionPlan: plan(rewards: RewardSchedule.everyThreeCatches),
    );
    toActiveTarget(controller);
    for (var i = 0; i < 2; i++) {
      catchCurrentTarget(controller, i + 1);
      advance(controller, 1.6);
    }
    final praise = Completer<void>();
    audio.cues.add(CueType.good);
    audio.pendingCue = praise;
    catchCurrentTarget(controller, 3);
    advance(controller, 5.1);
    expect(delegate.spawns, hasLength(3));
    praise.complete();
    await Future<void>.delayed(Duration.zero);
    advance(controller, 0.05);
    expect(delegate.spawns, hasLength(4));
  });

  test(
    'session cap can end a reward pause without spawning another target',
    () {
      final (controller, delegate, _, _) = build(
        sessionPlan: plan(
          duration: 9,
          rewards: RewardSchedule.everyThreeCatches,
        ),
      );
      catchFirstThree(controller);
      expect(delegate.rewardReminders, 1);
      advance(controller, 5.1);
      expect(controller.isEnded, isTrue);
      expect(delegate.summary!.status, SessionStatus.completed);
      expect(delegate.spawns, hasLength(3));
    },
  );

  test('backgrounding interrupts a reward pause permanently', () {
    final (controller, delegate, _, _) = build(
      sessionPlan: plan(rewards: RewardSchedule.everyThreeCatches),
    );
    catchFirstThree(controller);
    controller.appBackgrounded();
    advance(controller, 6);
    expect(delegate.summary!.status, SessionStatus.backgrounded);
    expect(delegate.spawns, hasLength(3));
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

  test(
    'Touch waits for a longer name greeting as well as the countdown',
    () async {
      final greeting = Completer<void>();
      final audio = FakeAudio()
        ..cues.addAll([CueType.catName, CueType.touch])
        ..pendingCue = greeting;
      final delegate = RecordingDelegate();
      final controller = GameSessionController(
        plan: plan(mode: SessionMode.touchTraining),
        tuning: defaultPlayTuning,
        constraints: const SafetyConstraints(),
        trialSource: FixedTrialSource(config),
        audio: audio,
        delegate: delegate,
        screenWidth: width,
        screenHeight: height,
      );
      controller.start();
      advance(controller, 4);
      expect(audio.playedCues, [CueType.catName]);
      expect(delegate.spawns, isEmpty);
      audio.pendingCue = null;
      greeting.complete();
      await Future<void>.delayed(Duration.zero);
      advance(controller, 0.05);
      await Future<void>.delayed(Duration.zero);
      expect(audio.playedCues, [CueType.catName, CueType.touch]);
      expect(delegate.spawns, isEmpty);
      advance(controller, 0.8);
      expect(delegate.spawns, hasLength(1));
    },
  );

  test('next trial waits until the recorded catch praise finishes', () async {
    final audio = FakeAudio()..cues.add(CueType.good);
    final delegate = RecordingDelegate();
    final controller = GameSessionController(
      plan: plan(mode: SessionMode.touchTraining),
      tuning: defaultPlayTuning,
      constraints: const SafetyConstraints(),
      trialSource: FixedTrialSource(config),
      audio: audio,
      delegate: delegate,
      screenWidth: width,
      screenHeight: height,
    );
    controller.start();
    toActiveTarget(controller);
    final praise = Completer<void>();
    audio.pendingCue = praise;
    final target = controller.currentTargetSnapshot!;
    controller.handlePointerDown(1, target.centreX, target.centreY);
    advance(controller, 3);
    expect(audio.playedCues, [CueType.good]);
    expect(delegate.spawns, hasLength(1));
    expect(delegate.finalisedTrials.single.$1.praiseCueType, CueType.good);
    praise.complete();
    await Future<void>.delayed(Duration.zero);
    advance(controller, 0.05);
    expect(delegate.spawns, hasLength(2));
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
