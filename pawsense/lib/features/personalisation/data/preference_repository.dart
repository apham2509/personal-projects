import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/time/clock.dart';
import '../../../shared/models/enums.dart';
import '../../play/domain/session_models.dart';
import '../domain/algorithm_version.dart' as algo;
import '../domain/personalisation_policy.dart';
import '../domain/preference_scoring.dart';

/// Reads and writes the per-cat factor statistics that drive selection.
///
/// Writing happens once per session finalisation, inside the caller's
/// transaction. Mixed sessions never call [applyTrialUpdates] (enforced by
/// the runner: mixed sessions have no catId).
class PreferenceRepository {
  PreferenceRepository(this._db, this._clock, this._uuid);

  final AppDatabase _db;
  final Clock _clock;
  final Uuid _uuid;

  static const _rewardCalculator = TrialRewardCalculator();

  Future<PreferenceSnapshot> loadSnapshot(String catId) async {
    final query = _db.select(_db.preferenceStats)
      ..where(
        (s) =>
            s.catId.equals(catId) &
            s.algorithmVersion.equals(algo.algorithmVersion),
      );
    final rows = await query.get();
    final stats = <FactorType, Map<String, FactorStats>>{};
    for (final row in rows) {
      (stats[row.factorType] ??= {})[row.factorValue] = FactorStats(
        impressions: row.impressions,
        successes: row.successes,
        timeouts: row.timeouts,
        totalMisses: row.totalMisses,
        frustrationCount: row.frustrationCount,
        reactionTimeEwmaMs: row.reactionTimeEwmaMs,
        cumulativeReward: row.cumulativeReward,
      );
    }
    final totalTrials = (stats[FactorType.targetType] ?? const {}).values
        .fold<double>(0, (sum, s) => sum + s.impressions);
    return PreferenceSnapshot(stats: stats, totalTrials: totalTrials);
  }

  /// Seeds questionnaire priors once (no-op when any stats already exist).
  Future<void> seedPriorsIfEmpty(
    String catId,
    List<PreferenceSeed> seeds,
  ) async {
    final existing = _db.select(_db.preferenceStats)
      ..where((s) => s.catId.equals(catId))
      ..limit(1);
    if ((await existing.get()).isNotEmpty) return;
    final now = _clock.nowUtc();
    await _db.batch((batch) {
      for (final seed in seeds) {
        batch.insert(
          _db.preferenceStats,
          PreferenceStatsCompanion.insert(
            id: _uuid.v4(),
            catId: catId,
            factorType: seed.factorType,
            factorValue: seed.factorValue,
            impressions: seed.impressions,
            successes: seed.successes,
            timeouts: 0,
            totalMisses: 0,
            frustrationCount: 0,
            cumulativeReward: 0,
            updatedAtUtc: now,
            algorithmVersion: algo.algorithmVersion,
          ),
        );
      }
    });
  }

  /// Trial reward as stored on the trial row (also fed to cumulative sums).
  static double rewardFor(TrialRecord trial) => _rewardCalculator.calculate(
    caught: trial.success,
    reactionTimeMs: trial.reactionTimeMs,
    missCount: trial.missCount,
    frustrationSeverity: trial.frustrationSeverity,
    timedOut: trial.timedOut,
  );

  /// Applies every learning-valid trial's outcome to the six factor rows it
  /// touched. Call inside a transaction with the session finalisation.
  Future<void> applyTrialUpdates(String catId, List<TrialRecord> trials) async {
    final valid = trials.where((t) => t.isValidForLearning).toList();
    if (valid.isEmpty) return;
    final now = _clock.nowUtc();

    // Load current rows once, mutate in memory, then upsert.
    final query = _db.select(_db.preferenceStats)
      ..where(
        (s) =>
            s.catId.equals(catId) &
            s.algorithmVersion.equals(algo.algorithmVersion),
      );
    final rows = await query.get();
    final byKey = <String, PreferenceStat>{
      for (final row in rows) '${row.factorType.name}|${row.factorValue}': row,
    };
    final working = <String, FactorStats>{
      for (final entry in byKey.entries)
        entry.key: FactorStats(
          impressions: entry.value.impressions,
          successes: entry.value.successes,
          timeouts: entry.value.timeouts,
          totalMisses: entry.value.totalMisses,
          frustrationCount: entry.value.frustrationCount,
          reactionTimeEwmaMs: entry.value.reactionTimeEwmaMs,
          cumulativeReward: entry.value.cumulativeReward,
        ),
    };

    for (final trial in valid) {
      final reward = rewardFor(trial);
      for (final factor in FactorType.values) {
        final key = '${factor.name}|${trial.configuration.factorValue(factor)}';
        final current = working[key] ?? FactorStats.empty;
        final updated = updateFactorStats(
          impressions: current.impressions,
          successes: current.successes,
          timeouts: current.timeouts,
          totalMisses: current.totalMisses,
          frustrationCount: current.frustrationCount,
          reactionTimeEwmaMs: current.reactionTimeEwmaMs,
          cumulativeReward: current.cumulativeReward,
          caught: trial.success,
          reactionTimeMs: trial.reactionTimeMs,
          timedOut: trial.timedOut,
          trialMissCount: trial.missCount,
          frustrationSeverity: trial.frustrationSeverity,
          trialReward: reward,
        );
        working[key] = FactorStats(
          impressions: updated.impressions,
          successes: updated.successes,
          timeouts: updated.timeouts,
          totalMisses: updated.totalMisses,
          frustrationCount: updated.frustrationCount,
          reactionTimeEwmaMs: updated.reactionTimeEwmaMs,
          cumulativeReward: updated.cumulativeReward,
        );
      }
    }

    await _db.batch((batch) {
      for (final entry in working.entries) {
        final parts = entry.key.split('|');
        final factorType = FactorType.values.byName(parts[0]);
        final factorValue = parts[1];
        final stats = entry.value;
        final existing = byKey[entry.key];
        final companion = PreferenceStatsCompanion(
          id: Value(existing?.id ?? _uuid.v4()),
          catId: Value(catId),
          factorType: Value(factorType),
          factorValue: Value(factorValue),
          impressions: Value(stats.impressions),
          successes: Value(stats.successes),
          timeouts: Value(stats.timeouts),
          totalMisses: Value(stats.totalMisses),
          frustrationCount: Value(stats.frustrationCount),
          reactionTimeEwmaMs: Value(stats.reactionTimeEwmaMs),
          cumulativeReward: Value(stats.cumulativeReward),
          lastUsedAtUtc: Value(now),
          updatedAtUtc: Value(now),
          algorithmVersion: const Value(algo.algorithmVersion),
        );
        batch.insert(
          _db.preferenceStats,
          companion,
          onConflict: DoUpdate(
            (_) => companion,
            target: [
              _db.preferenceStats.catId,
              _db.preferenceStats.factorType,
              _db.preferenceStats.factorValue,
              _db.preferenceStats.algorithmVersion,
            ],
          ),
        );
      }
    });
  }

  /// Developer tool: forget the learned model (raw history untouched).
  Future<void> resetModel(String catId) async {
    final query = _db.delete(_db.preferenceStats)
      ..where((s) => s.catId.equals(catId));
    await query.go();
  }

  Stream<List<PreferenceStat>> watchStats(String catId) {
    final query = _db.select(_db.preferenceStats)
      ..where(
        (s) =>
            s.catId.equals(catId) &
            s.algorithmVersion.equals(algo.algorithmVersion),
      )
      ..orderBy([
        (s) => OrderingTerm.asc(s.factorType),
        (s) => OrderingTerm.asc(s.factorValue),
      ]);
    return query.watch();
  }
}
