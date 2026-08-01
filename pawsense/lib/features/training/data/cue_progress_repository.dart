import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/time/clock.dart';
import '../../../core/utils/stats.dart' as stats;
import '../../play/domain/session_models.dart';

/// Tracks per-cue exposure and response statistics for Touch Training.
///
/// "Cue success" is defined narrowly and honestly: a catch within the
/// trial's response window after the cue played. It never implies the cat
/// understood a word (docs/PERSONALISATION.md, "Cue training").
class CueProgressRepository {
  CueProgressRepository(this._db, this._clock, this._uuid);

  final AppDatabase _db;
  final Clock _clock;
  final Uuid _uuid;

  static const _reactionAlpha = 0.3;

  Future<void> applyTrialUpdates(String catId, List<TrialRecord> trials) async {
    final cued = trials
        .where((t) => t.cueType != null && t.isValidForLearning)
        .toList();
    if (cued.isEmpty) return;
    final now = _clock.nowUtc();

    for (final trial in cued) {
      final cueType = trial.cueType!;
      final existingQuery = _db.select(_db.cueProgress)
        ..where((c) => c.catId.equals(catId) & c.cueType.equals(cueType.name));
      final existing = await existingQuery.getSingleOrNull();

      final exposures = (existing?.exposures ?? 0) + 1;
      final successes =
          (existing?.successfulResponses ?? 0) + (trial.success ? 1 : 0);
      double? ewmaMs = existing?.reactionTimeEwmaMs;
      if (trial.success && trial.reactionTimeMs != null) {
        ewmaMs = stats.ewma(
          previous: ewmaMs,
          sample: trial.reactionTimeMs!.toDouble(),
          alpha: _reactionAlpha,
        );
      }

      if (existing == null) {
        await _db
            .into(_db.cueProgress)
            .insert(
              CueProgressCompanion.insert(
                id: _uuid.v4(),
                catId: catId,
                cueType: cueType,
                exposures: exposures,
                successfulResponses: successes,
                reactionTimeEwmaMs: Value(ewmaMs),
                lastUsedAtUtc: Value(now),
                updatedAtUtc: now,
              ),
            );
      } else {
        final update = _db.update(_db.cueProgress)
          ..where((c) => c.id.equals(existing.id));
        await update.write(
          CueProgressCompanion(
            exposures: Value(exposures),
            successfulResponses: Value(successes),
            reactionTimeEwmaMs: Value(ewmaMs),
            lastUsedAtUtc: Value(now),
            updatedAtUtc: Value(now),
          ),
        );
      }
    }
  }

  Stream<List<CueProgressData>> watchForCat(String catId) {
    final query = _db.select(_db.cueProgress)
      ..where((c) => c.catId.equals(catId));
    return query.watch();
  }
}
