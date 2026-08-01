import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/core/random/seeded_random.dart';
import 'package:pawsense/features/personalisation/domain/configuration_selector.dart';
import 'package:pawsense/features/personalisation/domain/preference_scoring.dart';
import 'package:pawsense/features/personalisation/domain/safety_constraints.dart';
import 'package:pawsense/shared/models/enums.dart';
import 'package:pawsense/shared/models/trial_configuration.dart';

void main() {
  const selector = ConfigurationSelector();

  PreferenceSnapshot snapshotFavouring(PreyType prey) {
    return PreferenceSnapshot(
      totalTrials: 60,
      stats: {
        FactorType.targetType: {
          for (final p in PreyType.values)
            p.name: p == prey
                ? const FactorStats(
                    impressions: 20,
                    successes: 18,
                    reactionTimeEwmaMs: 900,
                  )
                : const FactorStats(
                    impressions: 20,
                    successes: 4,
                    reactionTimeEwmaMs: 5000,
                  ),
        },
      },
    );
  }

  test('factor weights are the documented ones and sum to 1', () {
    expect(factorWeights[FactorType.targetType], 0.30);
    expect(factorWeights[FactorType.movementStyle], 0.25);
    expect(factorWeights[FactorType.speedLevel], 0.20);
    expect(factorWeights[FactorType.sizeLevel], 0.15);
    expect(factorWeights[FactorType.soundMode], 0.10);
    expect(factorWeights.values.reduce((a, b) => a + b), closeTo(1.0, 1e-12));
  });

  test('exploration bonus follows the UCB formula', () {
    final snapshot = PreferenceSnapshot(
      totalTrials: 100,
      stats: {
        FactorType.targetType: {
          'mouse': const FactorStats(impressions: 99),
          'moth': const FactorStats(impressions: 1),
        },
      },
    );
    final rare = selector.explorationBonus(
      snapshot,
      FactorType.targetType,
      snapshot.statsFor(FactorType.targetType, 'moth'),
    );
    final common = selector.explorationBonus(
      snapshot,
      FactorType.targetType,
      snapshot.statsFor(FactorType.targetType, 'mouse'),
    );
    expect(rare, greaterThan(common));
    // Exact value check for the rare arm: 0.15*sqrt(ln(101)/2).
    expect(rare, closeTo(0.15 * 1.5192, 1e-3));
  });

  TrialConfiguration selectOnce(
    SeededRandom rng, {
    PreferenceSnapshot? snapshot,
    SafetyConstraints constraints = const SafetyConstraints(),
    int difficulty = 5,
    List<TrialConfiguration> history = const [],
    bool sound = true,
  }) => selector.select(
    snapshot: snapshot ?? PreferenceSnapshot.empty,
    constraints: constraints,
    difficulty: difficulty,
    rng: rng,
    history: history,
    soundEnabledThisSession: sound,
  );

  test('safety constraints are never violated across 5000 selections', () {
    final constraints = SafetyConstraints.fromAnswers(
      soundSensitivity: SoundSensitivity.easilyStartled,
      visionConsideration: VisionConsideration.reducedVision,
      mobilityConsideration: MobilityConsideration.limitedMovement,
    );
    final rng = SeededRandom(1);
    final history = <TrialConfiguration>[];
    for (var i = 0; i < 5000; i++) {
      final config = selectOnce(
        rng,
        constraints: constraints,
        difficulty: i % 11,
        history: history,
      );
      expect(
        constraints.allows(config),
        isTrue,
        reason: 'violation at selection $i: $config',
      );
      history.add(config);
      if (history.length > 10) history.removeAt(0);
    }
  });

  test('difficulty bands constrain size and speed', () {
    final rng = SeededRandom(2);
    for (var i = 0; i < 500; i++) {
      final easy = selectOnce(rng, difficulty: 0);
      expect(easy.sizeLevel, SizeLevel.large);
      expect(easy.speedLevel, SpeedLevel.slow);
      expect(easy.movementStyle, MovementStyle.smooth);
    }
    for (var i = 0; i < 500; i++) {
      final hard = selectOnce(rng, difficulty: 10);
      expect(hard.sizeLevel, isNot(SizeLevel.large));
      expect(hard.speedLevel, isNot(SpeedLevel.slow));
    }
  });

  test('never repeats the exact previous configuration', () {
    final rng = SeededRandom(3);
    final history = <TrialConfiguration>[];
    for (var i = 0; i < 2000; i++) {
      final config = selectOnce(rng, history: history, difficulty: 3);
      if (history.isNotEmpty) {
        expect(config, isNot(history.last), reason: 'repeat at $i');
      }
      history.add(config);
    }
  });

  test('never shows the same prey more than 3 times consecutively', () {
    final rng = SeededRandom(4);
    final history = <TrialConfiguration>[];
    for (var i = 0; i < 3000; i++) {
      final config = selectOnce(
        rng,
        snapshot: snapshotFavouring(PreyType.moth),
        history: history,
      );
      history.add(config);
    }
    for (var i = 3; i < history.length; i++) {
      final run = history
          .sublist(i - 3, i + 1)
          .every((c) => c.preyType == history[i].preyType);
      expect(run, isFalse, reason: 'four-in-a-row ending at $i');
    }
  });

  test('80/20: exploitation dominates but exploration persists', () {
    final snapshot = snapshotFavouring(PreyType.fish);
    final rng = SeededRandom(5);
    final history = <TrialConfiguration>[];
    var fishCount = 0;
    const n = 4000;
    for (var i = 0; i < n; i++) {
      final config = selectOnce(rng, snapshot: snapshot, history: history);
      if (config.preyType == PreyType.fish) fishCount++;
      history.add(config);
      if (history.length > 6) history.removeAt(0);
    }
    final fishShare = fishCount / n;
    // Exploit picks fish (top band) ~80% minus the 3-run breaker; explore
    // picks the least-tried arms. Empirically ~0.55-0.75; assert the
    // qualitative property with slack.
    expect(
      fishShare,
      greaterThan(0.5),
      reason: 'preferred prey must dominate ($fishShare)',
    );
    expect(
      fishShare,
      lessThan(0.9),
      reason: 'exploration must persist ($fishShare)',
    );
  });

  test('selection is deterministic given identical rng state and inputs', () {
    final a = selectOnce(
      SeededRandom(77),
      snapshot: snapshotFavouring(PreyType.mouse),
    );
    final b = selectOnce(
      SeededRandom(77),
      snapshot: snapshotFavouring(PreyType.mouse),
    );
    expect(a, b);
  });

  test('sound only appears when session, safety, and config all allow', () {
    final rng = SeededRandom(6);
    for (var i = 0; i < 400; i++) {
      final config = selectOnce(rng, sound: false);
      expect(config.soundMode, SoundMode.silent);
    }
    final startled = SafetyConstraints.fromAnswers(
      soundSensitivity: SoundSensitivity.easilyStartled,
      visionConsideration: VisionConsideration.noneKnown,
      mobilityConsideration: MobilityConsideration.none,
    );
    for (var i = 0; i < 400; i++) {
      final config = selectOnce(rng, constraints: startled);
      expect(config.soundMode, SoundMode.silent);
    }
  });
}
