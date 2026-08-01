import 'package:flutter/material.dart';

import '../../../core/utils/l10n_ext.dart';

/// In-app privacy explanation mirroring docs/PRIVACY.md, in plain language.
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    Widget section(String title, String body) => Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(body),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsPrivacy)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                color: theme.colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    l10n.privacyHeadline,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              section(l10n.privacyStoredTitle, l10n.privacyStoredBody),
              section(l10n.privacyWhereTitle, l10n.privacyWhereBody),
              section(
                l10n.privacyPermissionsTitle,
                l10n.privacyPermissionsBody,
              ),
              section(l10n.privacyControlTitle, l10n.privacyControlBody),
              section(l10n.privacyFutureTitle, l10n.privacyFutureBody),
            ],
          ),
        ),
      ),
    );
  }
}
