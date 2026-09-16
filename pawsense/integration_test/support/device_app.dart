import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pawsense/app/app.dart';
import 'package:pawsense/core/audio/audio_service.dart';
import 'package:pawsense/core/database/app_database.dart';
import 'package:pawsense/core/files/file_service.dart';
import 'package:pawsense/features/voice_cues/domain/cue_recorder.dart';
import 'package:pawsense/features/voice_cues/presentation/voice_cues_screen.dart';
import 'package:pawsense/shared/providers/core_providers.dart';

import 'cue_fixture.dart';

/// Real on-device SQLite and private files, isolated from user data. The app
/// completes database bootstrap before mounting, and every test unmounts its
/// streams before awaiting connection close (including on assertion failures).
class DeviceApp {
  DeviceApp._(
    this.directory,
    this.databaseFile,
    this.db,
    this.audio,
    this.scope,
  );

  static Future<DeviceApp> create() async {
    final parent = await getTemporaryDirectory();
    await parent.create(recursive: true);
    final directory = await parent.createTemp('pawsense-integration-');
    final databaseFile = File('${directory.path}/pawsense.sqlite');
    final db = AppDatabase(NativeDatabase.createInBackground(databaseFile));
    final audio = ObservedDeviceAudio();
    final scope = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        fileServiceProvider.overrideWithValue(FileService(directory)),
        audioServiceProvider.overrideWithValue(audio),
        cueRecorderProvider.overrideWith((ref) {
          final recorder = FixtureCueRecorder();
          ref.onDispose(recorder.dispose);
          return recorder;
        }),
      ],
    );
    final app = DeviceApp._(directory, databaseFile, db, audio, scope);
    try {
      await scope.read(settingsRepositoryProvider).get();
      return app;
    } catch (_) {
      scope.dispose();
      await db.close();
      await directory.delete(recursive: true);
      rethrow;
    }
  }

  final Directory directory;
  final File databaseFile;
  final AppDatabase db;
  final ObservedDeviceAudio audio;
  final ProviderContainer scope;
  bool _closed = false;

  Future<void> mount(WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(container: scope, child: const PawSenseApp()),
    );
  }

  Future<void> close(WidgetTester tester) async {
    if (_closed) return;
    _closed = true;
    // Navigation and audio must stop while providers and the database exist.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
    scope.dispose();
    await audio.dispose();
    await db.close().timeout(const Duration(seconds: 10));
  }

  Future<void> dispose(WidgetTester tester) async {
    await close(tester);
    if (directory.existsSync()) await directory.delete(recursive: true);
  }
}

/// Records calls while using the production native audio engine, pools,
/// completion events, file resolution, and lifecycle handling unchanged.
class ObservedDeviceAudio extends AudioService {
  final startedPaths = <String>[];
  final completedPaths = <String>[];

  @override
  Future<void> playCueFile(String absolutePath) async {
    startedPaths.add(absolutePath);
    await super.playCueFile(absolutePath);
    completedPaths.add(absolutePath);
  }
}

/// Only microphone capture is replaced. The owner still drives Record/Stop,
/// and production code saves, previews, replaces, deletes, and trains from
/// a genuine local AAC file. OS permission dialogs and live recording are
/// deliberately left to physical-device QA, not claimed by this fixture.
class FixtureCueRecorder implements CueRecorder {
  String? _path;

  @override
  Future<bool> hasPermission() async => true;

  @override
  Future<void> start(String path) async {
    await writeCueFixture(path);
    _path = path;
  }

  @override
  Future<RecordingResult?> stop() async {
    final path = _path;
    _path = null;
    return path == null
        ? null
        : RecordingResult(path: path, durationMs: cueFixtureDurationMs);
  }

  @override
  Future<void> cancel() async {
    final path = _path;
    _path = null;
    if (path != null && File(path).existsSync()) File(path).deleteSync();
  }

  @override
  Future<void> dispose() => cancel();
}

Future<void> waitUntil(
  WidgetTester tester,
  bool Function() ready, {
  required String description,
  Duration timeout = const Duration(seconds: 20),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (!ready()) {
    if (DateTime.now().isAfter(deadline)) {
      fail('Timed out waiting for $description');
    }
    // Never pumpAndSettle on a live Flame game: its animation never settles.
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Future<void> waitFor(WidgetTester tester, Finder finder) => waitUntil(
  tester,
  () => finder.evaluate().isNotEmpty,
  description: '$finder',
);

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await waitFor(tester, finder);
  await tester.ensureVisible(finder);
  await tester.pump(const Duration(milliseconds: 300));
  await tester.tap(finder);
  await tester.pump(const Duration(milliseconds: 400));
}
