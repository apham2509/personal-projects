import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../core/utils/enum_labels.dart';
import '../../../core/utils/l10n_ext.dart';
import '../../../shared/models/enums.dart';
import '../../../shared/providers/core_providers.dart';
import '../../../shared/widgets/cat_avatar.dart';

/// Per-cat hub: play, train, calibrate, insights, history, voice cues,
/// profile.
class CatHomeScreen extends ConsumerWidget {
  const CatHomeScreen({super.key, required this.catId});

  final String catId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final catAsync = ref.watch(catProfileProvider(catId));

    return Scaffold(
      appBar: AppBar(),
      body: catAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.errorGenericBody)),
        data: (cat) {
          if (cat == null) {
            // Profile was deleted while this screen was open.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) context.go('/profiles');
            });
            return const SizedBox.shrink();
          }
          return _CatHomeBody(cat: cat);
        },
      ),
    );
  }
}

class _CatHomeBody extends StatelessWidget {
  const _CatHomeBody({required this.cat});

  final CatProfile cat;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final needsCalibration =
        cat.calibrationState == CalibrationState.notStarted ||
        cat.calibrationState == CalibrationState.inProgress;

    final actions = <_HomeAction>[
      _HomeAction(
        icon: Icons.sports_esports_outlined,
        title: l10n.homePlay,
        subtitle: l10n.homePlaySubtitle,
        route: '/cats/${cat.id}/setup?mode=freePlay',
      ),
      _HomeAction(
        icon: Icons.record_voice_over_outlined,
        title: l10n.homeTrain,
        subtitle: l10n.homeTrainSubtitle,
        route: '/cats/${cat.id}/setup?mode=touchTraining',
      ),
      _HomeAction(
        icon: Icons.tune,
        title: l10n.homeCalibrate,
        subtitle: l10n.homeCalibrateSubtitle,
        route: '/cats/${cat.id}/setup?mode=calibration',
        highlighted: needsCalibration,
      ),
      _HomeAction(
        icon: Icons.insights_outlined,
        title: l10n.homeInsights,
        subtitle: l10n.homeInsightsSubtitle,
        route: '/cats/${cat.id}/insights',
      ),
      _HomeAction(
        icon: Icons.history,
        title: l10n.homeHistory,
        subtitle: l10n.homeHistorySubtitle,
        route: '/cats/${cat.id}/history',
      ),
      _HomeAction(
        icon: Icons.mic_none,
        title: l10n.homeVoiceCues,
        subtitle: l10n.homeVoiceCuesSubtitle,
        route: '/cats/${cat.id}/voice',
      ),
      _HomeAction(
        icon: Icons.badge_outlined,
        title: l10n.homeEditProfile,
        subtitle: l10n.homeEditProfileSubtitle,
        route: '/cats/${cat.id}/edit',
      ),
    ];

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 840),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Row(
                children: [
                  CatAvatar(name: cat.name, photoPath: cat.photoPath),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cat.name, style: theme.textTheme.headlineMedium),
                        const SizedBox(height: 6),
                        Chip(
                          avatar: Icon(
                            cat.calibrationState == CalibrationState.completed
                                ? Icons.check_circle_outline
                                : Icons.pending_outlined,
                            size: 18,
                          ),
                          label: Text(cat.calibrationState.label(l10n)),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              GridView.extent(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                maxCrossAxisExtent: 280,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.9,
                children: [
                  for (final action in actions) _ActionCard(action: action),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeAction {
  const _HomeAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    this.highlighted = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final bool highlighted;
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.action});

  final _HomeAction action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: action.highlighted
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surfaceContainerLow,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.push(action.route),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(action.icon, size: 32, color: theme.colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(action.title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      action.subtitle,
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
