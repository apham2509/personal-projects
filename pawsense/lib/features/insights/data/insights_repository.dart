import '../../../core/database/app_database.dart';
import '../domain/insight_models.dart';
import '../domain/insights_calculator.dart';

/// Maps database rows to pure facts and runs the calculator.
class InsightsRepository {
  InsightsRepository(this._db, {this.calculator = const InsightsCalculator()});

  final AppDatabase _db;
  final InsightsCalculator calculator;

  Future<CatInsights> computeForCat(String catId) async {
    final sessionRows = await (_db.select(
      _db.sessions,
    )..where((s) => s.catId.equals(catId))).get();
    final sessionIds = sessionRows.map((s) => s.id).toList();

    final trialRows = sessionIds.isEmpty
        ? <TargetTrial>[]
        : await (_db.select(
            _db.targetTrials,
          )..where((t) => t.sessionId.isIn(sessionIds))).get();

    final touchRows = sessionIds.isEmpty
        ? <TouchEvent>[]
        : await (_db.select(
            _db.touchEvents,
          )..where((t) => t.sessionId.isIn(sessionIds))).get();

    final cueRows = await (_db.select(
      _db.cueProgress,
    )..where((c) => c.catId.equals(catId))).get();

    return calculator.compute(
      sessions: [
        for (final row in sessionRows)
          SessionFact(
            id: row.id,
            mode: row.mode,
            status: row.status,
            startedAtUtc: row.startedAtUtc,
            actualDurationMs: row.actualDurationMs,
            catches: row.catches,
            misses: row.misses,
            timeouts: row.timeouts,
            medianReactionMs: row.medianReactionMs,
            frustrationCount: row.frustrationCount,
            isCalibration: row.calibrationSession,
          ),
      ],
      trials: [
        for (final row in trialRows)
          TrialFact(
            preyType: row.targetType,
            movementStyle: row.movementStyle,
            speedLevel: row.speedLevel,
            sizeLevel: row.sizeLevel,
            soundMode: row.soundMode,
            success: row.success,
            timedOut: row.timeout,
            reactionTimeMs: row.reactionTimeMs,
            missCount: row.missCount,
            frustrationSeverity: row.frustrationSeverity,
            cueType: row.cueType,
            difficultyAtTrial: row.difficultyAtTrial,
            endedAtUtc: row.endedAtUtc,
          ),
      ],
      touches: [
        for (final row in touchRows)
          TouchFact(
            xNormalised: row.xNormalised,
            yNormalised: row.yNormalised,
            classification: row.classification,
          ),
      ],
      cues: [
        for (final row in cueRows)
          CueInsight(
            cueType: row.cueType,
            exposures: row.exposures,
            successfulResponses: row.successfulResponses,
            reactionTimeEwmaMs: row.reactionTimeEwmaMs,
          ),
      ],
    );
  }
}
