import 'dart:io';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/files/file_service.dart';
import '../../../core/time/clock.dart';
import '../../../shared/models/enums.dart';

/// Owner-recorded voice cues: one recording per cue slot per cat, stored as
/// m4a files in the profile directory and referenced by relative path.
/// Audio never leaves the device.
class VoiceCueRepository {
  VoiceCueRepository(this._db, this._clock, this._uuid, this._files);

  final AppDatabase _db;
  final Clock _clock;
  final Uuid _uuid;
  final FileService _files;

  Stream<List<VoiceCue>> watchForCat(String catId) {
    final query = _db.select(_db.voiceCues)
      ..where((c) => c.catId.equals(catId));
    return query.watch();
  }

  /// Relative file paths per cue type, for the session runner.
  Future<Map<CueType, String>> cueFilePaths(String catId) async {
    final query = _db.select(_db.voiceCues)
      ..where((c) => c.catId.equals(catId));
    final rows = await query.get();
    return {
      for (final row in rows)
        if (_files.resolve(row.filePath).existsSync())
          row.cueType: row.filePath,
    };
  }

  /// Moves a finished temporary recording into the profile tree and upserts
  /// the cue row.
  Future<void> saveRecording({
    required String catId,
    required CueType cueType,
    required File temporaryRecording,
    required int durationMs,
  }) async {
    final relative = await _files.saveCueRecording(
      catId,
      cueType.name,
      temporaryRecording,
    );
    if (temporaryRecording.existsSync()) {
      temporaryRecording.deleteSync();
    }
    final now = _clock.nowUtc();
    final existingQuery = _db.select(_db.voiceCues)
      ..where((c) => c.catId.equals(catId) & c.cueType.equals(cueType.name));
    final existing = await existingQuery.getSingleOrNull();
    if (existing == null) {
      await _db
          .into(_db.voiceCues)
          .insert(
            VoiceCuesCompanion.insert(
              id: _uuid.v4(),
              catId: catId,
              cueType: cueType,
              filePath: relative,
              durationMs: durationMs,
              createdAtUtc: now,
              updatedAtUtc: now,
            ),
          );
    } else {
      final update = _db.update(_db.voiceCues)
        ..where((c) => c.id.equals(existing.id));
      await update.write(
        VoiceCuesCompanion(
          filePath: Value(relative),
          durationMs: Value(durationMs),
          updatedAtUtc: Value(now),
        ),
      );
    }
  }

  /// Removes the recording file and its row.
  Future<void> deleteCue(String catId, CueType cueType) async {
    final query = _db.select(_db.voiceCues)
      ..where((c) => c.catId.equals(catId) & c.cueType.equals(cueType.name));
    final existing = await query.getSingleOrNull();
    if (existing == null) return;
    await _files.deleteRelative(existing.filePath);
    final deleteQuery = _db.delete(_db.voiceCues)
      ..where((c) => c.id.equals(existing.id));
    await deleteQuery.go();
  }
}
