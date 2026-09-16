// On-device flows with real SQLite, files, native audio, router, Flame game,
// and pointer input. Only microphone capture uses a local AAC fixture; live
// recording/OS permissions and cat behaviour need the physical QA pass.
// Run: flutter test integration_test/app_flows_test.dart -d <device-id>

import 'package:audioplayers/audioplayers.dart';
import 'package:drift/native.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pawsense/app/router.dart';
import 'package:pawsense/core/database/app_database.dart';
import 'package:pawsense/core/export/export_service.dart';
import 'package:pawsense/features/cat_profiles/domain/cat_profile_draft.dart';
import 'package:pawsense/features/developer_tools/data/demo_data_service.dart';
import 'package:pawsense/features/play/game/paw_sense_game.dart';
import 'package:pawsense/features/play/presentation/play_screen.dart';
import 'package:pawsense/features/play/presentation/session_launch.dart';
import 'package:pawsense/shared/models/enums.dart';
import 'package:pawsense/shared/providers/core_providers.dart';

import 'support/device_app.dart';

void deviceTest(
  String description,
  Future<void> Function(WidgetTester tester, DeviceApp app) body,
) {
  testWidgets(description, (tester) async {
    final app = await DeviceApp.create();
    try {
      await body(tester, app);
      expect(tester.takeException(), isNull);
    } finally {
      await app.dispose(tester);
    }
  });
}

DemoDataService demoData(DeviceApp app) => DemoDataService(
  app.scope.read(catProfileRepositoryProvider),
  app.scope.read(sessionRepositoryProvider),
);

Future<void> mountExisting(WidgetTester tester, DeviceApp app) async {
  await app.scope.read(settingsRepositoryProvider).completeOnboarding(1);
  await app.mount(tester);
  await waitFor(tester, find.text("Who's playing?"));
  await tester.pump(const Duration(milliseconds: 400));
}

Future<void> recordFixture(
  WidgetTester tester,
  DeviceApp app,
  String label,
) async {
  final tile = find.ancestor(of: find.text(label), matching: find.byType(Card));
  await tapVisible(
    tester,
    find.descendant(of: tile, matching: find.text('Record')),
  );
  final stop = find.descendant(of: tile, matching: find.text('Stop'));
  await tapVisible(tester, stop);
  await waitFor(
    tester,
    find.descendant(of: tile, matching: find.text('Re-record')),
  );
}

/// A direct native decode/play assertion prevents AudioService's intentional
/// fail-open guard from masking a broken fixture or unsupported audio codec.
Future<void> verifyNativePlayback(String path) async {
  final player = AudioPlayer();
  try {
    await player.setVolume(0);
    await player.setSourceDeviceFile(path);
    final duration = await player.getDuration();
    expect(duration?.inMilliseconds, greaterThan(0));
    final completed = player.onPlayerComplete.first.timeout(
      const Duration(seconds: 5),
    );
    await player.resume();
    await completed;
  } finally {
    await player.dispose();
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  deviceTest('first launch -> create cat -> calibration setup', (
    tester,
    app,
  ) async {
    await app.mount(tester);
    await tapVisible(tester, find.text('Continue'));
    await tapVisible(tester, find.text('Continue'));
    await tapVisible(tester, find.text('Create your first cat'));
    await waitFor(tester, find.byType(TextField));
    await tester.enterText(find.byType(TextField).first, 'Tiger');
    for (var step = 1; step < 7; step++) {
      await tapVisible(tester, find.text('Next'));
    }
    await tapVisible(tester, find.text('Create profile'));
    await tapVisible(tester, find.text('Calibrate'));
    await waitFor(tester, find.text('Start session'));
    expect(find.textContaining('12 small trials'), findsOneWidget);
  });

  deviceTest('stored sessions -> insights -> history', (tester, app) async {
    final catId = await demoData(app).seedDemoCat(seed: 7, sessionCount: 4);
    await mountExisting(tester, app);
    app.scope.read(routerProvider).go('/cats/$catId/insights');
    await waitFor(tester, find.text('Sessions'));
    expect(find.text('What works for this cat'), findsOneWidget);
    app.scope.read(routerProvider).go('/cats/$catId/history');
    await waitFor(tester, find.text('Session history'));
    expect(find.byType(Card), findsWidgets);
  });

  deviceTest('export writes shareable files in private storage', (
    tester,
    app,
  ) async {
    await demoData(app).seedDemoCat(seed: 9, sessionCount: 2);
    final export = ExportService(
      app.db,
      app.scope.read(fileServiceProvider),
      app.scope.read(clockProvider),
    );
    final jsonFile = await export.writeJsonFile();
    expect(jsonFile.existsSync(), isTrue);
    expect(jsonFile.lengthSync(), greaterThan(1000));
    final csvs = await export.writeCsvFiles();
    expect(csvs.length, greaterThanOrEqualTo(4));
    await app.scope.read(fileServiceProvider).clearExportDir();
    expect(jsonFile.existsSync(), isFalse);
  });

  deviceTest('delete cat removes dependent records and profile files', (
    tester,
    app,
  ) async {
    final catId = await demoData(app).seedDemoCat(seed: 11, sessionCount: 2);
    expect(await app.db.select(app.db.sessions).get(), isNotEmpty);
    await app.scope.read(catProfileRepositoryProvider).deletePermanently(catId);
    expect(await app.db.select(app.db.catProfiles).get(), isEmpty);
    expect(await app.db.select(app.db.sessions).get(), isEmpty);
    expect(await app.db.select(app.db.targetTrials).get(), isEmpty);
    expect(await app.db.select(app.db.touchEvents).get(), isEmpty);
    expect(await app.db.select(app.db.preferenceStats).get(), isEmpty);
    expect(
      app.scope.read(fileServiceProvider).profileDir(catId).existsSync(),
      isFalse,
    );
  });

  deviceTest('bootstrap recovers an interrupted stored session', (
    tester,
    app,
  ) async {
    await demoData(app).seedDemoCat(seed: 13, sessionCount: 1);
    await app.db.customStatement(
      "UPDATE sessions SET status = 'inProgress', ended_at_utc = NULL",
    );
    await mountExisting(tester, app);
    // Bootstrap owns recovery; calling the method directly here would not
    // exercise launch integration and could conceal a missing startup hook.
    final deadline = DateTime.now().add(const Duration(seconds: 10));
    var session = (await app.db.select(app.db.sessions).get()).single;
    while (session.status == SessionStatus.inProgress &&
        DateTime.now().isBefore(deadline)) {
      await tester.pump(const Duration(milliseconds: 50));
      session = (await app.db.select(app.db.sessions).get()).single;
    }
    expect(session.status, SessionStatus.interrupted);
    expect(session.endedAtUtc, isNotNull);
    expect(
      await app.scope
          .read(sessionRepositoryProvider)
          .recoverInterruptedSessions(),
      0,
    );
  });

  deviceTest(
    'recorded cues -> live hunt catch -> owner gate -> durable learning',
    (tester, app) async {
      final cat = await app.scope
          .read(catProfileRepositoryProvider)
          .create(
            const CatProfileDraft(
              name: 'Miso',
              soundSensitivity: SoundSensitivity.enjoysSound,
            ),
          );
      await mountExisting(tester, app);
      final router = app.scope.read(routerProvider);
      router.go('/cats/${cat.id}/voice');
      await waitFor(tester, find.text("Miso's voice cues"));
      for (final label in ['Touch', 'Good', 'All done']) {
        await recordFixture(tester, app, label);
      }

      final cues = await app.db.select(app.db.voiceCues).get();
      expect(cues.map((cue) => cue.cueType).toSet(), {
        CueType.touch,
        CueType.good,
        CueType.allDone,
      });
      final touchCue = cues.singleWhere((cue) => cue.cueType == CueType.touch);
      final touchPath = app.scope
          .read(fileServiceProvider)
          .resolve(touchCue.filePath)
          .path;
      await verifyNativePlayback(touchPath);

      // Preview through the actual screen, not a direct audio-service call.
      final touchTile = find.ancestor(
        of: find.text('Touch'),
        matching: find.byType(Card),
      );
      await tapVisible(
        tester,
        find.descendant(
          of: touchTile,
          matching: find.byTooltip('Play recording'),
        ),
      );
      await waitUntil(
        tester,
        () => app.audio.completedPaths.contains(touchPath),
        description: 'native cue preview completion',
      );
      app.audio.startedPaths.clear();
      app.audio.completedPaths.clear();

      router.go(
        '/play',
        extra: SessionLaunch(
          mode: SessionMode.touchTraining,
          catId: cat.id,
          durationSeconds: 60,
          soundEnabled: true,
          manualConfig: const ManualFactors(
            preyType: PreyType.mouse,
            movementStyle: MovementStyle.smooth,
            speedLevel: SpeedLevel.slow,
            sizeLevel: SizeLevel.large,
          ),
        ),
      );
      final gameFinder = find.byType(GameWidget<PawSenseGame>);
      await waitFor(tester, gameFinder);
      final game = tester.widget<GameWidget<PawSenseGame>>(gameFinder).game!;
      await waitUntil(
        tester,
        () =>
            game.controller.currentTargetSnapshot?.active == true &&
            game.currentPrey?.isTouchable == true,
        description: 'Touch cue finishing and hunt target becoming touchable',
      );
      expect(app.audio.completedPaths, contains(touchPath));
      expect(find.byType(FilledButton), findsNothing);
      expect(find.byType(TextButton), findsNothing);

      // Tap the real live target through PlayScreen's Listener. No direct
      // controller.handlePointerDown shortcut: coordinate plumbing is tested.
      final target = game.controller.currentTargetSnapshot!;
      final board = tester.getRect(gameFinder);
      await tester.tapAt(
        board.topLeft + Offset(target.centreX, target.centreY),
      );
      await waitUntil(
        tester,
        () => game.controller.trials.any((trial) => trial.success),
        description: 'pointer catch finalising the target trial',
      );
      final captured = game.controller.trials.singleWhere(
        (trial) => trial.success,
      );
      expect(captured.cueType, CueType.touch);
      expect(captured.praiseCueType, CueType.good);
      expect(captured.reactionTimeMs, isNotNull);

      await tester.binding.handlePopRoute();
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byType(PlayScreen), findsOneWidget);
      final left = await tester.startGesture(
        board.topLeft + const Offset(12, 12),
        pointer: 21,
      );
      final right = await tester.startGesture(
        board.topRight + const Offset(-12, 12),
        pointer: 22,
      );
      try {
        await waitFor(tester, find.text('Owner check'));
      } finally {
        await left.up();
        await right.up();
      }
      final pausedAt = game.controller.sessionMs;
      await tester.pump(const Duration(milliseconds: 250));
      expect(game.controller.sessionMs, pausedAt);
      final hold = await tester.startGesture(
        tester.getCenter(find.text('Hold to end')),
      );
      try {
        await waitFor(tester, find.text('Session results'));
      } finally {
        await hold.up();
      }

      final session = (await app.db.select(app.db.sessions).get()).single;
      expect(session.status, SessionStatus.ownerStopped);
      expect(session.catches, 1);
      final trials = await app.db.select(app.db.targetTrials).get();
      expect(trials.where((trial) => trial.success), hasLength(1));
      final touches = await app.db.select(app.db.touchEvents).get();
      expect(
        touches.where(
          (touch) => touch.classification == TouchClassification.hit,
        ),
        hasLength(1),
      );
      final progress = (await app.db.select(app.db.cueProgress).get()).single;
      expect(progress.cueType, CueType.touch);
      expect(progress.exposures, 1);
      expect(progress.successfulResponses, 1);
      expect(progress.reactionTimeEwmaMs, isNotNull);
      expect(
        app.audio.startedPaths.any((path) => path.endsWith('/good.m4a')),
        isTrue,
      );
      expect(
        app.audio.startedPaths.any((path) => path.endsWith('/allDone.m4a')),
        isTrue,
      );

      // Close the app's SQLite connection and reopen the same file to prove
      // these are durable records, not values only visible in a live provider.
      await app.close(tester);
      final reopened = AppDatabase(
        NativeDatabase.createInBackground(app.databaseFile),
      );
      try {
        final persisted =
            (await reopened.select(reopened.cueProgress).get()).single;
        expect(persisted.successfulResponses, 1);
        expect(
          (await reopened.select(reopened.sessions).get()).single.status,
          SessionStatus.ownerStopped,
        );
        expect(await reopened.select(reopened.voiceCues).get(), hasLength(3));
      } finally {
        await reopened.close();
      }
    },
  );
}
