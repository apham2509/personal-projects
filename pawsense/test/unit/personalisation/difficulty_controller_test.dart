import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/features/personalisation/domain/difficulty_controller.dart';
import 'package:pawsense/shared/models/enums.dart';

void main() {
  TrialOutcome good({int reactionMs = 900}) => TrialOutcome(
    caught: true,
    reactionTimeMs: reactionMs,
    timedOut: false,
    frustrationSeverity: 0,
  );

  const timeout = TrialOutcome(
    caught: false,
    reactionTimeMs: null,
    timedOut: true,
    frustrationSeverity: 0,
  );

  test('increases by 1 after 5 strong trials (4+ catches, fast median)', () {
    final controller = DifficultyController(initialDifficulty: 3);
    var change = 0;
    for (var i = 0; i < 4; i++) {
      change = controller.onTrialCompleted(good());
      expect(change, 0, reason: 'window not full yet');
    }
    change = controller.onTrialCompleted(timeout);
    // 4/5 catches, median 900 ms, no frustration -> +1.
    expect(change, 1);
    expect(controller.difficulty, 4);
  });

  test('slow median blocks the increase', () {
    final controller = DifficultyController(initialDifficulty: 3);
    for (var i = 0; i < 5; i++) {
      controller.onTrialCompleted(good(reactionMs: 5000));
    }
    expect(controller.difficulty, 3);
  });

  test('frustration in the window blocks the increase', () {
    final controller = DifficultyController(initialDifficulty: 3);
    for (var i = 0; i < 4; i++) {
      controller.onTrialCompleted(good());
    }
    controller.onTrialCompleted(
      const TrialOutcome(
        caught: true,
        reactionTimeMs: 800,
        timedOut: false,
        frustrationSeverity: 2,
      ),
    );
    expect(controller.difficulty, 3);
  });

  test('cooldown: at least 3 trials between changes', () {
    final controller = DifficultyController(initialDifficulty: 3);
    for (var i = 0; i < 5; i++) {
      controller.onTrialCompleted(good());
    }
    expect(controller.difficulty, 4);
    // Window cleared on change; two more strong trials cannot re-trigger
    // within the cooldown even once the window refills.
    for (var i = 0; i < 4; i++) {
      controller.onTrialCompleted(good());
    }
    expect(controller.difficulty, 4, reason: 'window must refill');
    controller.onTrialCompleted(good());
    expect(controller.difficulty, 5);
  });

  test('decreases on 2 or fewer catches in the window', () {
    final controller = DifficultyController(initialDifficulty: 5);
    controller.onTrialCompleted(good());
    controller.onTrialCompleted(good());
    for (var i = 0; i < 3; i++) {
      controller.onTrialCompleted(
        const TrialOutcome(
          caught: false,
          reactionTimeMs: null,
          timedOut: false,
          frustrationSeverity: 0,
        ),
      );
    }
    expect(controller.difficulty, 4);
  });

  test('decreases on 2+ timeouts even with catches', () {
    final controller = DifficultyController(initialDifficulty: 5);
    controller.onTrialCompleted(good());
    controller.onTrialCompleted(timeout);
    controller.onTrialCompleted(good());
    controller.onTrialCompleted(timeout);
    controller.onTrialCompleted(good());
    expect(controller.difficulty, 4);
  });

  test('severity-3 trial forces an immediate drop, bypassing cooldown', () {
    final controller = DifficultyController(initialDifficulty: 6);
    final change = controller.onTrialCompleted(
      const TrialOutcome(
        caught: false,
        reactionTimeMs: null,
        timedOut: true,
        frustrationSeverity: 3,
      ),
    );
    expect(change, -1);
    expect(controller.difficulty, 5);
  });

  test('repeated high frustration drops by 2', () {
    final controller = DifficultyController(initialDifficulty: 8);
    controller.onTrialCompleted(
      const TrialOutcome(
        caught: false,
        reactionTimeMs: null,
        timedOut: true,
        frustrationSeverity: 3,
      ),
    );
    expect(controller.difficulty, 7);
    final change = controller.onTrialCompleted(
      const TrialOutcome(
        caught: false,
        reactionTimeMs: null,
        timedOut: true,
        frustrationSeverity: 3,
      ),
    );
    expect(change, -2);
    expect(controller.difficulty, 5);
  });

  test('difficulty clamps to [0, 10]', () {
    final low = DifficultyController(initialDifficulty: 0);
    for (var i = 0; i < 10; i++) {
      low.onTrialCompleted(
        const TrialOutcome(
          caught: false,
          reactionTimeMs: null,
          timedOut: true,
          frustrationSeverity: 3,
        ),
      );
    }
    expect(low.difficulty, 0);

    final high = DifficultyController(initialDifficulty: 10);
    for (var i = 0; i < 20; i++) {
      high.onTrialCompleted(good());
    }
    expect(high.difficulty, 10);
  });

  test('difficulty bands widen with difficulty and stay non-empty', () {
    for (var d = 0; d <= 10; d++) {
      expect(DifficultyBands.sizes(d), isNotEmpty);
      expect(DifficultyBands.speeds(d), isNotEmpty);
      expect(DifficultyBands.movements(d), isNotEmpty);
    }
    expect(DifficultyBands.sizes(0), [SizeLevel.large]);
    expect(DifficultyBands.speeds(0), [SpeedLevel.slow]);
    expect(DifficultyBands.movements(0), [MovementStyle.smooth]);
    expect(DifficultyBands.speeds(10), contains(SpeedLevel.fast));
    expect(DifficultyBands.sizes(10), contains(SizeLevel.small));
    expect(DifficultyBands.movements(10), containsAll(MovementStyle.values));
  });
}
