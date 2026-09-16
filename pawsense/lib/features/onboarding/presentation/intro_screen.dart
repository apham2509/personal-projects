import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/l10n_ext.dart';
import '../../../shared/widgets/owner_motion.dart';
import '../../../shared/widgets/pawsense_illustration.dart';

/// Three calm, scrollable introductions before the first-profile wizard.
class IntroScreen extends ConsumerStatefulWidget {
  const IntroScreen({super.key});

  @override
  ConsumerState<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends ConsumerState<IntroScreen> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final duration = ownerMotionDuration(context, ref);
    final pages = [
      _IntroPage(
        variant: PawSenseIllustrationVariant.welcome,
        title: l10n.introWelcomeTitle,
        body: l10n.introWelcomeBody,
        tagline: l10n.appTagline,
      ),
      _IntroPage(
        variant: PawSenseIllustrationVariant.privacy,
        title: l10n.introPrivacyTitle,
        body: l10n.introPrivacyBody,
      ),
      _IntroPage(
        variant: PawSenseIllustrationVariant.safety,
        title: l10n.introSafetyTitle,
        body: l10n.introSafetyBody,
      ),
    ];
    final isLast = _page == pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (page) => setState(() => _page = page),
                children: pages,
              ),
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ExcludeSemantics(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var i = 0; i < pages.length; i++)
                              AnimatedContainer(
                                duration: duration,
                                curve: Curves.easeOutCubic,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: i == _page ? 28 : 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: i == _page
                                      ? scheme.primary
                                      : scheme.outlineVariant,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            if (isLast) {
                              context.go('/profiles/new');
                            } else if (duration == Duration.zero) {
                              _controller.jumpToPage(_page + 1);
                            } else {
                              _controller.nextPage(
                                duration: duration,
                                curve: Curves.easeOutCubic,
                              );
                            }
                          },
                          child: Text(
                            isLast
                                ? l10n.introCreateFirstCat
                                : l10n.actionContinue,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroPage extends StatelessWidget {
  const _IntroPage({
    required this.variant,
    required this.title,
    required this.body,
    this.tagline,
  });

  final PawSenseIllustrationVariant variant;
  final String title;
  final String body;
  final String? tagline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: (constraints.maxHeight - 40).clamp(0, double.infinity),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: OwnerEntrance(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PawSenseIllustration(
                      size: constraints.maxHeight < 400 ? 140 : 220,
                      variant: variant,
                    ),
                    const SizedBox(height: 20),
                    Semantics(
                      header: true,
                      child: Text(
                        title,
                        style: theme.textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (tagline != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        tagline!,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 16),
                    Text(
                      body,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
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
