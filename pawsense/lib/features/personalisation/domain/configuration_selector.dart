import 'dart:math' as math;

import '../../../core/random/seeded_random.dart';
import '../../../shared/models/enums.dart';
import '../../../shared/models/trial_configuration.dart';
import 'difficulty_controller.dart';
import 'preference_scoring.dart';
import 'safety_constraints.dart';

class SelectionConfig {
  const SelectionConfig({
    this.explorationCoefficient = 0.15,
    this.exploitProbability = 0.8,
    this.topBandWidth = 0.03,
    this.maxConsecutiveSamePrey = 3,
  });

  /// UCB-style bonus coefficient.
  final double explorationCoefficient;

  /// Probability of exploiting (choosing among top-scoring configurations);
  /// otherwise an underexplored safe configuration is chosen.
  final double exploitProbability;

  /// Configurations scoring within this of the best are the "top band"
  /// exploited from (avoids always repeating the single argmax).
  final double topBandWidth;

  /// Never show the same prey type more than this many times in a row.
  final int maxConsecutiveSamePrey;
}

/// Factor weights for the configuration score (sum 1.0). Spawn zone is
/// deliberately excluded from scoring weights: it is selected by lowest
/// exploration count among allowed zones, keeping placement varied.
const Map<FactorType, double> factorWeights = {
  FactorType.targetType: 0.30,
  FactorType.movementStyle: 0.25,
  FactorType.speedLevel: 0.20,
  FactorType.sizeLevel: 0.15,
  FactorType.soundMode: 0.10,
};

/// Picks the next trial configuration: 80% exploit / 20% explore over
/// factor-level utilities with a UCB exploration bonus, constrained by the
/// difficulty band, hard safety constraints, and repetition rules.
///
/// Deterministic given (snapshot, rng state, history) — simulation tests
/// rely on this.
class ConfigurationSelector {
  const ConfigurationSelector({
    this.scorer = const PreferenceScorer(),
    this.config = const SelectionConfig(),
  });

  final PreferenceScorer scorer;
  final SelectionConfig config;

  TrialConfiguration select({
    required PreferenceSnapshot snapshot,
    required SafetyConstraints constraints,
    required int difficulty,
    required SeededRandom rng,
    required List<TrialConfiguration> history,
    required bool soundEnabledThisSession,
  }) {
    final candidates = _candidates(
      constraints: constraints,
      difficulty: difficulty,
      history: history,
      soundEnabledThisSession: soundEnabledThisSession,
    );
    assert(candidates.isNotEmpty, 'candidate space can never be empty');

    final explore = rng.nextDouble() >= config.exploitProbability;

    if (explore) {
      // Least-explored candidate (by summed factor impressions), ties broken
      // by seeded random pick.
      var minImpressions = double.infinity;
      final least = <TrialConfiguration>[];
      for (final candidate in candidates) {
        final impressions = _summedImpressions(snapshot, candidate);
        if (impressions < minImpressions - 1e-9) {
          minImpressions = impressions;
          least
            ..clear()
            ..add(candidate);
        } else if ((impressions - minImpressions).abs() <= 1e-9) {
          least.add(candidate);
        }
      }
      return rng.pick(least);
    }

    // Exploit: score every candidate, pick among the top band.
    var best = double.negativeInfinity;
    final scored = <(TrialConfiguration, double)>[];
    for (final candidate in candidates) {
      final score = configurationScore(snapshot, candidate);
      scored.add((candidate, score));
      if (score > best) best = score;
    }
    final top = [
      for (final (candidate, score) in scored)
        if (score >= best - config.topBandWidth) candidate,
    ];
    return rng.pick(top);
  }

  /// Weighted factor utilities plus exploration bonus; public for the
  /// developer screen and tests.
  double configurationScore(
    PreferenceSnapshot snapshot,
    TrialConfiguration candidate,
  ) {
    var score = 0.0;
    for (final entry in factorWeights.entries) {
      final stats = snapshot.statsFor(
        entry.key,
        candidate.factorValue(entry.key),
      );
      final utility =
          scorer.utility(stats) + explorationBonus(snapshot, entry.key, stats);
      score += entry.value * utility;
    }
    return score;
  }

  /// UCB-style bonus: rarely shown values of a well-explored factor get a
  /// boost. Public for tests and the developer screen.
  double explorationBonus(
    PreferenceSnapshot snapshot,
    FactorType factor,
    FactorStats stats,
  ) =>
      config.explorationCoefficient *
      math.sqrt(
        math.log(snapshot.totalForFactor(factor) + 1) / (stats.impressions + 1),
      );

  double _summedImpressions(
    PreferenceSnapshot snapshot,
    TrialConfiguration candidate,
  ) {
    var sum = 0.0;
    for (final factor in factorWeights.keys) {
      sum += snapshot
          .statsFor(factor, candidate.factorValue(factor))
          .impressions;
    }
    return sum;
  }

  List<TrialConfiguration> _candidates({
    required SafetyConstraints constraints,
    required int difficulty,
    required List<TrialConfiguration> history,
    required bool soundEnabledThisSession,
  }) {
    // Difficulty band intersected with safety; safety wins when empty.
    var sizes = DifficultyBands.sizes(
      difficulty,
    ).where(constraints.allowsSize).toList();
    if (sizes.isEmpty) sizes = [constraints.minSizeLevel];

    var speeds = DifficultyBands.speeds(
      difficulty,
    ).where(constraints.allowsSpeed).toList();
    if (speeds.isEmpty) speeds = [constraints.maxSpeedLevel];

    final movements = DifficultyBands.movements(difficulty);

    final sounds = <SoundMode>[
      SoundMode.silent,
      if (soundEnabledThisSession && constraints.soundAllowed) SoundMode.sound,
    ];

    final zones = constraints.centreZoneOnly
        ? const [SpawnZone.centre]
        : SpawnZone.values;

    // Repetition rules.
    final previous = history.isEmpty ? null : history.last;
    final bannedPrey = _bannedPrey(history);

    final candidates = <TrialConfiguration>[];
    for (final prey in PreyType.values) {
      if (prey == bannedPrey) continue;
      for (final movement in movements) {
        for (final speed in speeds) {
          for (final size in sizes) {
            for (final sound in sounds) {
              for (final zone in zones) {
                final candidate = TrialConfiguration(
                  preyType: prey,
                  movementStyle: movement,
                  speedLevel: speed,
                  sizeLevel: size,
                  soundMode: sound,
                  spawnZone: zone,
                );
                if (candidate == previous) continue;
                candidates.add(candidate);
              }
            }
          }
        }
      }
    }

    // The exact-repeat ban can only empty the space when there is a single
    // combination; in that degenerate case allow the repeat.
    if (candidates.isEmpty && previous != null) return [previous];
    return candidates;
  }

  PreyType? _bannedPrey(List<TrialConfiguration> history) {
    final n = config.maxConsecutiveSamePrey;
    if (history.length < n) return null;
    final recent = history.sublist(history.length - n);
    final first = recent.first.preyType;
    return recent.every((c) => c.preyType == first) ? first : null;
  }
}
