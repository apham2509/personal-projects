import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/files/file_service.dart';
import '../../../core/time/clock.dart';
import '../../../shared/models/enums.dart';
import '../../personalisation/domain/algorithm_version.dart';
import '../domain/cat_profile_draft.dart';

class CatProfileRepository {
  CatProfileRepository(this._db, this._clock, this._uuid, this._files);

  final AppDatabase _db;
  final Clock _clock;
  final Uuid _uuid;
  final FileService _files;

  Stream<List<CatProfile>> watchActive() {
    final query = _db.select(_db.catProfiles)
      ..where((p) => p.archivedAtUtc.isNull())
      ..orderBy([(p) => OrderingTerm.asc(p.sortOrder)]);
    return query.watch();
  }

  Stream<List<CatProfile>> watchArchived() {
    final query = _db.select(_db.catProfiles)
      ..where((p) => p.archivedAtUtc.isNotNull())
      ..orderBy([(p) => OrderingTerm.asc(p.sortOrder)]);
    return query.watch();
  }

  Stream<CatProfile?> watchById(String id) {
    final query = _db.select(_db.catProfiles)..where((p) => p.id.equals(id));
    return query.watchSingleOrNull();
  }

  Future<CatProfile?> getById(String id) {
    final query = _db.select(_db.catProfiles)..where((p) => p.id.equals(id));
    return query.getSingleOrNull();
  }

  Future<CatProfile> create(CatProfileDraft draft) async {
    assert(draft.isValid);
    final now = _clock.nowUtc();
    final id = _uuid.v4();
    final maxOrder = await _maxSortOrder();
    final row = CatProfilesCompanion.insert(
      id: id,
      name: draft.name.trim(),
      photoPath: Value(draft.photoPath),
      createdAtUtc: now,
      updatedAtUtc: now,
      ageGroup: draft.ageGroup,
      bodySize: draft.bodySize,
      energyLevel: draft.energyLevel,
      screenExperience: draft.screenExperience,
      favouritePrey: Value(draft.favouritePrey),
      soundSensitivity: draft.soundSensitivity,
      treatMotivation: draft.treatMotivation,
      mobilityConsideration: draft.mobilityConsideration,
      visionConsideration: draft.visionConsideration,
      hearingConsideration: draft.hearingConsideration,
      primaryGoal: draft.primaryGoal,
      notes: Value(draft.notes.trim().isEmpty ? null : draft.notes.trim()),
      onboardingVersion: onboardingVersion,
      calibrationState: CalibrationState.notStarted,
      currentDifficulty: initialDifficultyFor(draft),
      algorithmVersion: algorithmVersion,
      sortOrder: maxOrder + 1,
    );
    await _db.into(_db.catProfiles).insert(row);
    return (await getById(id))!;
  }

  /// Updates the questionnaire-editable fields. Initial difficulty is not
  /// recomputed on edit: observed evidence owns difficulty after creation.
  Future<void> update(String id, CatProfileDraft draft) async {
    assert(draft.isValid);
    final query = _db.update(_db.catProfiles)..where((p) => p.id.equals(id));
    await query.write(
      CatProfilesCompanion(
        name: Value(draft.name.trim()),
        photoPath: Value(draft.photoPath),
        ageGroup: Value(draft.ageGroup),
        bodySize: Value(draft.bodySize),
        energyLevel: Value(draft.energyLevel),
        screenExperience: Value(draft.screenExperience),
        favouritePrey: Value(draft.favouritePrey),
        soundSensitivity: Value(draft.soundSensitivity),
        treatMotivation: Value(draft.treatMotivation),
        mobilityConsideration: Value(draft.mobilityConsideration),
        visionConsideration: Value(draft.visionConsideration),
        hearingConsideration: Value(draft.hearingConsideration),
        primaryGoal: Value(draft.primaryGoal),
        notes: Value(draft.notes.trim().isEmpty ? null : draft.notes.trim()),
        updatedAtUtc: Value(_clock.nowUtc()),
      ),
    );
  }

  Future<void> setPhotoPath(String id, String? relativePath) async {
    final query = _db.update(_db.catProfiles)..where((p) => p.id.equals(id));
    await query.write(
      CatProfilesCompanion(
        photoPath: Value(relativePath),
        updatedAtUtc: Value(_clock.nowUtc()),
      ),
    );
  }

  Future<void> archive(String id) => _setArchived(id, _clock.nowUtc());

  Future<void> restore(String id) => _setArchived(id, null);

  Future<void> _setArchived(String id, DateTime? at) async {
    final query = _db.update(_db.catProfiles)..where((p) => p.id.equals(id));
    await query.write(
      CatProfilesCompanion(
        archivedAtUtc: Value(at),
        updatedAtUtc: Value(_clock.nowUtc()),
      ),
    );
  }

  /// Persists an explicit ordering (picker drag-to-reorder).
  Future<void> reorder(List<String> orderedIds) async {
    final now = _clock.nowUtc();
    await _db.transaction(() async {
      for (var i = 0; i < orderedIds.length; i++) {
        final query = _db.update(_db.catProfiles)
          ..where((p) => p.id.equals(orderedIds[i]));
        await query.write(
          CatProfilesCompanion(sortOrder: Value(i), updatedAtUtc: Value(now)),
        );
      }
    });
  }

  /// Permanently removes the profile row (sessions, trials, events, stats,
  /// cue progress, and voice cue rows cascade) plus all media files.
  Future<void> deletePermanently(String id) async {
    final query = _db.delete(_db.catProfiles)..where((p) => p.id.equals(id));
    await query.go();
    await _files.deleteProfileTree(id);
  }

  Future<void> setCalibrationState(String id, CalibrationState state) async {
    final query = _db.update(_db.catProfiles)..where((p) => p.id.equals(id));
    await query.write(
      CatProfilesCompanion(
        calibrationState: Value(state),
        updatedAtUtc: Value(_clock.nowUtc()),
      ),
    );
  }

  Future<void> setDifficulty(String id, int difficulty) async {
    assert(difficulty >= 0 && difficulty <= 10);
    final query = _db.update(_db.catProfiles)..where((p) => p.id.equals(id));
    await query.write(
      CatProfilesCompanion(
        currentDifficulty: Value(difficulty),
        updatedAtUtc: Value(_clock.nowUtc()),
      ),
    );
  }

  Future<int> _maxSortOrder() async {
    final max = _db.catProfiles.sortOrder.max();
    final query = _db.selectOnly(_db.catProfiles)..addColumns([max]);
    final row = await query.getSingle();
    return row.read(max) ?? -1;
  }
}
