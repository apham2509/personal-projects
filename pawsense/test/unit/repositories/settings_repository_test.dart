import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/core/database/app_database.dart';
import 'package:pawsense/features/settings/data/settings_repository.dart';
import 'package:pawsense/shared/models/enums.dart';

void main() {
  late AppDatabase db;
  late SettingsRepository repo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = SettingsRepository(db);
  });

  tearDown(() => db.close());

  test('settings row is seeded with documented defaults', () async {
    final settings = await repo.get();
    expect(settings.defaultSessionDurationSeconds, 180);
    expect(settings.soundEnabled, isTrue);
    expect(settings.rewardSchedule, RewardSchedule.none);
    expect(settings.maxRewardReminders, 3);
    expect(settings.onboardingComplete, isFalse);
    expect(settings.ownerPinHash, isNull);
    expect(settings.reduceMotion, isFalse);
    expect(settings.highContrastMode, isFalse);
  });

  test('updates persist', () async {
    await repo.setDefaultSessionDuration(300);
    await repo.setRewardSchedule(RewardSchedule.variableTwoToFive);
    await repo.setSoundEnabled(false);
    await repo.completeOnboarding(1);

    final settings = await repo.get();
    expect(settings.defaultSessionDurationSeconds, 300);
    expect(settings.rewardSchedule, RewardSchedule.variableTwoToFive);
    expect(settings.soundEnabled, isFalse);
    expect(settings.onboardingComplete, isTrue);
    expect(settings.privacyVersionAccepted, 1);
  });

  test('PIN set, verify, clear', () async {
    // No PIN configured: gate passes.
    expect(await repo.verifyOwnerPin('0000'), isTrue);

    await repo.setOwnerPin('4321');
    final settings = await repo.get();
    expect(settings.ownerPinHash, isNotNull);
    expect(
      settings.ownerPinHash,
      isNot(contains('4321')),
      reason: 'PIN must not be stored in recoverable form',
    );

    expect(await repo.verifyOwnerPin('4321'), isTrue);
    expect(await repo.verifyOwnerPin('1234'), isFalse);

    await repo.clearOwnerPin();
    expect(await repo.verifyOwnerPin('anything'), isTrue);
  });

  test('two identical PINs hash differently thanks to salt', () async {
    await repo.setOwnerPin('4321');
    final first = (await repo.get()).ownerPinHash;
    await repo.setOwnerPin('4321');
    final second = (await repo.get()).ownerPinHash;
    expect(first, isNot(second));
  });
}
