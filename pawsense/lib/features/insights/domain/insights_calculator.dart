import '../../../core/utils/stats.dart';
import '../../../shared/models/enums.dart';
import '../../personalisation/domain/preference_scoring.dart';
import 'insight_models.dart';

/// Pure computation of every owner-facing insight from raw facts.
///
/// Honesty rules (product spec sections 11.G and 14):
/// - sample sizes are raw comparable-trial counts, never decayed;
/// - below 8 comparable impressions a dimension shows no conclusion;
/// - a "favourite" needs a utility lead of >= 0.08 over the runner-up;
/// - median (not mean) reaction times;
/// - time-of-day pattern only with >= 10 sessions.
class InsightsCalculator {
  const InsightsCalculator({
    this.trendWindow = 20,
    this.heatmapColumns = 12,
    this.heatmapRows = 8,
    this.minSessionsForDayPart = 10,
    this.scorer = const PreferenceScorer(),
  });

  final int trendWindow;
  final int heatmapColumns;
  final int heatmapRows;
  final int minSessionsForDayPart;
  final PreferenceScorer scorer;

  CatInsights compute({
    required List<SessionFact> sessions,
    required List<TrialFact> trials,
    required List<TouchFact> touches,
    required List<CueInsight> cues,
  }) {
    final playSessions =
        sessions.where((s) => s.status != SessionStatus.inProgress).toList()
          ..sort((a, b) => a.startedAtUtc.compareTo(b.startedAtUtc));
    final comparable = trials.where((t) => t.isComparable).toList();

    final favourites = <FavouriteInsight>[
      for (final factor in const [
        FactorType.targetType,
        FactorType.movementStyle,
        FactorType.speedLevel,
        FactorType.sizeLevel,
      ])
        _favouriteFor(factor, comparable),
    ];

    final preyFavourite = favourites.firstWhere(
      (f) => f.factorType == FactorType.targetType,
    );
    final movementFavourite = favourites.firstWhere(
      (f) => f.factorType == FactorType.movementStyle,
    );
    String? personalityKey;
    if (preyFavourite.showable && movementFavourite.showable) {
      personalityKey =
          'personality_${preyFavourite.topValue}_${movementFavourite.topValue}';
    }

    final recent = playSessions.length <= trendWindow
        ? playSessions
        : playSessions.sublist(playSessions.length - trendWindow);

    final now = playSessions.isEmpty
        ? DateTime.now().toUtc()
        : playSessions.last.startedAtUtc;

    return CatInsights(
      lifetimeSessions: playSessions.length,
      sessionsLast7Days: playSessions
          .where((s) => now.difference(s.startedAtUtc).inDays < 7)
          .length,
      lifetimeCatches: comparable.where((t) => t.success).length,
      lifetimeComparableTrials: comparable.length,
      medianReactionMs: medianInt(
        comparable
            .where((t) => t.success && t.reactionTimeMs != null)
            .map((t) => t.reactionTimeMs!),
      ),
      totalPlayMs: playSessions.fold(
        0,
        (sum, s) => sum + (s.actualDurationMs ?? 0),
      ),
      favourites: favourites,
      catchRateTrend: [
        for (final (index, session) in recent.indexed)
          if (session.catchRate != null)
            TrendPoint(sessionIndex: index, value: session.catchRate!),
      ],
      reactionTrend: [
        for (final (index, session) in recent.indexed)
          if (session.medianReactionMs != null)
            TrendPoint(
              sessionIndex: index,
              value: session.medianReactionMs!.toDouble(),
            ),
      ],
      difficultyTrend: _difficultyTrend(trials),
      heatmap: _heatmap(touches),
      cues: cues,
      completionReasons: {
        for (final status in SessionStatus.values)
          if (playSessions.where((s) => s.status == status).isNotEmpty)
            status: playSessions.where((s) => s.status == status).length,
      },
      dayPartPattern: _dayPartPattern(playSessions),
      frustrationTrials: comparable
          .where((t) => t.frustrationSeverity >= 1)
          .length,
      personalityTitleKey: personalityKey,
    );
  }

  FavouriteInsight _favouriteFor(
    FactorType factor,
    List<TrialFact> comparable,
  ) {
    // Raw per-value stats for this dimension.
    final byValue = <String, List<TrialFact>>{};
    for (final trial in comparable) {
      byValue.putIfAbsent(trial.factorValue(factor), () => []).add(trial);
    }

    FactorStats statsOf(List<TrialFact> trials) {
      final successes = trials.where((t) => t.success).toList();
      return FactorStats(
        impressions: trials.length.toDouble(),
        successes: successes.length.toDouble(),
        timeouts: trials.where((t) => t.timedOut).length.toDouble(),
        totalMisses: trials.fold(0, (sum, t) => sum + t.missCount).toDouble(),
        frustrationCount: trials
            .where((t) => t.frustrationSeverity > 0)
            .length
            .toDouble(),
        reactionTimeEwmaMs: medianDouble(
          successes
              .where((t) => t.reactionTimeMs != null)
              .map((t) => t.reactionTimeMs!.toDouble()),
        ),
      );
    }

    if (byValue.isEmpty) {
      return FavouriteInsight(
        factorType: factor,
        topValue: '',
        topSuccesses: 0,
        topComparable: 0,
        tier: ConfidenceTier.insufficient,
        utilityGap: 0,
      );
    }

    final scored =
        byValue.entries
            .map(
              (entry) => (
                value: entry.key,
                trials: entry.value,
                utility: scorer.utility(statsOf(entry.value)),
              ),
            )
            .toList()
          ..sort((a, b) => b.utility.compareTo(a.utility));

    final top = scored.first;
    final gap = scored.length < 2 ? 0.0 : top.utility - scored[1].utility;

    return FavouriteInsight(
      factorType: factor,
      topValue: top.value,
      topSuccesses: top.trials.where((t) => t.success).length,
      topComparable: top.trials.length,
      tier: confidenceTierFor(top.trials.length),
      utilityGap: gap,
    );
  }

  List<TrendPoint> _difficultyTrend(List<TrialFact> trials) {
    final withTime = trials.where((t) => t.endedAtUtc != null).toList()
      ..sort((a, b) => a.endedAtUtc!.compareTo(b.endedAtUtc!));
    final recent = withTime.length <= 60
        ? withTime
        : withTime.sublist(withTime.length - 60);
    return [
      for (final (index, trial) in recent.indexed)
        TrendPoint(
          sessionIndex: index,
          value: trial.difficultyAtTrial.toDouble(),
        ),
    ];
  }

  TouchHeatmap _heatmap(List<TouchFact> touches) {
    final hits = List.generate(
      heatmapRows,
      (_) => List.filled(heatmapColumns, 0),
    );
    final other = List.generate(
      heatmapRows,
      (_) => List.filled(heatmapColumns, 0),
    );
    var total = 0;
    for (final touch in touches) {
      final isHit = touch.classification == TouchClassification.hit;
      final isOther =
          touch.classification == TouchClassification.miss ||
          touch.classification == TouchClassification.edge;
      if (!isHit && !isOther) continue;
      final column = (touch.xNormalised * heatmapColumns).floor().clamp(
        0,
        heatmapColumns - 1,
      );
      final row = (touch.yNormalised * heatmapRows).floor().clamp(
        0,
        heatmapRows - 1,
      );
      if (isHit) {
        hits[row][column]++;
      } else {
        other[row][column]++;
      }
      total++;
    }
    return TouchHeatmap(
      columns: heatmapColumns,
      rows: heatmapRows,
      hitCounts: hits,
      otherCounts: other,
      totalTouches: total,
    );
  }

  DayPartPattern? _dayPartPattern(List<SessionFact> sessions) {
    if (sessions.length < minSessionsForDayPart) return null;
    final byPart = <DayPart, List<SessionFact>>{};
    for (final session in sessions) {
      final hour = session.startedAtUtc.toLocal().hour;
      final part = switch (hour) {
        >= 5 && < 11 => DayPart.morning,
        >= 11 && < 17 => DayPart.afternoon,
        >= 17 && < 23 => DayPart.evening,
        _ => DayPart.night,
      };
      byPart.putIfAbsent(part, () => []).add(session);
    }
    DayPart? best;
    double bestRate = -1;
    for (final entry in byPart.entries) {
      final rates = entry.value
          .map((s) => s.catchRate)
          .whereType<double>()
          .toList();
      if (entry.value.length < 3 || rates.isEmpty) continue;
      final rate = rates.reduce((a, b) => a + b) / rates.length;
      if (rate > bestRate) {
        bestRate = rate;
        best = entry.key;
      }
    }
    if (best == null) return null;
    return DayPartPattern(
      best: best,
      sessionsInBest: byPart[best]!.length,
      catchRateInBest: bestRate,
      totalSessions: sessions.length,
    );
  }
}
