import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/features/calibration/domain/calibration_scheduler.dart';
import 'package:pawsense/features/personalisation/domain/safety_constraints.dart';
import 'package:pawsense/shared/models/enums.dart';
import 'package:pawsense/shared/models/trial_configuration.dart';

void main() {
  const scheduler = CalibrationScheduler();

  Map<T, int> countBy<T>(
    List<TrialConfiguration> trials,
    T Function(TrialConfiguration) key,
  ) {
    final counts = <T, int>{};
    for (final trial in trials) {
      counts[key(trial)] = (counts[key(trial)] ?? 0) + 1;
    }
    return counts;
  }

  test('property: balance and sequence constraints hold across 2000 seeds', () {
    for (var seed = 0; seed < 2000; seed++) {
      final schedule = scheduler.generate(
        seed: seed,
        constraints: const SafetyConstraints(),
      );
      final trials = schedule.trials;
      expect(trials, hasLength(12));
      expect(schedule.waivedBalances, isEmpty);

      // Exact factor balance.
      final prey = countBy(trials, (t) => t.preyType);
      for (final type in PreyType.values) {
        expect(prey[type], 4, reason: 'seed $seed prey balance');
      }
      final movement = countBy(trials, (t) => t.movementStyle);
      for (final style in MovementStyle.values) {
        expect(movement[style], 4, reason: 'seed $seed movement balance');
      }
      final speed = countBy(trials, (t) => t.speedLevel);
      expect(speed[SpeedLevel.slow], 6, reason: 'seed $seed');
      expect(speed[SpeedLevel.medium], 6, reason: 'seed $seed');
      expect(speed[SpeedLevel.fast], isNull);
      final size = countBy(trials, (t) => t.sizeLevel);
      expect(size[SizeLevel.large], 6);
      expect(size[SizeLevel.medium], 6);
      expect(size[SizeLevel.small], isNull);
      final sound = countBy(trials, (t) => t.soundMode);
      expect(sound[SoundMode.silent], 6);
      expect(sound[SoundMode.sound], 6);

      // Sequence constraints.
      for (var i = 1; i < trials.length; i++) {
        expect(
          trials[i],
          isNot(trials[i - 1]),
          reason: 'seed $seed: exact repeat at $i',
        );
      }
      for (var i = 2; i < trials.length; i++) {
        final sameThree =
            trials[i].preyType == trials[i - 1].preyType &&
            trials[i].preyType == trials[i - 2].preyType;
        expect(
          sameThree,
          isFalse,
          reason: 'seed $seed: prey 3-run ending at $i',
        );
      }
    }
  });

  test('identical seed and constraints reproduce the identical schedule', () {
    final a = scheduler.generate(
      seed: 987654,
      constraints: const SafetyConstraints(),
    );
    final b = scheduler.generate(
      seed: 987654,
      constraints: const SafetyConstraints(),
    );
    expect(a.trials, b.trials);
    final c = scheduler.generate(
      seed: 987655,
      constraints: const SafetyConstraints(),
    );
    expect(c.trials, isNot(a.trials));
  });

  test('sound-sensitive cats get an all-silent schedule, balance waived', () {
    final constraints = SafetyConstraints.fromAnswers(
      soundSensitivity: SoundSensitivity.easilyStartled,
      visionConsideration: VisionConsideration.noneKnown,
      mobilityConsideration: MobilityConsideration.none,
    );
    for (var seed = 0; seed < 200; seed++) {
      final schedule = scheduler.generate(seed: seed, constraints: constraints);
      expect(
        schedule.trials.every((t) => t.soundMode == SoundMode.silent),
        isTrue,
      );
      expect(schedule.waivedBalances, contains(FactorType.soundMode));
    }
  });

  test('reduced-vision cats get all-large targets', () {
    final constraints = SafetyConstraints.fromAnswers(
      soundSensitivity: SoundSensitivity.neutral,
      visionConsideration: VisionConsideration.reducedVision,
      mobilityConsideration: MobilityConsideration.none,
    );
    for (var seed = 0; seed < 200; seed++) {
      final schedule = scheduler.generate(seed: seed, constraints: constraints);
      expect(
        schedule.trials.every((t) => t.sizeLevel == SizeLevel.large),
        isTrue,
      );
      expect(schedule.waivedBalances, contains(FactorType.sizeLevel));
    }
  });

  test('mobility-limited cats: all slow, all centre', () {
    final constraints = SafetyConstraints.fromAnswers(
      soundSensitivity: SoundSensitivity.neutral,
      visionConsideration: VisionConsideration.noneKnown,
      mobilityConsideration: MobilityConsideration.limitedMovement,
    );
    for (var seed = 0; seed < 200; seed++) {
      final schedule = scheduler.generate(seed: seed, constraints: constraints);
      for (final trial in schedule.trials) {
        expect(trial.speedLevel, SpeedLevel.slow);
        expect(trial.spawnZone, SpawnZone.centre);
        expect(constraints.allows(trial), isTrue);
      }
    }
  });

  test('every generated trial satisfies its constraints (all presets)', () {
    final presets = [
      const SafetyConstraints(),
      SafetyConstraints.fromAnswers(
        soundSensitivity: SoundSensitivity.easilyStartled,
        visionConsideration: VisionConsideration.reducedVision,
        mobilityConsideration: MobilityConsideration.seniorFriendly,
      ),
      SafetyConstraints.fromAnswers(
        soundSensitivity: SoundSensitivity.enjoysSound,
        visionConsideration: VisionConsideration.noneKnown,
        mobilityConsideration: MobilityConsideration.limitedMovement,
      ),
    ];
    for (final constraints in presets) {
      for (var seed = 0; seed < 300; seed++) {
        final schedule = scheduler.generate(
          seed: seed,
          constraints: constraints,
        );
        for (final trial in schedule.trials) {
          expect(constraints.allows(trial), isTrue);
        }
      }
    }
  });
}
