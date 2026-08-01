import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/app/app.dart';
import 'package:pawsense/core/database/app_database.dart';
import 'package:pawsense/core/files/file_service.dart';
import 'package:pawsense/core/time/clock.dart';
import 'package:pawsense/features/cat_profiles/data/cat_profile_repository.dart';
import 'package:pawsense/features/cat_profiles/domain/cat_profile_draft.dart';
import 'package:pawsense/shared/providers/core_providers.dart';
import 'package:uuid/uuid.dart';

/// Real app + real router + in-memory database. Owns temp files and closes
/// the database on [dispose].
///
/// Database access from inside `testWidgets` must go through [db] wrapped in
/// `tester.runAsync` (see [dbCall]) because drift futures can depend on real
/// timers that never fire inside the fake-async test zone.
class TestApp {
  TestApp._(this.db, this.files, this.clock, this._tempDir);

  factory TestApp.create() {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final tempDir = Directory.systemTemp.createTempSync('pawsense_widget');
    return TestApp._(
      db,
      FileService(tempDir),
      FakeClock(DateTime.utc(2026, 8, 1, 10)),
      tempDir,
    );
  }

  final AppDatabase db;
  final FileService files;
  final FakeClock clock;
  final Directory _tempDir;

  CatProfileRepository get profileRepo =>
      CatProfileRepository(db, clock, const Uuid(), files);

  Widget build() {
    return ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(db),
        fileServiceProvider.overrideWithValue(files),
        clockProvider.overrideWithValue(clock),
      ],
      child: const PawSenseApp(),
    );
  }

  Future<void> dispose() async {
    // When a test fails before tearDownApp unmounted the tree, live stream
    // subscriptions can deadlock close(); the timeout keeps the *real*
    // failure visible instead of a 10-minute hang.
    await db.close().timeout(const Duration(seconds: 2), onTimeout: () {});
    if (_tempDir.existsSync()) _tempDir.deleteSync(recursive: true);
  }

  /// Marks first-launch onboarding as done so tests can start at the picker.
  Future<void> completeOnboarding() async {
    final query = db.update(db.appSettings)..where((s) => s.id.equals(1));
    await query.write(
      const AppSettingsCompanion(onboardingComplete: Value(true)),
    );
  }

  Future<void> seedCat(String name, {CatProfileDraft? draft}) async {
    await profileRepo.create(
      (draft ?? const CatProfileDraft()).copyWith(name: name),
    );
  }
}

/// Runs a database (or other real-async) operation from inside a widget
/// test's fake-async zone.
Future<T> dbCall<T>(WidgetTester tester, Future<T> Function() action) async {
  final result = await tester.runAsync(action);
  return result as T;
}

/// Unmounts the app and fires drift's zero-duration `markAsClosed` timer so
/// no timer is pending when flutter_test verifies invariants. Call as the
/// last line of every widget test that pumped [TestApp.build].
Future<void> tearDownApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 20));
}

/// Pumps frames until [finder] matches, then settles remaining transition
/// animations so the screen is interactable. Use instead of pumpAndSettle
/// while indeterminate progress indicators may be on screen.
Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final end = DateTime.now().add(timeout);
  while (finder.evaluate().isEmpty) {
    if (DateTime.now().isAfter(end)) {
      fail('Timed out waiting for $finder');
    }
    await tester.pump(const Duration(milliseconds: 50));
  }
  await tester.pumpAndSettle();
}
