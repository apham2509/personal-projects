import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/features/insights/domain/insight_models.dart';
import 'package:pawsense/features/insights/domain/insights_calculator.dart';
import 'package:pawsense/shared/models/enums.dart';

void main() {
  const calculator = InsightsCalculator();

  TrialFact trial({
    PreyType prey = PreyType.mouse,
    MovementStyle movement = MovementStyle.smooth,
    bool success = true,
    bool timedOut = false,
    int? reactionMs = 1000,
    int severity = 0,
    int difficulty = 2,
  }) => TrialFact(
    preyType: prey,
    movementStyle: movement,
    speedLevel: SpeedLevel.slow,
    sizeLevel: SizeLevel.large,
    soundMode: SoundMode.silent,
    success: success,
    timedOut: timedOut,
    reactionTimeMs: success ? reactionMs : null,
    missCount: success ? 0 : 1,
    frustrationSeverity: severity,
    cueType: null,
    difficultyAtTrial: difficulty,
    endedAtUtc: DateTime.utc(2026, 8, 1),
  );

  SessionFact session({
    required int index,
    SessionStatus status = SessionStatus.completed,
    int catches = 5,
    int timeouts = 2,
    int? medianReactionMs = 1500,
    DateTime? startedAt,
  }) => SessionFact(
    id: 'session-$index',
    mode: SessionMode.freePlay,
    status: status,
    startedAtUtc: startedAt ?? DateTime.utc(2026, 7, 1 + index, 12),
    actualDurationMs: 180000,
    catches: catches,
    misses: 3,
    timeouts: timeouts,
    medianReactionMs: medianReactionMs,
    frustrationCount: 0,
    isCalibration: false,
  );

  CatInsights compute({
    List<SessionFact> sessions = const [],
    List<TrialFact> trials = const [],
    List<TouchFact> touches = const [],
  }) => calculator.compute(
    sessions: sessions,
    trials: trials,
    touches: touches,
    cues: const [],
  );

  test('below 8 comparable impressions no favourite is claimed', () {
    // 7 perfect moth catches: impressive but insufficient.
    final insights = compute(
      sessions: [session(index: 0)],
      trials: [for (var i = 0; i < 7; i++) trial(prey: PreyType.moth)],
    );
    final prey = insights.favourites.firstWhere(
      (f) => f.factorType == FactorType.targetType,
    );
    expect(prey.tier, ConfidenceTier.insufficient);
    expect(prey.showable, isFalse);
  });

  test('a favourite needs a clear utility gap, not just more trials', () {
    // Two prey with identical performance: no favourite even at n=20.
    final insights = compute(
      sessions: [session(index: 0)],
      trials: [
        for (var i = 0; i < 20; i++) trial(prey: PreyType.moth),
        for (var i = 0; i < 20; i++) trial(prey: PreyType.mouse),
      ],
    );
    final prey = insights.favourites.firstWhere(
      (f) => f.factorType == FactorType.targetType,
    );
    expect(prey.tier, ConfidenceTier.developingPattern);
    expect(prey.utilityGap, lessThan(0.08));
    expect(prey.showable, isFalse);
  });

  test('clear preference with enough data becomes a showable favourite', () {
    final insights = compute(
      sessions: [session(index: 0)],
      trials: [
        for (var i = 0; i < 20; i++)
          trial(prey: PreyType.moth, reactionMs: 800),
        for (var i = 0; i < 20; i++)
          trial(prey: PreyType.mouse, success: false, timedOut: true),
      ],
    );
    final prey = insights.favourites.firstWhere(
      (f) => f.factorType == FactorType.targetType,
    );
    expect(prey.topValue, 'moth');
    expect(prey.tier, ConfidenceTier.developingPattern);
    expect(prey.showable, isTrue);
    expect(prey.topSuccesses, 20);
    expect(prey.topComparable, 20);
  });

  test(
    'personality title appears only when prey AND movement are showable',
    () {
      final onlyPrey = compute(
        sessions: [session(index: 0)],
        trials: [
          // Moth wins clearly, but movement is balanced.
          for (var i = 0; i < 12; i++)
            trial(prey: PreyType.moth, movement: MovementStyle.smooth),
          for (var i = 0; i < 12; i++)
            trial(prey: PreyType.moth, movement: MovementStyle.unpredictable),
          for (var i = 0; i < 12; i++)
            trial(
              prey: PreyType.fish,
              movement: MovementStyle.smooth,
              success: false,
              timedOut: true,
            ),
          for (var i = 0; i < 12; i++)
            trial(
              prey: PreyType.fish,
              movement: MovementStyle.unpredictable,
              success: false,
              timedOut: true,
            ),
        ],
      );
      expect(onlyPrey.personalityTitleKey, isNull);

      final both = compute(
        sessions: [session(index: 0)],
        trials: [
          for (var i = 0; i < 20; i++)
            trial(
              prey: PreyType.moth,
              movement: MovementStyle.unpredictable,
              reactionMs: 700,
            ),
          for (var i = 0; i < 20; i++)
            trial(
              prey: PreyType.mouse,
              movement: MovementStyle.smooth,
              success: false,
              timedOut: true,
            ),
        ],
      );
      expect(both.personalityTitleKey, 'personality_moth_unpredictable');
    },
  );

  test('median reaction uses the median, not the mean', () {
    final insights = compute(
      sessions: [session(index: 0)],
      trials: [
        trial(reactionMs: 500),
        trial(reactionMs: 600),
        trial(reactionMs: 9000), // outlier must not drag the number up
      ],
    );
    expect(insights.medianReactionMs, 600);
  });

  test('heatmap bins normalised touches into a 12x8 grid', () {
    final insights = compute(
      touches: [
        const TouchFact(
          xNormalised: 0.0,
          yNormalised: 0.0,
          classification: TouchClassification.hit,
        ),
        const TouchFact(
          xNormalised: 0.999,
          yNormalised: 0.999,
          classification: TouchClassification.miss,
        ),
        const TouchFact(
          xNormalised: 0.5,
          yNormalised: 0.5,
          classification: TouchClassification.edge,
        ),
        // Owner gestures and duplicates never appear in the heatmap.
        const TouchFact(
          xNormalised: 0.5,
          yNormalised: 0.5,
          classification: TouchClassification.ownerGesture,
        ),
        const TouchFact(
          xNormalised: 0.5,
          yNormalised: 0.5,
          classification: TouchClassification.ignoredDuplicate,
        ),
      ],
    );
    final heatmap = insights.heatmap;
    expect(heatmap.columns, 12);
    expect(heatmap.rows, 8);
    expect(heatmap.totalTouches, 3);
    expect(heatmap.hitCounts[0][0], 1);
    expect(heatmap.otherCounts[7][11], 1);
    expect(heatmap.otherCounts[4][6], 1);
  });

  test('day-part pattern requires at least 10 sessions', () {
    final nine = compute(
      sessions: [for (var i = 0; i < 9; i++) session(index: i)],
    );
    expect(nine.dayPartPattern, isNull);

    final twelve = compute(
      sessions: [
        for (var i = 0; i < 12; i++)
          session(
            index: i,
            // All at 12:00 UTC; local conversion keeps them in one part.
            startedAt: DateTime.utc(2026, 7, 1 + i, 12),
          ),
      ],
    );
    expect(twelve.dayPartPattern, isNotNull);
    expect(twelve.dayPartPattern!.totalSessions, 12);
  });

  test('completion reasons count sessions per terminal status', () {
    final insights = compute(
      sessions: [
        session(index: 0),
        session(index: 1),
        session(index: 2, status: SessionStatus.disengaged),
        session(index: 3, status: SessionStatus.ownerStopped),
      ],
    );
    expect(insights.completionReasons[SessionStatus.completed], 2);
    expect(insights.completionReasons[SessionStatus.disengaged], 1);
    expect(insights.completionReasons[SessionStatus.ownerStopped], 1);
    expect(
      insights.completionReasons.containsKey(SessionStatus.frustrated),
      isFalse,
    );
  });

  test('trends cover at most the last 20 sessions, oldest first', () {
    final insights = compute(
      sessions: [for (var i = 0; i < 30; i++) session(index: i)],
    );
    expect(insights.catchRateTrend.length, 20);
    expect(insights.catchRateTrend.first.sessionIndex, 0);
    expect(insights.catchRateTrend.last.sessionIndex, 19);
    expect(insights.catchRateTrend.last.value, closeTo(5 / 7, 1e-9));
  });
}
