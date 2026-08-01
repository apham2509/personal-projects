import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/core/database/app_database.dart';
import 'package:pawsense/core/files/file_service.dart';
import 'package:pawsense/core/time/clock.dart';
import 'package:pawsense/features/cat_profiles/data/cat_profile_repository.dart';
import 'package:pawsense/features/cat_profiles/domain/cat_profile_draft.dart';
import 'package:pawsense/features/voice_cues/data/voice_cue_repository.dart';
import 'package:pawsense/shared/models/enums.dart';
import 'package:uuid/uuid.dart';

void main() {
  late AppDatabase db;
  late Directory tempDir;
  late FileService files;
  late VoiceCueRepository repo;
  late CatProfileRepository profiles;
  late String catId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    tempDir = Directory.systemTemp.createTempSync('pawsense_voice_test');
    files = FileService(tempDir);
    final clock = FakeClock(DateTime.utc(2026, 8, 1));
    repo = VoiceCueRepository(db, clock, const Uuid(), files);
    profiles = CatProfileRepository(db, clock, const Uuid(), files);
    catId = (await profiles.create(const CatProfileDraft(name: 'Tiger'))).id;
  });

  tearDown(() async {
    await db.close();
    tempDir.deleteSync(recursive: true);
  });

  File tempRecording(String name) =>
      File('${tempDir.path}/$name')..writeAsBytesSync([1, 2, 3, 4]);

  test(
    'saveRecording moves the file into the profile tree and upserts',
    () async {
      final temp = tempRecording('rec1.m4a.tmp');
      await repo.saveRecording(
        catId: catId,
        cueType: CueType.touch,
        temporaryRecording: temp,
        durationMs: 900,
      );

      expect(temp.existsSync(), isFalse, reason: 'temp file cleaned up');
      final cues = await repo.watchForCat(catId).first;
      expect(cues.single.cueType, CueType.touch);
      expect(cues.single.durationMs, 900);
      expect(cues.single.filePath, 'profiles/$catId/cues/touch.m4a');
      expect(files.resolve(cues.single.filePath).existsSync(), isTrue);

      // Re-recording replaces, never duplicates.
      await repo.saveRecording(
        catId: catId,
        cueType: CueType.touch,
        temporaryRecording: tempRecording('rec2.m4a.tmp'),
        durationMs: 1200,
      );
      final updated = await repo.watchForCat(catId).first;
      expect(updated, hasLength(1));
      expect(updated.single.durationMs, 1200);
    },
  );

  test('deleteCue removes the row and the audio file', () async {
    await repo.saveRecording(
      catId: catId,
      cueType: CueType.good,
      temporaryRecording: tempRecording('rec.m4a.tmp'),
      durationMs: 700,
    );
    final path = (await repo.watchForCat(catId).first).single.filePath;
    expect(files.resolve(path).existsSync(), isTrue);

    await repo.deleteCue(catId, CueType.good);
    expect(await repo.watchForCat(catId).first, isEmpty);
    expect(files.resolve(path).existsSync(), isFalse);
  });

  test('cueFilePaths returns only cues whose files still exist', () async {
    await repo.saveRecording(
      catId: catId,
      cueType: CueType.touch,
      temporaryRecording: tempRecording('a.m4a.tmp'),
      durationMs: 500,
    );
    await repo.saveRecording(
      catId: catId,
      cueType: CueType.allDone,
      temporaryRecording: tempRecording('b.m4a.tmp'),
      durationMs: 600,
    );
    // Simulate a missing file (e.g. restored backup without media).
    await files.deleteRelative('profiles/$catId/cues/allDone.m4a');

    final paths = await repo.cueFilePaths(catId);
    expect(paths.keys, [CueType.touch]);
  });

  test(
    'profile deletion cascades cue rows and removes the media tree',
    () async {
      await repo.saveRecording(
        catId: catId,
        cueType: CueType.goodJob,
        temporaryRecording: tempRecording('c.m4a.tmp'),
        durationMs: 800,
      );
      await profiles.deletePermanently(catId);
      expect(await db.select(db.voiceCues).get(), isEmpty);
      expect(files.profileDir(catId).existsSync(), isFalse);
    },
  );
}
