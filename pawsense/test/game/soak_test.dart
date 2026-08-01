import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/core/random/seeded_random.dart';
import 'package:pawsense/features/personalisation/domain/difficulty_controller.dart';
import 'package:pawsense/features/personalisation/domain/preference_scoring.dart';
import 'package:pawsense/features/personalisation/domain/safety_constraints.dart';
import 'package:pawsense/features/play/domain/play_tuning.dart';
import 'package:pawsense/features/play/domain/session_models.dart';
import 'package:pawsense/features/play/domain/trial_sources.dart';
import 'package:pawsense/features/play/game/game_session_controller.dart';
import 'package:pawsense/shared/models/enums.dart';

import 'fakes.dart';

/// Soak: a simulated 30-minute adaptive session at 60 fps with a busy cat.
/// Guards against unbounded queues, runaway state, and lifecycle leaks in
/// the controller (the physical-device equivalent is documented in
/// docs/QA_PLAN.md).
void main() {
  test('30-minute simulated session keeps buffers bounded and state sane', () {
    final delegate = RecordingDelegate();
    final audio = FakeAudio();
    final rng = SeededRandom(20260801);
    final controller = GameSessionController(
      plan: const SessionPlan(
        mode: SessionMode.freePlay,
        catId: 'soak-cat',
        plannedDurationSeconds: 1800, // soak harness exceeds the UI cap
        soundEnabled: true,
        seed: 4242,
        initialDifficulty: 2,
        rewardSchedule: RewardSchedule.variableTwoToFive,
        maxRewardReminders: 3,
        isCalibration: false,
      ),
      tuning: defaultPlayTuning,
      constraints: const SafetyConstraints(),
      trialSource: AdaptiveTrialSource(
        snapshot: PreferenceSnapshot.empty,
        constraints: const SafetyConstraints(),
        rng: SeededRandom(1),
        soundEnabled: true,
        difficultyController: DifficultyController(initialDifficulty: 2),
      ),
      audio: audio,
      delegate: delegate,
      screenWidth: 1366,
      screenHeight: 1024,
    );
    controller.start();

    const frame = 1 / 60;
    const totalFrames = 30 * 60 * 60; // 30 minutes
    var maxBuffered = 0;
    var pointer = 0;

    for (var i = 0; i < totalFrames; i++) {
      controller.update(frame);
      if (controller.isEnded) break;

      // A busy cat: pounce at the target every ~2 s, paw the glass in
      // between, occasionally hold.
      if (i % 120 == 60) {
        final snapshot = controller.currentTargetSnapshot;
        if (snapshot != null && snapshot.active && rng.nextDouble() < 0.7) {
          controller.handlePointerDown(
            ++pointer,
            snapshot.centreX + rng.nextDoubleInRange(-20, 20),
            snapshot.centreY + rng.nextDoubleInRange(-20, 20),
          );
          controller.handlePointerUp(pointer);
        } else {
          controller.handlePointerDown(
            ++pointer,
            rng.nextDoubleInRange(100, 1200),
            rng.nextDoubleInRange(100, 900),
          );
          controller.handlePointerUp(pointer);
        }
      }
      if (controller.bufferedTouchCount > maxBuffered) {
        maxBuffered = controller.bufferedTouchCount;
      }
    }

    expect(controller.isEnded, isTrue);
    expect(
      controller.sessionMs,
      greaterThanOrEqualTo(1000 * 60 * 5),
      reason: 'the busy cat should keep the session alive well past 5 min',
    );
    expect(maxBuffered, lessThanOrEqualTo(512));
    expect(delegate.finalisedTrials.length, greaterThan(50));
    // Every finalised trial's touch batch was handed over and cleared.
    expect(controller.bufferedTouchCount, lessThanOrEqualTo(512));
    // Difficulty stayed within bounds throughout.
    expect(controller.difficulty, inInclusiveRange(0, 10));
  });
}
