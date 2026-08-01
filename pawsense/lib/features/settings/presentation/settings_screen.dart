import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_config.dart';
import '../../../core/database/app_database.dart';
import '../../../core/utils/enum_labels.dart';
import '../../../core/utils/l10n_ext.dart';
import '../../../shared/models/enums.dart';
import '../../../shared/providers/core_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.errorGenericBody)),
        data: (settings) => _SettingsBody(settings: settings),
      ),
    );
  }
}

class _SettingsBody extends ConsumerWidget {
  const _SettingsBody({required this.settings});

  final AppSetting settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final repo = ref.read(settingsRepositoryProvider);
    final theme = Theme.of(context);

    Widget section(String title) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          children: [
            section(l10n.settingsSessionSection),
            ListTile(
              title: Text(l10n.settingsDefaultDuration),
              trailing: DropdownButton<int>(
                value: settings.defaultSessionDurationSeconds,
                onChanged: (seconds) {
                  if (seconds != null) repo.setDefaultSessionDuration(seconds);
                },
                items: [
                  for (final seconds in const [60, 120, 180, 300])
                    DropdownMenuItem(
                      value: seconds,
                      child: Text(l10n.durationMinutes(seconds ~/ 60)),
                    ),
                ],
              ),
            ),
            SwitchListTile(
              title: Text(l10n.settingsSound),
              subtitle: Text(l10n.settingsSoundSubtitle),
              value: settings.soundEnabled,
              onChanged: repo.setSoundEnabled,
            ),
            section(l10n.settingsRewardSection),
            RadioGroup<RewardSchedule>(
              groupValue: settings.rewardSchedule,
              onChanged: (value) {
                if (value != null) repo.setRewardSchedule(value);
              },
              child: Column(
                children: [
                  for (final schedule in RewardSchedule.values)
                    RadioListTile<RewardSchedule>(
                      title: Text(schedule.label(l10n)),
                      value: schedule,
                    ),
                ],
              ),
            ),
            ListTile(
              title: Text(l10n.settingsMaxReminders),
              trailing: DropdownButton<int>(
                value: settings.maxRewardReminders,
                onChanged: (count) {
                  if (count != null) repo.setMaxRewardReminders(count);
                },
                items: [
                  for (final count in const [1, 2, 3, 4, 5])
                    DropdownMenuItem(value: count, child: Text('$count')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.settingsRewardDisclaimer,
                style: theme.textTheme.bodySmall,
              ),
            ),
            section(l10n.settingsPinSection),
            ListTile(
              title: Text(
                settings.ownerPinHash != null
                    ? l10n.settingsPinSet
                    : l10n.settingsPinNotSet,
              ),
              subtitle: Text(l10n.pinDialogBody),
              trailing: Wrap(
                spacing: 4,
                children: [
                  TextButton(
                    onPressed: () => _showPinDialog(context, ref),
                    child: Text(
                      settings.ownerPinHash != null
                          ? l10n.settingsChangePin
                          : l10n.settingsSetPin,
                    ),
                  ),
                  if (settings.ownerPinHash != null)
                    TextButton(
                      onPressed: repo.clearOwnerPin,
                      child: Text(l10n.settingsRemovePin),
                    ),
                ],
              ),
            ),
            section(l10n.settingsAccessibilitySection),
            SwitchListTile(
              title: Text(l10n.settingsReduceMotion),
              subtitle: Text(l10n.settingsReduceMotionSubtitle),
              value: settings.reduceMotion,
              onChanged: repo.setReduceMotion,
            ),
            SwitchListTile(
              title: Text(l10n.settingsHighContrast),
              subtitle: Text(l10n.settingsHighContrastSubtitle),
              value: settings.highContrastMode,
              onChanged: repo.setHighContrastMode,
            ),
            section(l10n.settingsMoreSection),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: Text(l10n.settingsPrivacy),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/settings/privacy'),
            ),
            ListTile(
              leading: const Icon(Icons.shield_outlined),
              title: Text(l10n.settingsSafety),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/settings/safety'),
            ),
            ListTile(
              leading: const Icon(Icons.storage_outlined),
              title: Text(l10n.settingsData),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/settings/data'),
            ),
            if (kDebugMode)
              ListTile(
                leading: const Icon(Icons.developer_mode),
                title: Text(l10n.settingsDeveloper),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/dev'),
              ),
            section(l10n.settingsAboutSection),
            ListTile(
              title: Text(l10n.settingsVersion(appVersion)),
              subtitle: Text(l10n.settingsLocalFirstNote),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _showPinDialog(BuildContext context, WidgetRef ref) async {
    final pin = await showDialog<String>(
      context: context,
      builder: (context) => const _PinDialog(),
    );
    if (pin != null) {
      await ref.read(settingsRepositoryProvider).setOwnerPin(pin);
    }
  }
}

/// Owns its text controller so disposal happens with the route, not before
/// the exit animation finishes.
class _PinDialog extends StatefulWidget {
  const _PinDialog();

  @override
  State<_PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<_PinDialog> {
  final _controller = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _controller.text;
    if (value.length != 4 || int.tryParse(value) == null) {
      setState(() => _errorText = context.l10n.pinDialogError);
      return;
    }
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.pinDialogTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.pinDialogBody),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              errorText: _errorText,
              counterText: '',
            ),
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.actionCancel),
        ),
        FilledButton(onPressed: _submit, child: Text(l10n.actionSave)),
      ],
    );
  }
}
