import 'package:flutter/material.dart';

import '../../../core/utils/l10n_ext.dart';

/// Owner-facing safety guidance, including honest platform-lock advice
/// (Guided Access / screen pinning) — PawSense never claims to lock the OS
/// itself.
class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    Widget item(IconData icon, String text) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsSafety)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(l10n.safetyIntro, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 12),
              item(Icons.visibility_outlined, l10n.safetySupervise),
              item(Icons.tablet_mac_outlined, l10n.safetyStand),
              item(Icons.shield_outlined, l10n.safetyProtector),
              item(Icons.timer_outlined, l10n.safetyShort),
              item(Icons.sentiment_satisfied_alt_outlined, l10n.safetyStop),
              item(Icons.toys_outlined, l10n.safetyPhysicalToy),
              item(Icons.restaurant_outlined, l10n.safetyTreats),
              item(Icons.medical_information_outlined, l10n.safetyNotVet),
              const Divider(height: 32),
              Text(l10n.safetyLockTitle, style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(l10n.safetyLockIntro),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.safetyGuidedAccessTitle,
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 6),
                      Text(l10n.safetyGuidedAccessBody),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.safetyPinningTitle,
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(height: 6),
                      Text(l10n.safetyPinningBody),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(l10n.safetyDesignNote, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
