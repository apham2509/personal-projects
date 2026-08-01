import 'package:flutter/material.dart';

import '../../core/utils/l10n_ext.dart';

/// Temporary destination for routes whose feature phase has not landed yet.
/// Every use of this widget is removed before V1 completion.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.placeholderComingTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            l10n.placeholderComingBody,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
