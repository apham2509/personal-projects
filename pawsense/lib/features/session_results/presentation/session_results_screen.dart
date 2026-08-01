import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../core/utils/l10n_ext.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../shared/models/enums.dart';
import '../../../shared/providers/core_providers.dart';

/// Owner-facing summary after any session, with the optional subjective
/// note (stored separately from observed touch data).
class SessionResultsScreen extends ConsumerStatefulWidget {
  const SessionResultsScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  ConsumerState<SessionResultsScreen> createState() => _ResultsState();
}

class _ResultsState extends ConsumerState<SessionResultsScreen> {
  Session? _session;
  OwnerFeedback? _feedback;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final session = await ref
        .read(sessionRepositoryProvider)
        .getSession(widget.sessionId);
    if (mounted) {
      setState(() {
        _session = session;
        _feedback = session?.ownerSubjectiveFeedback;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final session = _session;
    if (session == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final trialsTotal = session.catches + session.timeouts;
    final catchRate = trialsTotal == 0
        ? null
        : (session.catches / trialsTotal * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.resultsTitle),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _statusLabel(l10n, session.status),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.resultsDuration(
                          ((session.actualDurationMs ?? 0) / 1000 / 60)
                              .toStringAsFixed(1),
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _StatTile(
                    label: l10n.resultsCatches,
                    value: '${session.catches}',
                  ),
                  _StatTile(
                    label: l10n.resultsCatchRate,
                    value: catchRate == null ? '-' : '$catchRate%',
                  ),
                  _StatTile(
                    label: l10n.resultsMedianReaction,
                    value: session.medianReactionMs == null
                        ? '-'
                        : l10n.resultsSeconds(
                            (session.medianReactionMs! / 1000).toStringAsFixed(
                              1,
                            ),
                          ),
                  ),
                  _StatTile(
                    label: l10n.resultsMisses,
                    value: '${session.misses}',
                  ),
                  _StatTile(
                    label: l10n.resultsTimeouts,
                    value: '${session.timeouts}',
                  ),
                ],
              ),
              if (session.frustrationCount > 0) ...[
                const SizedBox(height: 12),
                Card(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(l10n.resultsFrustrationNote),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Text(
                l10n.resultsFeedbackPrompt,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.resultsFeedbackBody,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              SegmentedButton<OwnerFeedback>(
                emptySelectionAllowed: true,
                segments: [
                  ButtonSegment(
                    value: OwnerFeedback.engaged,
                    label: Text(l10n.feedbackEngaged),
                  ),
                  ButtonSegment(
                    value: OwnerFeedback.neutral,
                    label: Text(l10n.feedbackNeutral),
                  ),
                  ButtonSegment(
                    value: OwnerFeedback.frustrated,
                    label: Text(l10n.feedbackFrustrated),
                  ),
                ],
                selected: {?_feedback},
                onSelectionChanged: (selection) async {
                  final choice = selection.isEmpty ? null : selection.first;
                  setState(() => _feedback = choice);
                  await ref
                      .read(sessionRepositoryProvider)
                      .setOwnerFeedback(widget.sessionId, choice);
                },
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () {
                  final catId = session.catId;
                  context.go(catId == null ? '/profiles' : '/cats/$catId');
                },
                child: Text(l10n.actionDone),
              ),
            ],
          ),
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

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: theme.textTheme.headlineSmall),
            Text(label, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
