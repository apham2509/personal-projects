import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../core/utils/l10n_ext.dart';
import '../../../shared/providers/core_providers.dart';
import '../../../shared/widgets/cat_avatar.dart';

/// "Who's playing?" — the entry hub. Circular cards per cat, an add-cat
/// card, and a Mixed Session entry for multi-cat play.
class ProfilePickerScreen extends ConsumerWidget {
  const ProfilePickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final profiles = ref.watch(activeProfilesProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: l10n.pickerManageProfiles,
            onPressed: () => context.push('/profiles/manage'),
            icon: const Icon(Icons.tune),
          ),
          IconButton(
            tooltip: l10n.settingsTitle,
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: profiles.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorBody(message: l10n.errorGenericBody),
        data: (cats) => SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      l10n.pickerTitle,
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    if (cats.isEmpty)
                      _EmptyState(onAdd: () => context.push('/profiles/new'))
                    else
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final minimumWidth =
                              MediaQuery.textScalerOf(context).scale(16) > 24
                              ? 240.0
                              : 150.0;
                          final columns = (constraints.maxWidth / minimumWidth)
                              .floor()
                              .clamp(1, 4);
                          final width =
                              (constraints.maxWidth - 16 * (columns - 1)) /
                              columns;
                          return Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            alignment: WrapAlignment.center,
                            children: [
                              for (final cat in cats)
                                SizedBox(
                                  width: width,
                                  child: _ProfileCard(
                                    cat: cat,
                                    onTap: () =>
                                        context.push('/cats/${cat.id}'),
                                  ),
                                ),
                              SizedBox(
                                width: width,
                                child: _AddCard(
                                  onTap: () => context.push('/profiles/new'),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    const SizedBox(height: 24),
                    _MixedSessionCard(onTap: () => context.push('/mixed')),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.cat, required this.onTap});

  final CatProfile cat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: cat.name,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CatAvatar(name: cat.name, photoPath: cat.photoPath),
              const SizedBox(height: 12),
              Text(
                cat.name,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddCard extends StatelessWidget {
  const _AddCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      label: context.l10n.pickerAddCat,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                child: Icon(
                  Icons.add,
                  size: 40,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                context.l10n.pickerAddCat,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MixedSessionCard extends StatelessWidget {
  const _MixedSessionCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: const Icon(Icons.groups_2_outlined, size: 32),
        title: Text(l10n.pickerMixedSession),
        subtitle: Text(l10n.pickerMixedSessionSubtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pets, size: 64, color: theme.colorScheme.outline),
          const SizedBox(height: 16),
          Text(l10n.pickerEmptyTitle, style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(l10n.pickerEmptyBody, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: Text(l10n.pickerAddCat),
          ),
        ],
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}
