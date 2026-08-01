import '../../../core/random/seeded_random.dart';
import '../../../shared/models/enums.dart';
import '../../../shared/models/trial_configuration.dart';
import '../../personalisation/domain/safety_constraints.dart';

/// The balanced first-session schedule.
class CalibrationSchedule {
  const CalibrationSchedule({
    required this.trials,
    required this.seed,
    required this.waivedBalances,
  });

  final List<TrialConfiguration> trials;
  final int seed;

  /// Factor balances that safety constraints forced us to waive (e.g. sound
  /// balance for a startle-sensitive cat). Shown to the owner in the
  /// calibration summary so the data's limits are transparent.
  final Set<FactorType> waivedBalances;
}

/// Generates a deterministic, balanced 12-trial calibration schedule.
///
/// Guarantees (property-tested across thousands of seeds):
/// - each prey type appears exactly 4 times;
/// - each movement style appears exactly 4 times;
/// - slow/medium speeds 6/6 (unless safety forces all-slow);
/// - large/medium sizes 6/6 (unless safety forces all-large);
/// - sound/silent 6/6 (unless sound is not allowed, then all silent);
/// - no exact configuration repeats consecutively;
/// - no prey type appears more than twice consecutively;
/// - every configuration satisfies [SafetyConstraints];
/// - identical (seed, constraints) inputs produce identical schedules.
class CalibrationScheduler {
  const CalibrationScheduler();

  static const int trialCount = 12;
  static const int _maxAttempts = 1000;

  CalibrationSchedule generate({
    required int seed,
    required SafetyConstraints constraints,
  }) {
    final rng = SeededRandom(seed);
    final waived = <FactorType>{};

    // Factor pools. Balanced by construction; safety may collapse a pool.
    final preyPool = _repeat(PreyType.values, 4);
    final movementPool = _repeat(MovementStyle.values, 4);

    List<SpeedLevel> speedPool;
    if (constraints.allowsSpeed(SpeedLevel.medium)) {
      speedPool = _repeat(const [SpeedLevel.slow, SpeedLevel.medium], 6);
    } else {
      speedPool = List.filled(trialCount, SpeedLevel.slow);
      waived.add(FactorType.speedLevel);
    }

    List<SizeLevel> sizePool;
    if (constraints.allowsSize(SizeLevel.medium)) {
      sizePool = _repeat(const [SizeLevel.large, SizeLevel.medium], 6);
    } else {
      sizePool = List.filled(trialCount, SizeLevel.large);
      waived.add(FactorType.sizeLevel);
    }

    List<SoundMode> soundPool;
    if (constraints.soundAllowed) {
      soundPool = _repeat(const [SoundMode.silent, SoundMode.sound], 6);
    } else {
      soundPool = List.filled(trialCount, SoundMode.silent);
      waived.add(FactorType.soundMode);
    }

    List<SpawnZone> zonePool;
    if (constraints.centreZoneOnly) {
      zonePool = List.filled(trialCount, SpawnZone.centre);
      waived.add(FactorType.spawnZone);
    } else {
      // Centre-weighted variety: 4 centre + 2 of each edge zone.
      zonePool = [
        ...List.filled(4, SpawnZone.centre),
        ...List.filled(2, SpawnZone.top),
        ...List.filled(2, SpawnZone.bottom),
        ...List.filled(2, SpawnZone.left),
        ...List.filled(2, SpawnZone.right),
      ];
    }

    for (var attempt = 0; attempt < _maxAttempts; attempt++) {
      final attemptRng = rng.fork();
      final prey = [...preyPool];
      final movement = [...movementPool];
      final speed = [...speedPool];
      final size = [...sizePool];
      final sound = [...soundPool];
      final zone = [...zonePool];
      attemptRng.shuffle(prey);
      attemptRng.shuffle(movement);
      attemptRng.shuffle(speed);
      attemptRng.shuffle(size);
      attemptRng.shuffle(sound);
      attemptRng.shuffle(zone);

      final trials = List.generate(
        trialCount,
        (i) => TrialConfiguration(
          preyType: prey[i],
          movementStyle: movement[i],
          speedLevel: speed[i],
          sizeLevel: size[i],
          soundMode: sound[i],
          spawnZone: zone[i],
        ),
      );

      if (_valid(trials)) {
        return CalibrationSchedule(
          trials: trials,
          seed: seed,
          waivedBalances: waived,
        );
      }
    }
    // Statistically unreachable (property tests exercise thousands of seeds
    // without ever needing more than a handful of attempts).
    throw StateError('calibration schedule generation exhausted attempts');
  }

  bool _valid(List<TrialConfiguration> trials) {
    for (var i = 1; i < trials.length; i++) {
      if (trials[i] == trials[i - 1]) return false;
    }
    for (var i = 2; i < trials.length; i++) {
      if (trials[i].preyType == trials[i - 1].preyType &&
          trials[i].preyType == trials[i - 2].preyType) {
        return false;
      }
    }
    return true;
  }

  static List<T> _repeat<T>(List<T> values, int times) => [
    for (final v in values) ...List.filled(times, v),
  ];
}
