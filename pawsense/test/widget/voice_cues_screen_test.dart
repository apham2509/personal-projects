import 'dart:io';

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

  @override
  Future<bool> hasPermission() async => permitted;

  @override
  Future<void> start(String path) async {
    activePath = path;
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
    activePath = null;
  }

  @override
  Future<void> dispose() async {}
}

void main() {
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
    var openedSettings = 0;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(app.db),
          fileServiceProvider.overrideWithValue(app.files),
          clockProvider.overrideWithValue(app.clock),
          cueRecorderProvider.overrideWithValue(recorder),
          openAppSettingsProvider.overrideWithValue(() async {
            openedSettings++;
            return true;
          }),
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

    await tester.tap(find.text('Open system settings'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(openedSettings, 1);

    await tearDownApp(tester);
  });
}
