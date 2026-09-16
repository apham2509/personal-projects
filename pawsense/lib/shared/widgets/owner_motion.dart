import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/core_providers.dart';

/// The owner's in-app preference. Combine with the operating-system
/// preference using [reduceOwnerMotion] when animating owner-facing UI.
final reduceOwnerMotionProvider = Provider<bool>((ref) {
  return ref.watch(
    settingsProvider.select((s) => s.value?.reduceMotion ?? false),
  );
});

bool reduceOwnerMotion(BuildContext context, WidgetRef ref) =>
    MediaQuery.disableAnimationsOf(context) ||
    ref.watch(reduceOwnerMotionProvider);

/// Zero duration means callers should jump to their final state immediately.
Duration ownerMotionDuration(
  BuildContext context,
  WidgetRef ref, {
  Duration normal = const Duration(milliseconds: 280),
}) => reduceOwnerMotion(context, ref) ? Duration.zero : normal;

/// A single, gentle entrance for owner screens, never a repeating animation.
/// Both system Reduce Motion and the owner's PawSense preference skip it.
/// Keep a stable key to avoid replaying it when asynchronous data updates.
class OwnerEntrance extends ConsumerWidget {
  const OwnerEntrance({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reduced = reduceOwnerMotion(context, ref);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: reduced ? 1 : 0, end: 1),
      duration: reduced ? Duration.zero : const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      child: child,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, (1 - value) * 10),
          child: child,
        ),
      ),
    );
  }
}
