import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/database/app_database.dart';
import '../../../core/utils/l10n_ext.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/models/enums.dart';
import '../../../shared/providers/core_providers.dart';
import '../../../shared/widgets/confirm_dialog.dart';

/// Recent sessions for one cat: open details, or delete individual
/// sessions.
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key, required this.catId});

  final String catId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final sessionsAsync = ref.watch(sessionsForCatProvider(catId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.historyTitle)),
      body: sessionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.errorGenericBody)),
        data: (sessions) {
          if (sessions.isEmpty) {
            return Center(child: Text(l10n.historyEmpty));
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: sessions.length,
                itemBuilder: (context, index) =>
                    _SessionTile(session: sessions[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SessionTile extends ConsumerWidget {
  const _SessionTile({required this.session});

  final Session session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final started = session.startedAtUtc.toLocal();
    final dateLabel = DateFormat.yMMMd(
      Localizations.localeOf(context).toString(),
    ).add_Hm().format(started);

    final modeLabel = switch (session.mode) {
      SessionMode.freePlay => l10n.setupTitlePlay,
      SessionMode.touchTraining => l10n.setupTitleTrain,
      SessionMode.calibration => l10n.setupTitleCalibration,
      SessionMode.mixed => l10n.mixedTitle,
    };
    final modeIcon = switch (session.mode) {
      SessionMode.freePlay => Icons.sports_esports_outlined,
      SessionMode.touchTraining => Icons.record_voice_over_outlined,
      SessionMode.calibration => Icons.tune,
      SessionMode.mixed => Icons.groups_2_outlined,
    };

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(modeIcon),
        title: Text('$modeLabel - $dateLabel'),
        subtitle: Text(
          '${_statusLabel(l10n, session.status)}\n'
          '${l10n.historyStats(session.catches, session.misses, session.timeouts)}',
        ),
        isThreeLine: true,
        trailing: IconButton(
          tooltip: l10n.actionDelete,
          icon: Icon(
            Icons.delete_outline,
            color: Theme.of(context).colorScheme.error,
          ),
          onPressed: () async {
            final confirmed = await showConfirmDialog(
              context,
              title: l10n.historyDeleteTitle,
              body: l10n.historyDeleteBody,
              confirmLabel: l10n.actionDelete,
            );
            if (confirmed) {
              await ref
                  .read(sessionRepositoryProvider)
                  .deleteSession(session.id);
            }
          },
        ),
        onTap: () => context.push('/results/${session.id}'),
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
