import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/features/personalisation/domain/preference_scoring.dart';
import 'package:pawsense/shared/models/enums.dart';

void main() {
  const scorer = PreferenceScorer();

  test('smoothed catch rate is Beta(2,2): empty stats score 0.5', () {
    expect(scorer.smoothedCatchRate(FactorStats.empty), 0.5);
    expect(
      scorer.smoothedCatchRate(
        const FactorStats(impressions: 10, successes: 8),
      ),
      closeTo((8 + 2) / (10 + 4), 1e-12),
    );
    expect(
      scorer.smoothedCatchRate(
        const FactorStats(impressions: 10, successes: 0),
      ),
      closeTo(2 / 14, 1e-12),
    );
  });

  test('reaction score neutral below 3 successes, then linear-clamped', () {
    expect(
      scorer.reactionScore(
        const FactorStats(
          impressions: 2,
          successes: 2,
          reactionTimeEwmaMs: 600,
        ),
      ),
      0.5,
      reason: 'too few successful observations',
    );
    expect(
      scorer.reactionScore(
        const FactorStats(
          impressions: 5,
          successes: 4,
          reactionTimeEwmaMs: 500,
        ),
      ),
      1.0,
    );
    expect(
      scorer.reactionScore(
        const FactorStats(
          impressions: 20,
          successes: 10,
          reactionTimeEwmaMs: 8000,
        ),
      ),
      0.0,
    );
    expect(
      scorer.reactionScore(
        const FactorStats(
          impressions: 20,
          successes: 10,
          reactionTimeEwmaMs: 4250,
        ),
      ),
      closeTo(0.5, 1e-9),
    );
    // Faster than the floor clamps to 1, slower than ceiling clamps to 0.
    expect(
      scorer.reactionScore(
        const FactorStats(
          impressions: 9,
          successes: 5,
          reactionTimeEwmaMs: 120,
        ),
      ),
      1.0,
    );
    expect(
      scorer.reactionScore(
        const FactorStats(
          impressions: 9,
          successes: 5,
          reactionTimeEwmaMs: 20000,
        ),
      ),
      0.0,
    );
  });

  test('calm and timeout scores match spec formulas with clamping', () {
    const stats = FactorStats(
      impressions: 16,
      successes: 8,
      timeouts: 4,
      frustrationCount: 2,
    );
    expect(
      scorer.calmInteractionScore(stats),
      closeTo(1 - (2 + 1) / (16 + 4), 1e-12),
    );
    expect(scorer.timeoutScore(stats), closeTo(1 - (4 + 1) / (16 + 4), 1e-12));
    // Pathological stats still clamp to [0,1].
    const awful = FactorStats(impressions: 1, frustrationCount: 30);
    expect(scorer.calmInteractionScore(awful), 0.0);
  });

  test('utility is the documented weighted blend', () {
    const stats = FactorStats(
      impressions: 20,
      successes: 15,
      timeouts: 2,
      frustrationCount: 1,
      reactionTimeEwmaMs: 2000,
    );
    final expected =
        0.50 * scorer.smoothedCatchRate(stats) +
        0.25 * scorer.reactionScore(stats) +
        0.15 * scorer.calmInteractionScore(stats) +
        0.10 * scorer.timeoutScore(stats);
    expect(scorer.utility(stats), closeTo(expected, 1e-12));
  });

  test('confidence saturates at 20 impressions', () {
    expect(scorer.confidence(FactorStats.empty), 0);
    expect(
      scorer.confidence(const FactorStats(impressions: 10)),
      closeTo(0.5, 1e-12),
    );
    expect(scorer.confidence(const FactorStats(impressions: 20)), 1.0);
    expect(scorer.confidence(const FactorStats(impressions: 200)), 1.0);
  });

  test('confidence tiers follow the documented sample thresholds', () {
    expect(confidenceTierFor(0), ConfidenceTier.insufficient);
    expect(confidenceTierFor(7), ConfidenceTier.insufficient);
    expect(confidenceTierFor(8), ConfidenceTier.earlyObservation);
    expect(confidenceTierFor(19), ConfidenceTier.earlyObservation);
    expect(confidenceTierFor(20), ConfidenceTier.developingPattern);
    expect(confidenceTierFor(49), ConfidenceTier.developingPattern);
    expect(confidenceTierFor(50), ConfidenceTier.strongPattern);
  });
}
