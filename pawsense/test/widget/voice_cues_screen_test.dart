import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/app/app.dart';
import 'package:pawsense/features/voice_cues/domain/cue_recorder.dart';
import 'package:pawsense/features/voice_cues/presentation/voice_cues_screen.dart';
import 'package:pawsense/shared/providers/core_providers.dart';

import 'harness.dart';

class FakeCueRecorder implements CueRecorder {
  FakeCueRecorder({required this.permitted});

  bool permitted;
  String? activePath;
  Completer<void>? pendingStart;
  int startCount = 0;
  int cancelCount = 0;

  @override
  Future<bool> hasPermission() async => permitted;

  @override
  Future<void> start(String path) async {
    startCount++;
    await pendingStart?.future;
    activePath = path;
    File(path).writeAsBytesSync([1, 2, 3]);
  }

  @override
  Future<RecordingResult?> stop() async {
    final path = activePath;
    if (path == null) return null;
    activePath = null;
    File(path).writeAsBytesSync([9, 9, 9]);
    return RecordingResult(path: path, durationMs: 1234);
  }

  @override
  Future<void> cancel() async {
    cancelCount++;
    activePath = null;
  }

  @override
  Future<void> dispose() async {}
}

void main() {
  Future<TestApp> openVoiceScreen(
    WidgetTester tester,
    FakeCueRecorder recorder,
  ) async {
    final app = TestApp.create();
    addTearDown(app.dispose);
    await dbCall(tester, () async {
      await app.completeOnboarding();
      await app.seedCat('Tiger');
    });
    final catId = (await dbCall(
      tester,
      () => app.db.select(app.db.catProfiles).get(),
    )).single.id;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(app.db),
          fileServiceProvider.overrideWithValue(app.files),
          clockProvider.overrideWithValue(app.clock),
          cueRecorderProvider.overrideWithValue(recorder),
        ],
        child: const PawSenseApp(),
      ),
    );
    await pumpUntilFound(tester, find.text("Who's playing?"));
    await goTo(tester, '/cats/$catId/voice');
    await pumpUntilFound(tester, find.text("Tiger's voice cues"));
    return app;
  }

  testWidgets('leaving a recording cancels the mic and deletes its temp file', (
    tester,
  ) async {
    final recorder = FakeCueRecorder(permitted: true);
    final app = await openVoiceScreen(tester, recorder);
    await tester.tap(find.text('Record').first);
    await tester.pump(const Duration(milliseconds: 100));
    final path = recorder.activePath!;
    expect(File(path).existsSync(), isTrue);
    await goTo(tester, '/profiles');
    expect(recorder.activePath, isNull);
    expect(recorder.cancelCount, greaterThan(0));
    expect(File(path).existsSync(), isFalse);
    expect(
      await dbCall(tester, () => app.db.select(app.db.voiceCues).get()),
      isEmpty,
    );
    await tearDownApp(tester);
  });

  testWidgets('backgrounding cancels recording without saving a partial cue', (
    tester,
  ) async {
    final recorder = FakeCueRecorder(permitted: true);
    final app = await openVoiceScreen(tester, recorder);
    await tester.tap(find.text('Record').first);
    await tester.pump(const Duration(milliseconds: 100));
    final path = recorder.activePath!;
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();
    expect(recorder.activePath, isNull);
    expect(File(path).existsSync(), isFalse);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(find.text('Stop'), findsNothing);
    expect(
      await dbCall(tester, () => app.db.select(app.db.voiceCues).get()),
      isEmpty,
    );
    await tearDownApp(tester);
  });

  testWidgets('a delayed mic start is cancelled if its screen was removed', (
    tester,
  ) async {
    final recorder = FakeCueRecorder(permitted: true)
      ..pendingStart = Completer<void>();
    final app = await openVoiceScreen(tester, recorder);
    await tester.tap(find.text('Record').first);
    await tester.pump();
    expect(recorder.startCount, 1);
    await goTo(tester, '/profiles');
    recorder.pendingStart!.complete();
    await tester.pump();
    expect(recorder.activePath, isNull);
    expect(app.files.documentsDir.listSync().whereType<File>(), isEmpty);
    expect(tester.takeException(), isNull);
    await tearDownApp(tester);
  });

  testWidgets('recordings stop and save automatically after five seconds', (
    tester,
  ) async {
    final recorder = FakeCueRecorder(permitted: true);
    await openVoiceScreen(tester, recorder);
    await tester.tap(find.text('Record').first);
    await tester.pump();
    await tester.pump(const Duration(seconds: 5));
    await pumpUntilFound(tester, find.text('1.2 s recorded'));
    expect(recorder.activePath, isNull);
    expect(find.text('Stop'), findsNothing);
    await tearDownApp(tester);
  });

  testWidgets('record -> stop saves the cue; preview and delete appear', (
    tester,
  ) async {
    final app = TestApp.create();
    addTearDown(app.dispose);
    final recorder = FakeCueRecorder(permitted: true);
    await dbCall(tester, () async {
      await app.completeOnboarding();
      await app.seedCat('Tiger');
    });
    final catId = (await dbCall(
      tester,
      () => app.db.select(app.db.catProfiles).get(),
    )).single.id;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(app.db),
          fileServiceProvider.overrideWithValue(app.files),
          clockProvider.overrideWithValue(app.clock),
          cueRecorderProvider.overrideWithValue(recorder),
        ],
        child: const PawSenseApp(),
      ),
    );
    await pumpUntilFound(tester, find.text("Who's playing?"));
    await goTo(tester, '/cats/$catId/voice');
    await pumpUntilFound(tester, find.text("Tiger's voice cues"));

    expect(find.text('Touch'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('All done'), 150);
    expect(find.text('All done'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Touch'), -150);

    // Record the Touch cue: the tile's Record button is the second one
    // (index 1: catName is first).
    await tester.scrollUntilVisible(find.text('Touch'), 100);
    await tester.tap(find.text('Record').at(1));
    await tester.pump(const Duration(milliseconds: 100));
    expect(
      find.text('Recording... speak your cue, then stop.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Stop'));
    await pumpUntilFound(tester, find.text('1.2 s recorded'));
    expect(find.text('Re-record'), findsOneWidget);
    expect(find.byTooltip('Play recording'), findsOneWidget);

    final cues = await dbCall(
      tester,
      () => app.db.select(app.db.voiceCues).get(),
    );
    expect(cues.single.cueType.name, 'touch');
    expect(app.files.resolve(cues.single.filePath).existsSync(), isTrue);

    // Delete removes row and shows Record again.
    await tester.tap(find.byTooltip('Delete'));
    await pumpUntilFound(tester, find.text('Record').at(1));
    expect(
      await dbCall(tester, () => app.db.select(app.db.voiceCues).get()),
      isEmpty,
    );

    await tearDownApp(tester);
  });

  testWidgets('microphone denial shows guidance instead of recording', (
    tester,
  ) async {
    final app = TestApp.create();
    addTearDown(app.dispose);
    final recorder = FakeCueRecorder(permitted: false);
    await dbCall(tester, () async {
      await app.completeOnboarding();
      await app.seedCat('Tiger');
    });
    final catId = (await dbCall(
      tester,
      () => app.db.select(app.db.catProfiles).get(),
    )).single.id;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(app.db),
          fileServiceProvider.overrideWithValue(app.files),
          clockProvider.overrideWithValue(app.clock),
          cueRecorderProvider.overrideWithValue(recorder),
        ],
        child: const PawSenseApp(),
      ),
    );
    await pumpUntilFound(tester, find.text("Who's playing?"));
    await goTo(tester, '/cats/$catId/voice');
    await pumpUntilFound(tester, find.text("Tiger's voice cues"));

    await tester.tap(find.text('Record').first);
    await pumpUntilFound(tester, find.text('Microphone access is off'));
    expect(find.text('Recording... speak your cue, then stop.'), findsNothing);
    expect(find.textContaining('enable Microphone'), findsOneWidget);

    await tearDownApp(tester);
  });
}
