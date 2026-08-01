import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/features/personalisation/domain/preference_scoring.dart';

void main() {
  const calculator = TrialRewardCalculator();

  test('instant catch earns the maximum 1.25', () {
    expect(
      calculator.calculate(
        caught: true,
        reactionTimeMs: 300, // at/below floor -> full bonus
        missCount: 0,
        frustrationSeverity: 0,
        timedOut: false,
      ),
      1.25,
    );
  });

  test('slow catch earns no reaction bonus', () {
    expect(
      calculator.calculate(
        caught: true,
        reactionTimeMs: 9000,
        missCount: 0,
        frustrationSeverity: 0,
        timedOut: false,
      ),
      1.0,
    );
  });

  test('mid-speed catch earns a proportional bonus', () {
    final reward = calculator.calculate(
      caught: true,
      reactionTimeMs: 4250, // halfway between 500 and 8000
      missCount: 0,
      frustrationSeverity: 0,
      timedOut: false,
    );
    expect(reward, closeTo(1.125, 1e-9));
  });

  test('miss penalty caps at 3 misses', () {
    double reward(int misses) => calculator.calculate(
      caught: false,
      reactionTimeMs: null,
      missCount: misses,
      frustrationSeverity: 0,
      timedOut: false,
    );
    expect(reward(1), closeTo(-0.12, 1e-9));
    expect(reward(3), closeTo(-0.36, 1e-9));
    expect(reward(10), closeTo(-0.36, 1e-9), reason: 'capped at 3');
  });

  test('timeout and frustration stack', () {
    expect(
      calculator.calculate(
        caught: false,
        reactionTimeMs: null,
        missCount: 2,
        frustrationSeverity: 2,
        timedOut: true,
      ),
      closeTo(-0.24 - 0.40 - 0.25, 1e-9),
    );
  });

  test('reward clamps to the documented range [-1.0, 1.25]', () {
    expect(
      calculator.calculate(
        caught: false,
        reactionTimeMs: null,
        missCount: 3,
        frustrationSeverity: 3,
        timedOut: true,
      ),
      greaterThanOrEqualTo(-1.0),
    );
    // Upper bound already shown in the instant-catch test.
  });
}
