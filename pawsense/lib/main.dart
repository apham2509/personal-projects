import 'package:flutter/material.dart';

import 'l10n/generated/app_localizations.dart';

void main() {
  runApp(const PawSenseApp());
}

/// Temporary app shell for the scaffold commit; replaced by the full
/// router-driven application in the profile-system phase.
class PawSenseApp extends StatelessWidget {
  const PawSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context);
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.appTitle,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.appTagline,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
