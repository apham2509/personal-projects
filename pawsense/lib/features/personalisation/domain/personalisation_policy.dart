import '../../../shared/models/enums.dart';

/// One prior seeded from a questionnaire answer: a small number of pseudo
/// impressions/successes written into the factor stats before any real
/// trial. Weak by design — with 4 pseudo-impressions against a confidence
/// scale of 20 and per-update decay, roughly 20 contradicting real trials
/// erase a prior's influence (verified by simulation test).
class PreferenceSeed {
  const PreferenceSeed({
    required this.factorType,
    required this.factorValue,
    required this.impressions,
    required this.successes,
  });

  final FactorType factorType;
  final String factorValue;
  final double impressions;
  final double successes;
}

/// Maps questionnaire answers to initial priors (docs/PERSONALISATION.md,
/// "Initial priors"). Pure; the repository writes the seeds.
///
/// Real-world prey mapping: feather -> moth (aerial flutterer),
/// ball -> mouse (ground runner); other/unknown seed nothing.
List<PreferenceSeed> seedsFromAnswers({
  required FavouritePrey? favouritePrey,
  required EnergyLevel energyLevel,
  required SoundSensitivity soundSensitivity,
}) {
  final seeds = <PreferenceSeed>[];

  final preySeed = switch (favouritePrey) {
    FavouritePrey.mouse || FavouritePrey.ball => PreyType.mouse,
    FavouritePrey.mothBug || FavouritePrey.feather => PreyType.moth,
    FavouritePrey.fish => PreyType.fish,
    FavouritePrey.other || FavouritePrey.unknown || null => null,
  };
  if (preySeed != null) {
    seeds.add(
      PreferenceSeed(
        factorType: FactorType.targetType,
        factorValue: preySeed.name,
        impressions: 4,
        successes: 3,
      ),
    );
  }

  switch (energyLevel) {
    case EnergyLevel.high:
      seeds.add(
        PreferenceSeed(
          factorType: FactorType.speedLevel,
          factorValue: SpeedLevel.medium.name,
          impressions: 4,
          successes: 3,
        ),
      );
    case EnergyLevel.low:
      seeds.add(
        PreferenceSeed(
          factorType: FactorType.speedLevel,
          factorValue: SpeedLevel.slow.name,
          impressions: 4,
          successes: 3,
        ),
      );
    case EnergyLevel.medium:
      break;
  }

  if (soundSensitivity == SoundSensitivity.enjoysSound) {
    seeds.add(
      PreferenceSeed(
        factorType: FactorType.soundMode,
        factorValue: SoundMode.sound.name,
        impressions: 4,
        successes: 3,
      ),
    );
  }

  return seeds;
}

/// Per-update decay applied to a factor row's counters before incrementing
/// (DECISIONS.md D-005). 0.995 gives an effective memory of a few hundred
/// trials; old evidence fades, raw history stays in the database.
const double statsDecayPerUpdate = 0.995;

/// EWMA smoothing factor for reaction times.
const double reactionEwmaAlpha = 0.3;

/// Applies one trial's result to a factor's working stats. Pure; used by
/// the preference repository for every factor of every finished trial.
({
  double impressions,
  double successes,
  double timeouts,
  double totalMisses,
  double frustrationCount,
  double? reactionTimeEwmaMs,
  double cumulativeReward,
})
updateFactorStats({
  required double impressions,
  required double successes,
  required double timeouts,
  required double totalMisses,
  required double frustrationCount,
  required double? reactionTimeEwmaMs,
  required double cumulativeReward,
  required bool caught,
  required int? reactionTimeMs,
  required bool timedOut,
  required int trialMissCount,
  required int frustrationSeverity,
  required double trialReward,
}) {
  const d = statsDecayPerUpdate;
  double? newEwma = reactionTimeEwmaMs;
  if (caught && reactionTimeMs != null) {
    newEwma = newEwma == null
        ? reactionTimeMs.toDouble()
        : reactionEwmaAlpha * reactionTimeMs +
              (1 - reactionEwmaAlpha) * newEwma;
  }
  return (
    impressions: impressions * d + 1,
    successes: successes * d + (caught ? 1 : 0),
    timeouts: timeouts * d + (timedOut ? 1 : 0),
    totalMisses: totalMisses * d + trialMissCount,
    frustrationCount: frustrationCount * d + (frustrationSeverity > 0 ? 1 : 0),
    reactionTimeEwmaMs: newEwma,
    cumulativeReward: cumulativeReward + trialReward,
  );
}
