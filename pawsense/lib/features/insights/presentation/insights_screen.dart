import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/l10n_ext.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/models/enums.dart';
import '../../../shared/providers/core_providers.dart';
import '../data/insights_repository.dart';
import '../domain/insight_models.dart';
import 'heatmap_painter.dart';

final insightsRepositoryProvider = Provider<InsightsRepository>(
  (ref) => InsightsRepository(ref.watch(databaseProvider)),
);

final catInsightsProvider = FutureProvider.family<CatInsights, String>(
  (ref, catId) => ref.watch(insightsRepositoryProvider).computeForCat(catId),
);

/// The owner dashboard: honest, sample-sized, confidence-labelled insights.
class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key, required this.catId});

  final String catId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final cat = ref.watch(catProfileProvider(catId)).value;
    final insightsAsync = ref.watch(catInsightsProvider(catId));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          cat == null
              ? l10n.insightsTitleGeneric
              : l10n.insightsTitle(cat.name),
        ),
      ),
      body: insightsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.errorGenericBody)),
        data: (insights) => insights.lifetimeSessions == 0
            ? _EmptyState(catName: cat?.name ?? '')
            : _InsightsBody(insights: insights, catName: cat?.name ?? ''),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.catName});

  final String catName;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.insights_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.insightsEmptyTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(l10n.insightsEmptyBody(catName), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _InsightsBody extends StatelessWidget {
  const _InsightsBody({required this.insights, required this.catName});

  final CatInsights insights;
  final String catName;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Headline numbers.
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _StatTile(
                  label: l10n.insightsSessions,
                  value: '${insights.lifetimeSessions}',
                  caption: l10n.insightsSessionsWeek(
                    insights.sessionsLast7Days,
                  ),
                ),
                _StatTile(
                  label: l10n.insightsCatches,
                  value: '${insights.lifetimeCatches}',
                  caption: l10n.insightsOfTrials(
                    insights.lifetimeComparableTrials,
                  ),
                ),
                _StatTile(
                  label: l10n.resultsCatchRate,
                  value: insights.lifetimeCatchRate == null
                      ? '-'
                      : '${(insights.lifetimeCatchRate! * 100).round()}%',
                  caption: l10n.insightsComparableOnly,
                ),
                _StatTile(
                  label: l10n.resultsMedianReaction,
                  value: insights.medianReactionMs == null
                      ? '-'
                      : l10n.resultsSeconds(
                          (insights.medianReactionMs! / 1000).toStringAsFixed(
                            1,
                          ),
                        ),
                  caption: l10n.insightsPlayTime(
                    (insights.totalPlayMs / 60000).toStringAsFixed(0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (insights.personalityTitleKey != null)
              _PersonalityCard(
                titleKey: insights.personalityTitleKey!,
                catName: catName,
              ),

            _SectionHeader(l10n.insightsFavouritesSection),
            for (final favourite in insights.favourites)
              _FavouriteCard(favourite: favourite, catName: catName),

            if (insights.catchRateTrend.length >= 3) ...[
              _SectionHeader(l10n.insightsTrendsSection),
              _TrendCard(
                title: l10n.insightsCatchRateTrend,
                points: insights.catchRateTrend,
                asPercent: true,
              ),
              if (insights.reactionTrend.length >= 3)
                _TrendCard(
                  title: l10n.insightsReactionTrend,
                  points: insights.reactionTrend,
                  asPercent: false,
                ),
              if (insights.difficultyTrend.length >= 3)
                _TrendCard(
                  title: l10n.insightsDifficultyTrend,
                  points: insights.difficultyTrend,
                  asPercent: false,
                  maxY: 10,
                ),
            ],

            _SectionHeader(l10n.insightsHeatmapSection),
            _HeatmapCard(heatmap: insights.heatmap),

            if (insights.cues.any((c) => c.exposures > 0)) ...[
              _SectionHeader(l10n.insightsCueSection),
              _CueCard(cues: insights.cues),
            ],

            if (insights.dayPartPattern != null)
              _DayPartCard(pattern: insights.dayPartPattern!),

            _SectionHeader(l10n.insightsCompletionSection),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final entry in insights.completionReasons.entries)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_statusLabel(l10n, entry.key)),
                            Text(
                              '${entry.value}',
                              style: theme.textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                    if (insights.frustrationTrials > 0) ...[
                      const Divider(),
                      Text(
                        l10n.insightsFrustrationNote(
                          insights.frustrationTrials,
                        ),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(l10n.insightsMethodNote, style: theme.textTheme.bodySmall),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _statusLabel(AppLocalizations l10n, SessionStatus status) =>
      switch (status) {
        SessionStatus.completed => l10n.statusCompleted,
        SessionStatus.ownerStopped => l10n.statusOwnerStopped,
        SessionStatus.disengaged => l10n.statusDisengaged,
        SessionStatus.frustrated => l10n.statusFrustrated,
        SessionStatus.backgrounded => l10n.statusBackgrounded,
        SessionStatus.interrupted => l10n.statusInterrupted,
        SessionStatus.inProgress => l10n.statusInProgress,
      };
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.caption,
  });

  final String label;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: theme.textTheme.headlineSmall),
            Text(label, style: theme.textTheme.bodyMedium),
            Text(caption, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _FavouriteCard extends StatelessWidget {
  const _FavouriteCard({required this.favourite, required this.catName});

  final FavouriteInsight favourite;
  final String catName;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    final dimension = switch (favourite.factorType) {
      FactorType.targetType => l10n.insightsDimensionPrey,
      FactorType.movementStyle => l10n.insightsDimensionMovement,
      FactorType.speedLevel => l10n.insightsDimensionSpeed,
      FactorType.sizeLevel => l10n.insightsDimensionSize,
      _ => '',
    };

    if (!favourite.showable) {
      return Card(
        child: ListTile(
          leading: const Icon(Icons.hourglass_empty),
          title: Text(dimension),
          subtitle: Text(l10n.insightsNoConclusion(favourite.topComparable)),
        ),
      );
    }

    final valueLabel = _valueLabel(l10n, favourite);
    final tierLabel = switch (favourite.tier) {
      ConfidenceTier.earlyObservation => l10n.confidenceEarly,
      ConfidenceTier.developingPattern => l10n.confidenceDeveloping,
      ConfidenceTier.strongPattern => l10n.confidenceStrong,
      ConfidenceTier.insufficient => '',
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$dimension: $valueLabel',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Chip(
                  label: Text(tierLabel),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              l10n.insightsFavouriteEvidence(
                catName,
                valueLabel,
                favourite.topSuccesses,
                favourite.topComparable,
              ),
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  String _valueLabel(AppLocalizations l10n, FavouriteInsight favourite) {
    switch (favourite.factorType) {
      case FactorType.targetType:
        return switch (favourite.topValue) {
          'mouse' => l10n.preyMouse,
          'moth' => l10n.preyMothBug,
          _ => l10n.preyFish,
        };
      case FactorType.movementStyle:
        return switch (favourite.topValue) {
          'smooth' => l10n.movementSmooth,
          'stopAndGo' => l10n.movementStopGo,
          _ => l10n.movementUnpredictable,
        };
      case FactorType.speedLevel:
        return switch (favourite.topValue) {
          'slow' => l10n.speedSlow,
          'medium' => l10n.speedMedium,
          _ => l10n.speedFast,
        };
      case FactorType.sizeLevel:
        return switch (favourite.topValue) {
          'small' => l10n.bodySmall,
          'medium' => l10n.bodyMedium,
          _ => l10n.bodyLarge,
        };
      case FactorType.soundMode || FactorType.spawnZone:
        return favourite.topValue;
    }
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard({
    required this.title,
    required this.points,
    required this.asPercent,
    this.maxY,
  });

  final String title;
  final List<TrendPoint> points;
  final bool asPercent;
  final double? maxY;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY:
                      maxY ??
                      (asPercent
                          ? 1
                          : points
                                    .map((p) => p.value)
                                    .reduce((a, b) => a > b ? a : b) *
                                1.2),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(),
                    rightTitles: const AxisTitles(),
                    bottomTitles: const AxisTitles(),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 44,
                        getTitlesWidget: (value, meta) => Text(
                          asPercent
                              ? '${(value * 100).round()}%'
                              : value >= 1000
                              ? '${(value / 1000).toStringAsFixed(1)}s'
                              : value.toStringAsFixed(0),
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: theme.colorScheme.outlineVariant,
                      strokeWidth: 0.5,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        for (final point in points)
                          FlSpot(point.sessionIndex.toDouble(), point.value),
                      ],
                      isCurved: true,
                      preventCurveOverShooting: true,
                      color: theme.colorScheme.primary,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeatmapCard extends StatelessWidget {
  const _HeatmapCard({required this.heatmap});

  final TouchHeatmap heatmap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (heatmap.totalTouches == 0)
              Text(l10n.insightsHeatmapEmpty)
            else ...[
              AspectRatio(
                aspectRatio: heatmap.columns / heatmap.rows,
                child: CustomPaint(
                  painter: HeatmapPainter(
                    heatmap: heatmap,
                    hitColour: theme.colorScheme.primary,
                    otherColour: theme.colorScheme.outline,
                    gridColour: theme.colorScheme.outlineVariant,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.square_rounded,
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n.insightsHeatmapHits,
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.square_rounded,
                    size: 14,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n.insightsHeatmapOther,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              Text(
                l10n.insightsHeatmapSample(heatmap.totalTouches),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CueCard extends StatelessWidget {
  const _CueCard({required this.cues});

  final List<CueInsight> cues;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final used = cues.where((c) => c.exposures > 0).toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final cue in used) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(switch (cue.cueType) {
                    CueType.touch => l10n.cueTouch,
                    CueType.good => l10n.cueGood,
                    CueType.goodJob => l10n.cueGoodJob,
                    CueType.allDone => l10n.cueAllDone,
                    CueType.catName => l10n.insightsCueName,
                  }, style: theme.textTheme.titleSmall),
                  Text(
                    l10n.insightsCueStats(
                      cue.successfulResponses,
                      cue.exposures,
                      cue.reactionTimeEwmaMs == null
                          ? '-'
                          : (cue.reactionTimeEwmaMs! / 1000).toStringAsFixed(1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
            ],
            Text(l10n.insightsCueCaveat, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _DayPartCard extends StatelessWidget {
  const _DayPartCard({required this.pattern});

  final DayPartPattern pattern;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final partLabel = switch (pattern.best) {
      DayPart.morning => l10n.dayPartMorning,
      DayPart.afternoon => l10n.dayPartAfternoon,
      DayPart.evening => l10n.dayPartEvening,
      DayPart.night => l10n.dayPartNight,
    };
    return Card(
      child: ListTile(
        leading: const Icon(Icons.schedule),
        title: Text(l10n.insightsDayPartTitle(partLabel)),
        subtitle: Text(
          l10n.insightsDayPartBody(
            (pattern.catchRateInBest * 100).round(),
            pattern.sessionsInBest,
            pattern.totalSessions,
          ),
        ),
      ),
    );
  }
}

class _PersonalityCard extends StatelessWidget {
  const _PersonalityCard({required this.titleKey, required this.catName});

  final String titleKey;
  final String catName;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final title = personalityTitle(l10n, titleKey);
    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$catName: $title', style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              l10n.insightsPersonalityCaveat,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

/// Playful title per prey x movement favourite pair. Kept in one place so
/// copy stays in ARB files.
String personalityTitle(AppLocalizations l10n, String key) => switch (key) {
  'personality_mouse_smooth' => l10n.personalityMouseSmooth,
  'personality_mouse_stopAndGo' => l10n.personalityMouseStopGo,
  'personality_mouse_unpredictable' => l10n.personalityMouseUnpredictable,
  'personality_moth_smooth' => l10n.personalityMothSmooth,
  'personality_moth_stopAndGo' => l10n.personalityMothStopGo,
  'personality_moth_unpredictable' => l10n.personalityMothUnpredictable,
  'personality_fish_smooth' => l10n.personalityFishSmooth,
  'personality_fish_stopAndGo' => l10n.personalityFishStopGo,
  'personality_fish_unpredictable' => l10n.personalityFishUnpredictable,
  _ => l10n.personalityFallback,
};
