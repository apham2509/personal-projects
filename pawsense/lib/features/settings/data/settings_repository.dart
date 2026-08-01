import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../shared/models/enums.dart';

/// Typed access to the single-row settings table.
///
/// The owner PIN is stored as SHA-256(salt + pin) with a random 16-byte
/// salt. This is a paw/child gate, not a security boundary (DECISIONS.md
/// D-010).
class SettingsRepository {
  SettingsRepository(this._db);

  final AppDatabase _db;

  Stream<AppSetting> watch() {
    final query = _db.select(_db.appSettings)..where((s) => s.id.equals(1));
    return query.watchSingle();
  }

  Future<AppSetting> get() {
    final query = _db.select(_db.appSettings)..where((s) => s.id.equals(1));
    return query.getSingle();
  }

  Future<void> _write(AppSettingsCompanion companion) async {
    final query = _db.update(_db.appSettings)..where((s) => s.id.equals(1));
    await query.write(companion);
  }

  Future<void> setDefaultSessionDuration(int seconds) => _write(
    AppSettingsCompanion(defaultSessionDurationSeconds: Value(seconds)),
  );

  Future<void> setSoundEnabled(bool enabled) =>
      _write(AppSettingsCompanion(soundEnabled: Value(enabled)));

  Future<void> setRewardSchedule(RewardSchedule schedule) =>
      _write(AppSettingsCompanion(rewardSchedule: Value(schedule)));

  Future<void> setMaxRewardReminders(int count) =>
      _write(AppSettingsCompanion(maxRewardReminders: Value(count)));

  Future<void> setReduceMotion(bool value) =>
      _write(AppSettingsCompanion(reduceMotion: Value(value)));

  Future<void> setHighContrastMode(bool value) =>
      _write(AppSettingsCompanion(highContrastMode: Value(value)));

  Future<void> setPreferredLocale(String? locale) =>
      _write(AppSettingsCompanion(preferredLocale: Value(locale)));

  Future<void> completeOnboarding(int privacyVersion) => _write(
    AppSettingsCompanion(
      onboardingComplete: const Value(true),
      privacyVersionAccepted: Value(privacyVersion),
    ),
  );

  Future<void> setOwnerPin(String pin) async {
    final saltBytes = List<int>.generate(
      16,
      (_) => Random.secure().nextInt(256),
    );
    final salt = base64Encode(saltBytes);
    await _write(
      AppSettingsCompanion(
        ownerPinSalt: Value(salt),
        ownerPinHash: Value(_hash(salt, pin)),
      ),
    );
  }

  Future<void> clearOwnerPin() => _write(
    const AppSettingsCompanion(
      ownerPinSalt: Value(null),
      ownerPinHash: Value(null),
    ),
  );

  Future<bool> verifyOwnerPin(String pin) async {
    final settings = await get();
    final salt = settings.ownerPinSalt;
    final hash = settings.ownerPinHash;
    if (salt == null || hash == null) return true; // no PIN configured
    return _hash(salt, pin) == hash;
  }

  String _hash(String salt, String pin) =>
      sha256.convert(utf8.encode('$salt$pin')).toString();
}
