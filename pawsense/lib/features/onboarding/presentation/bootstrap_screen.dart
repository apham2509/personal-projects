import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/l10n_ext.dart';
import '../../../shared/providers/core_providers.dart';

/// First route. Waits for the settings row (which also proves the database
/// opened), then forwards to the intro flow or the profile picker.
class BootstrapScreen extends ConsumerStatefulWidget {
  const BootstrapScreen({super.key});

  @override
  ConsumerState<BootstrapScreen> createState() => _BootstrapScreenState();
}

class _BootstrapScreenState extends ConsumerState<BootstrapScreen> {
  bool _navigated = false;
  bool _recoveryStarted = false;

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    if (!_recoveryStarted) {
      _recoveryStarted = true;
      // Crash recovery: finalise any session left inProgress by a previous
      // run before the owner can reach history/insights.
      ref.read(sessionRepositoryProvider).recoverInterruptedSessions().ignore();
    }

    final value = settings.value;
    if (value != null && !_navigated) {
      _navigated = true;
      final target = value.onboardingComplete ? '/profiles' : '/intro';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go(target);
      });
    }

    return Scaffold(
      body: Center(
        child: settings.hasError
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.errorGenericTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(context.l10n.errorGenericBody),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.appTitle,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 24),
                  const CircularProgressIndicator(),
                ],
              ),
      ),
    );
  }
}
