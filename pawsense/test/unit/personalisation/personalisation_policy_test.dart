import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/features/personalisation/domain/personalisation_policy.dart';
import 'package:pawsense/shared/models/enums.dart';

void main() {
  test(
    'favourite prey seeds map to screen prey (feather->moth, ball->mouse)',
    () {
      List<PreferenceSeed> seedsFor(FavouritePrey prey) => seedsFromAnswers(
        favouritePrey: prey,
        energyLevel: EnergyLevel.medium,
        soundSensitivity: SoundSensitivity.neutral,
      );

      expect(seedsFor(FavouritePrey.mouse).single.factorValue, 'mouse');
      expect(seedsFor(FavouritePrey.ball).single.factorValue, 'mouse');
      expect(seedsFor(FavouritePrey.mothBug).single.factorValue, 'moth');
      expect(seedsFor(FavouritePrey.feather).single.factorValue, 'moth');
      expect(seedsFor(FavouritePrey.fish).single.factorValue, 'fish');
      expect(seedsFor(FavouritePrey.other), isEmpty);
      expect(seedsFor(FavouritePrey.unknown), isEmpty);
    },
  );

  test('priors are weak: 4 pseudo-impressions, 3 pseudo-successes', () {
    final seeds = seedsFromAnswers(
      favouritePrey: FavouritePrey.mouse,
      energyLevel: EnergyLevel.high,
      soundSensitivity: SoundSensitivity.enjoysSound,
    );
    expect(seeds, hasLength(3));
    for (final seed in seeds) {
      expect(seed.impressions, 4);
      expect(seed.successes, 3);
    }
    expect(
      seeds.map((s) => s.factorType),
      containsAll([
        FactorType.targetType,
        FactorType.speedLevel,
        FactorType.soundMode,
      ]),
    );
  });

  test('energy maps to speed prior direction', () {
    final high = seedsFromAnswers(
      favouritePrey: null,
      energyLevel: EnergyLevel.high,
      soundSensitivity: SoundSensitivity.neutral,
    ).single;
    expect(high.factorValue, SpeedLevel.medium.name);
    final low = seedsFromAnswers(
      favouritePrey: null,
      energyLevel: EnergyLevel.low,
      soundSensitivity: SoundSensitivity.neutral,
    ).single;
    expect(low.factorValue, SpeedLevel.slow.name);
  });

  test('updateFactorStats decays old counts and increments new evidence', () {
    final updated = updateFactorStats(
      impressions: 100,
      successes: 50,
      timeouts: 10,
      totalMisses: 30,
      frustrationCount: 5,
      reactionTimeEwmaMs: 2000,
      cumulativeReward: 40,
      caught: true,
      reactionTimeMs: 1000,
      timedOut: false,
      trialMissCount: 2,
      frustrationSeverity: 1,
      trialReward: 0.9,
    );
    expect(updated.impressions, closeTo(100 * 0.995 + 1, 1e-9));
    expect(updated.successes, closeTo(50 * 0.995 + 1, 1e-9));
    expect(updated.timeouts, closeTo(10 * 0.995, 1e-9));
    expect(updated.totalMisses, closeTo(30 * 0.995 + 2, 1e-9));
    expect(updated.frustrationCount, closeTo(5 * 0.995 + 1, 1e-9));
    expect(updated.reactionTimeEwmaMs, closeTo(0.3 * 1000 + 0.7 * 2000, 1e-9));
    expect(updated.cumulativeReward, closeTo(40.9, 1e-9));
  });

  test('reaction EWMA only updates on successful trials with a time', () {
    final missed = updateFactorStats(
      impressions: 10,
      successes: 5,
      timeouts: 1,
      totalMisses: 3,
      frustrationCount: 0,
      reactionTimeEwmaMs: 1500,
      cumulativeReward: 2,
      caught: false,
      reactionTimeMs: null,
      timedOut: true,
      trialMissCount: 0,
      frustrationSeverity: 0,
      trialReward: -0.25,
    );
    expect(missed.reactionTimeEwmaMs, 1500);
    expect(missed.timeouts, closeTo(1 * 0.995 + 1, 1e-9));
  });

  test('first reaction sample becomes the EWMA baseline', () {
    final first = updateFactorStats(
      impressions: 0,
      successes: 0,
      timeouts: 0,
      totalMisses: 0,
      frustrationCount: 0,
      reactionTimeEwmaMs: null,
      cumulativeReward: 0,
      caught: true,
      reactionTimeMs: 2500,
      timedOut: false,
      trialMissCount: 0,
      frustrationSeverity: 0,
      trialReward: 1,
    );
    expect(first.reactionTimeEwmaMs, 2500);
  });
}
