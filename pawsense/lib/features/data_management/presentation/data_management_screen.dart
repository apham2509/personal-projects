import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/export/export_service.dart';
import '../../../core/utils/l10n_ext.dart';
import '../../../shared/providers/core_providers.dart';
import '../../../shared/widgets/confirm_dialog.dart';

final exportServiceProvider = Provider<ExportService>(
  (ref) => ExportService(
    ref.watch(databaseProvider),
    ref.watch(fileServiceProvider),
    ref.watch(clockProvider),
  ),
);

/// Seam over the platform share sheet so widget tests can fake it.
final shareFilesProvider = Provider<Future<void> Function(List<XFile>)>(
  (ref) => (files) async {
    await SharePlus.instance.share(ShareParams(files: files));
  },
);

/// Export (JSON/CSV via the share sheet) and destructive deletion, each
/// with copy that states exactly what leaves or is removed.
class DataManagementScreen extends ConsumerStatefulWidget {
  const DataManagementScreen({super.key});

  @override
  ConsumerState<DataManagementScreen> createState() => _DataState();
}

class _DataState extends ConsumerState<DataManagementScreen> {
  String? _selectedCatId; // null = all cats
  bool _busy = false;

  Future<void> _export({required bool asCsv}) async {
    if (_busy) return;
    setState(() => _busy = true);
    final service = ref.read(exportServiceProvider);
    final files = ref.read(fileServiceProvider);
    final share = ref.read(shareFilesProvider);
    try {
      final exported = asCsv
          ? await service.writeCsvFiles(catId: _selectedCatId)
          : [await service.writeJsonFile(catId: _selectedCatId)];
      await share([for (final file in exported) XFile(file.path)]);
    } finally {
      await files.clearExportDir();
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final cats = ref.watch(activeProfilesProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsData)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(l10n.dataExportSection, style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(l10n.dataExportBody, style: theme.textTheme.bodySmall),
              const SizedBox(height: 12),
              DropdownButtonFormField<String?>(
                initialValue: _selectedCatId,
                decoration: InputDecoration(
                  labelText: l10n.dataExportScope,
                  border: const OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(l10n.dataExportAll),
                  ),
                  for (final cat in cats)
                    DropdownMenuItem(value: cat.id, child: Text(cat.name)),
                ],
                onChanged: (value) => setState(() => _selectedCatId = value),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _busy ? null : () => _export(asCsv: false),
                      icon: const Icon(Icons.data_object),
                      label: Text(l10n.dataExportJson),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: _busy ? null : () => _export(asCsv: true),
                      icon: const Icon(Icons.table_chart_outlined),
                      label: Text(l10n.dataExportCsv),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(l10n.dataExportMediaNote, style: theme.textTheme.bodySmall),
              const Divider(height: 40),
              Text(
                l10n.dataDeleteSection,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(height: 8),
              for (final cat in cats)
                ListTile(
                  leading: const Icon(Icons.history_toggle_off),
                  title: Text(l10n.dataDeleteHistoryFor(cat.name)),
                  subtitle: Text(l10n.dataDeleteHistoryBody),
                  onTap: () async {
                    final confirmed = await showConfirmDialog(
                      context,
                      title: l10n.dataDeleteHistoryFor(cat.name),
                      body: l10n.dataDeleteHistoryConfirm(cat.name),
                      confirmLabel: l10n.actionDelete,
                    );
                    if (confirmed) {
                      await ref
                          .read(sessionRepositoryProvider)
                          .deleteHistoryForCat(cat.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.dataDeleted)),
                        );
                      }
                    }
                  },
                ),
              ListTile(
                leading: Icon(
                  Icons.delete_forever,
                  color: theme.colorScheme.error,
                ),
                title: Text(l10n.dataDeleteAll),
                subtitle: Text(l10n.dataDeleteAllBody),
                onTap: () async {
                  final confirmed = await showConfirmDialog(
                    context,
                    title: l10n.dataDeleteAll,
                    body: l10n.dataDeleteAllConfirm,
                    confirmLabel: l10n.manageDeleteConfirmAction,
                  );
                  if (confirmed) {
                    await ref.read(exportServiceProvider).deleteAllData();
                    if (context.mounted) context.go('/');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
