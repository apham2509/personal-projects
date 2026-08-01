import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/core/random/seeded_random.dart';
import 'package:pawsense/features/personalisation/domain/configuration_selector.dart';
import 'package:pawsense/features/personalisation/domain/difficulty_controller.dart';
import 'package:pawsense/features/personalisation/domain/personalisation_policy.dart';
import 'package:pawsense/features/personalisation/domain/preference_scoring.dart';
import 'package:pawsense/features/personalisation/domain/safety_constraints.dart';
import 'package:pawsense/shared/models/enums.dart';
import 'package:pawsense/shared/models/trial_configuration.dart';

/// A synthetic cat with a ground-truth preference, used to verify that the
/// full personalisation loop (selection -> outcome -> stats update ->
/// difficulty) behaves as documented.
class SimulatedCat {
  SimulatedCat({
    required this.lovedPrey,
    required this.lovedMovement,
    this.baseCatchProbability = 0.25,
    this.lovedCatchProbability = 0.9,
  });

  final PreyType lovedPrey;
  final MovementStyle lovedMovement;
  final double baseCatchProbability;
  final double lovedCatchProbability;

  double catchProbability(TrialConfiguration config) {
    var p = baseCatchProbability;
    if (config.preyType == lovedPrey) p += 0.35;
    if (config.movementStyle == lovedMovement) p += 0.3;
    return p.clamp(0.0, lovedCatchProbability);
  }

  int reactionMs(TrialConfiguration config, SeededRandom rng) {
    final loved =
        config.preyType == lovedPrey && config.movementStyle == lovedMovement;
    final base = loved ? 900 : 3200;
    return base + rng.nextInt(800);
  }
}

/// Runs the full in-memory personalisation loop, mirroring the production
/// wiring (selector + difficulty controller + decayed stats updates).
class SimulationRun {
  SimulationRun({
    required this.cat,
    required int seed,
    List<PreferenceSeed> priors = const [],
    this.constraints = const SafetyConstraints(),
    int initialDifficulty = 2,
  }) : rng = SeededRandom(seed),
       difficulty = DifficultyController(initialDifficulty: initialDifficulty) {
    for (final prior in priors) {
      _stats.putIfAbsent(
        prior.factorType,
        () => {},
      )[prior.factorValue] = FactorStats(
        impressions: prior.impressions,
        successes: prior.successes,
      );
    }
  }

  final SimulatedCat cat;
  final SeededRandom rng;
  final DifficultyController difficulty;
  final SafetyConstraints constraints;
  static const selector = ConfigurationSelector();
  static const rewardCalculator = TrialRewardCalculator();

  final Map<FactorType, Map<String, FactorStats>> _stats = {};
  final List<TrialConfiguration> history = [];
  final List<bool> outcomes = [];
  final List<int> difficultyTrace = [];
  int rawImpressionsFor(PreyType prey) =>
      history.where((c) => c.preyType == prey).length;

  PreferenceSnapshot get snapshot {
    var total = 0.0;
    for (final s in (_stats[FactorType.targetType] ?? const {}).values) {
      total += s.impressions;
    }
    return PreferenceSnapshot(stats: _stats, totalTrials: total);
  }

  FactorStats statsFor(FactorType type, String value) =>
      _stats[type]?[value] ?? FactorStats.empty;

  void runTrials(int count) {
    for (var i = 0; i < count; i++) {
      final config = selector.select(
        snapshot: snapshot,
        constraints: constraints,
        difficulty: difficulty.difficulty,
        rng: rng,
        history: history,
        soundEnabledThisSession: true,
      );
      expect(
        constraints.allows(config),
        isTrue,
        reason: 'simulation produced unsafe config $config',
      );

      final caught = rng.nextDouble() < cat.catchProbability(config);
      final reaction = caught ? cat.reactionMs(config, rng) : null;
      final timedOut = !caught;
      final missCount = caught ? 0 : rng.nextInt(3);

      difficulty.onTrialCompleted(
        TrialOutcome(
          caught: caught,
          reactionTimeMs: reaction,
          timedOut: timedOut,
          frustrationSeverity: 0,
        ),
      );

      final reward = rewardCalculator.calculate(
        caught: caught,
        reactionTimeMs: reaction,
        missCount: missCount,
        frustrationSeverity: 0,
        timedOut: timedOut,
      );
      for (final factor in FactorType.values) {
        final value = config.factorValue(factor);
        final current = statsFor(factor, value);
        final updated = updateFactorStats(
          impressions: current.impressions,
          successes: current.successes,
          timeouts: current.timeouts,
          totalMisses: current.totalMisses,
          frustrationCount: current.frustrationCount,
          reactionTimeEwmaMs: current.reactionTimeEwmaMs,
          cumulativeReward: current.cumulativeReward,
          caught: caught,
          reactionTimeMs: reaction,
          timedOut: timedOut,
          trialMissCount: missCount,
          frustrationSeverity: 0,
          trialReward: reward,
        );
        _stats.putIfAbsent(factor, () => {})[value] = FactorStats(
          impressions: updated.impressions,
          successes: updated.successes,
          timeouts: updated.timeouts,
          totalMisses: updated.totalMisses,
          frustrationCount: updated.frustrationCount,
          reactionTimeEwmaMs: updated.reactionTimeEwmaMs,
          cumulativeReward: updated.cumulativeReward,
        );
      }
      history.add(config);
      outcomes.add(caught);
      difficultyTrace.add(difficulty.difficulty);
    }
  }
}

void main() {
  const scorer = PreferenceScorer();

  test('personalisation converges towards a simulated preference', () {
    final run = SimulationRun(
      cat: SimulatedCat(
        lovedPrey: PreyType.moth,
        lovedMovement: MovementStyle.unpredictable,
      ),
      seed: 2026,
    );
    run.runTrials(800);

    // The loved prey dominates recent selections.
    final recent = run.history.sublist(run.history.length - 200);
    final mothShare =
        recent.where((c) => c.preyType == PreyType.moth).length / 200;
    expect(
      mothShare,
      greaterThan(0.45),
      reason: 'moth share in last 200 trials was $mothShare',
    );

    // And its learned utility clearly tops the alternatives.
    final mothUtility = scorer.utility(
      run.statsFor(FactorType.targetType, 'moth'),
    );
    final mouseUtility = scorer.utility(
      run.statsFor(FactorType.targetType, 'mouse'),
    );
    final fishUtility = scorer.utility(
      run.statsFor(FactorType.targetType, 'fish'),
    );
    expect(mothUtility, greaterThan(mouseUtility + favouriteUtilityGap));
    expect(mothUtility, greaterThan(fishUtility + favouriteUtilityGap));
  });

  test('exploration never dies: non-preferred options keep appearing', () {
    final run = SimulationRun(
      cat: SimulatedCat(
        lovedPrey: PreyType.fish,
        lovedMovement: MovementStyle.smooth,
      ),
      seed: 7,
    );
    run.runTrials(900);
    final recent = run.history.sublist(run.history.length - 300);
    for (final prey in PreyType.values) {
      final share =
          recent.where((c) => c.preyType == prey).length / recent.length;
      expect(
        share,
        greaterThan(0.05),
        reason: '${prey.name} vanished from selection ($share)',
      );
    }
  });

  test('safety constraints hold across thousands of adaptive trials', () {
    final constraints = SafetyConstraints.fromAnswers(
      soundSensitivity: SoundSensitivity.easilyStartled,
      visionConsideration: VisionConsideration.reducedVision,
      mobilityConsideration: MobilityConsideration.seniorFriendly,
    );
    final run = SimulationRun(
      cat: SimulatedCat(
        lovedPrey: PreyType.mouse,
        lovedMovement: MovementStyle.stopAndGo,
      ),
      seed: 99,
      constraints: constraints,
    );
    // runTrials asserts constraint satisfaction on every selection.
    run.runTrials(3000);
    expect(run.history.every(constraints.allows), isTrue);
  });

  test('difficulty falls for a struggling cat and never overwhelms it', () {
    final run = SimulationRun(
      cat: SimulatedCat(
        lovedPrey: PreyType.mouse,
        lovedMovement: MovementStyle.smooth,
        baseCatchProbability: 0.05,
        lovedCatchProbability: 0.1,
      ),
      seed: 13,
      initialDifficulty: 5,
    );
    run.runTrials(120);
    expect(
      run.difficulty.difficulty,
      lessThanOrEqualTo(1),
      reason: 'difficulty should collapse for constant failure',
    );
    // Difficulty never exceeded its start.
    expect(run.difficultyTrace.every((d) => d <= 5), isTrue);
  });

  test('difficulty rises for a thriving cat, gated and gradual', () {
    final run = SimulationRun(
      cat: SimulatedCat(
        lovedPrey: PreyType.mouse,
        lovedMovement: MovementStyle.smooth,
        baseCatchProbability: 0.85,
        lovedCatchProbability: 0.95,
      ),
      seed: 21,
      initialDifficulty: 2,
    );
    run.runTrials(200);
    expect(run.difficulty.difficulty, greaterThanOrEqualTo(5));
    // Gradual: no jump larger than 1 upwards between consecutive trials.
    for (var i = 1; i < run.difficultyTrace.length; i++) {
      expect(
        run.difficultyTrace[i] - run.difficultyTrace[i - 1],
        lessThanOrEqualTo(1),
      );
    }
  });

  test('a single lucky trial cannot create a strong preference claim', () {
    // One fish catch and nothing else.
    const luckyStats = FactorStats(
      impressions: 1,
      successes: 1,
      reactionTimeEwmaMs: 700,
    );
    // The utility may be high, but the sample size gates any claim.
    expect(confidenceTierFor(1), ConfidenceTier.insufficient);
    expect(confidenceTierFor(7), ConfidenceTier.insufficient);
    // And confidence (selection-side) is proportionally tiny.
    expect(scorer.confidence(luckyStats), closeTo(0.05, 1e-9));
  });

  test('owner priors are overpowered by contradicting evidence', () {
    // Owner says mouse; the cat actually loves fish.
    final run = SimulationRun(
      cat: SimulatedCat(
        lovedPrey: PreyType.fish,
        lovedMovement: MovementStyle.smooth,
      ),
      seed: 31,
      priors: seedsFromAnswers(
        favouritePrey: FavouritePrey.mouse,
        energyLevel: EnergyLevel.medium,
        soundSensitivity: SoundSensitivity.neutral,
      ),
    );
    // Before evidence: the prior makes mouse look best.
    final priorMouse = scorer.utility(
      run.statsFor(FactorType.targetType, 'mouse'),
    );
    final priorFish = scorer.utility(
      run.statsFor(FactorType.targetType, 'fish'),
    );
    expect(priorMouse, greaterThan(priorFish));

    run.runTrials(150);
    final learnedMouse = scorer.utility(
      run.statsFor(FactorType.targetType, 'mouse'),
    );
    final learnedFish = scorer.utility(
      run.statsFor(FactorType.targetType, 'fish'),
    );
    expect(
      learnedFish,
      greaterThan(learnedMouse),
      reason: 'observed behaviour must outweigh the owner guess',
    );
  });
}
