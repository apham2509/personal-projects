import 'package:flutter/material.dart';

import '../../core/utils/l10n_ext.dart';

/// Standard destructive-action confirmation. Returns true when confirmed.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmLabel,
  bool destructive = true,
}) async {
  final theme = Theme.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(context.l10n.actionCancel),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                )
              : null,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
