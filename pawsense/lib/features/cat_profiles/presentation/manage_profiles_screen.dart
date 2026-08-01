import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/utils/l10n_ext.dart';
import '../../../shared/providers/core_providers.dart';
import '../../../shared/widgets/cat_avatar.dart';
import '../../../shared/widgets/confirm_dialog.dart';

/// Reorder (drag), archive/restore, and permanently delete profiles.
class ManageProfilesScreen extends ConsumerWidget {
  const ManageProfilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final active = ref.watch(activeProfilesProvider);
    final archived = ref.watch(archivedProfilesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.manageTitle)),
      body: active.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.errorGenericBody)),
        data: (activeCats) {
          final archivedCats = archived.value ?? const <CatProfile>[];
          if (activeCats.isEmpty && archivedCats.isEmpty) {
            return Center(child: Text(l10n.manageEmptyBody));
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        l10n.manageReorderHint,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(8),
                    sliver: SliverReorderableList(
                      itemCount: activeCats.length,
                      onReorderItem: (oldIndex, newIndex) {
                        final ids = activeCats
                            .map((c) => c.id)
                            .toList(growable: true);
                        final id = ids.removeAt(oldIndex);
                        ids.insert(newIndex, id);
                        ref.read(catProfileRepositoryProvider).reorder(ids);
                      },
                      itemBuilder: (context, index) {
                        final cat = activeCats[index];
                        return _ProfileTile(
                          key: ValueKey(cat.id),
                          cat: cat,
                          index: index,
                          archived: false,
                        );
                      },
                    ),
                  ),
                  if (archivedCats.isNotEmpty) ...[
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 4),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          l10n.manageArchivedSection,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(8),
                      sliver: SliverList.builder(
                        itemCount: archivedCats.length,
                        itemBuilder: (context, index) => _ProfileTile(
                          cat: archivedCats[index],
                          index: index,
                          archived: true,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProfileTile extends ConsumerWidget {
  const _ProfileTile({
    super.key,
    required this.cat,
    required this.index,
    required this.archived,
  });

  final CatProfile cat;
  final int index;
  final bool archived;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final repo = ref.read(catProfileRepositoryProvider);

    Future<void> confirmArchive() async {
      final ok = await showConfirmDialog(
        context,
        title: l10n.manageArchiveConfirmTitle(cat.name),
        body: l10n.manageArchiveConfirmBody(cat.name),
        confirmLabel: l10n.actionArchive,
        destructive: false,
      );
      if (ok) await repo.archive(cat.id);
    }

    Future<void> confirmDelete() async {
      final ok = await showConfirmDialog(
        context,
        title: l10n.manageDeleteConfirmTitle(cat.name),
        body: l10n.manageDeleteConfirmBody(cat.name),
        confirmLabel: l10n.manageDeleteConfirmAction,
      );
      if (ok) await repo.deletePermanently(cat.id);
    }

    final tile = Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CatAvatar(
          name: cat.name,
          photoPath: cat.photoPath,
          radius: 24,
        ),
        title: Text(cat.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (archived)
              TextButton(
                onPressed: () => repo.restore(cat.id),
                child: Text(l10n.actionRestore),
              )
            else
              IconButton(
                tooltip: l10n.actionArchive,
                onPressed: confirmArchive,
                icon: const Icon(Icons.archive_outlined),
              ),
            IconButton(
              tooltip: l10n.actionDelete,
              onPressed: confirmDelete,
              icon: Icon(
                Icons.delete_outline,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            if (!archived)
              ReorderableDragStartListener(
                index: index,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.drag_handle),
                ),
              ),
          ],
        ),
      ),
    );
    return tile;
  }
}
