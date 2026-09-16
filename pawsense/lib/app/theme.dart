import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';

/// Warm paper, sage and forest ink for the owner-facing interface. The
/// cat-facing game has its own quiet, dark palette.
ThemeData buildTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final scheme =
      ColorScheme.fromSeed(
        seedColor: const Color(0xFF356653),
        brightness: brightness,
      ).copyWith(
        primary: dark ? const Color(0xFFABD1BB) : const Color(0xFF315D49),
        onPrimary: dark ? const Color(0xFF123526) : const Color(0xFFFFFFFF),
        primaryContainer: dark
            ? const Color(0xFF2B4B3B)
            : const Color(0xFFE0EBDD),
        onPrimaryContainer: dark
            ? const Color(0xFFDBEFD8)
            : const Color(0xFF213F30),
        secondary: dark ? const Color(0xFFDCC5AF) : const Color(0xFF765846),
        onSecondary: dark ? const Color(0xFF412B1C) : const Color(0xFFFFFFFF),
        secondaryContainer: dark
            ? const Color(0xFF4F3D31)
            : const Color(0xFFF3E0CF),
        onSecondaryContainer: dark
            ? const Color(0xFFFFE8D4)
            : const Color(0xFF503B2D),
        tertiary: dark ? const Color(0xFFEAB7A0) : const Color(0xFF8D503B),
        onTertiary: dark ? const Color(0xFF542916) : const Color(0xFFFFFFFF),
        tertiaryContainer: dark
            ? const Color(0xFF593B2E)
            : const Color(0xFFF6DED0),
        onTertiaryContainer: dark
            ? const Color(0xFFFFDBC7)
            : const Color(0xFF643B28),
        surface: dark ? const Color(0xFF171D19) : const Color(0xFFFAF8F2),
        onSurface: dark ? const Color(0xFFE8EAE1) : const Color(0xFF243B30),
        onSurfaceVariant: dark
            ? const Color(0xFFBEC7BC)
            : const Color(0xFF5A675B),
        surfaceContainerLowest: dark ? const Color(0xFF121713) : Colors.white,
        surfaceContainerLow: dark
            ? const Color(0xFF202820)
            : const Color(0xFFF1F2E9),
        surfaceContainer: dark
            ? const Color(0xFF252E26)
            : const Color(0xFFECEEE3),
        surfaceContainerHigh: dark
            ? const Color(0xFF2D362E)
            : const Color(0xFFE6EADD),
        surfaceContainerHighest: dark
            ? const Color(0xFF364038)
            : const Color(0xFFDFE5D7),
        outline: dark ? const Color(0xFF899688) : const Color(0xFF7A8877),
        outlineVariant: dark
            ? const Color(0xFF465345)
            : const Color(0xFFD4DCCB),
      );
  final base = ThemeData(useMaterial3: true, colorScheme: scheme);
  final text = base.textTheme.copyWith(
    headlineLarge: base.textTheme.headlineLarge?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -1.1,
      height: 1.15,
    ),
    headlineMedium: base.textTheme.headlineMedium?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: -0.7,
      height: 1.2,
    ),
    headlineSmall: base.textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: -0.4,
    ),
    titleLarge: base.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w600,
    ),
    titleMedium: base.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: base.textTheme.bodyLarge?.copyWith(height: 1.5),
    bodyMedium: base.textTheme.bodyMedium?.copyWith(height: 1.45),
    bodySmall: base.textTheme.bodySmall?.copyWith(height: 1.4),
  );
  const minTapTarget = Size(64, 54);
  final buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
  );

  return base.copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: _OwnerPageTransitionsBuilder(
          FadeForwardsPageTransitionsBuilder(),
        ),
        TargetPlatform.iOS: _OwnerPageTransitionsBuilder(
          CupertinoPageTransitionsBuilder(),
        ),
        TargetPlatform.macOS: _OwnerPageTransitionsBuilder(
          CupertinoPageTransitionsBuilder(),
        ),
        TargetPlatform.windows: _OwnerPageTransitionsBuilder(
          FadeUpwardsPageTransitionsBuilder(),
        ),
        TargetPlatform.linux: _OwnerPageTransitionsBuilder(
          FadeUpwardsPageTransitionsBuilder(),
        ),
      },
    ),
    scaffoldBackgroundColor: scheme.surface,
    textTheme: text,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    visualDensity: VisualDensity.standard,
    appBarTheme: base.appBarTheme.copyWith(
      centerTitle: false,
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      titleTextStyle: text.titleLarge?.copyWith(color: scheme.onSurface),
    ),
    cardTheme: base.cardTheme.copyWith(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: scheme.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: minTapTarget,
        shape: buttonShape,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: minTapTarget,
        shape: buttonShape,
        side: BorderSide(color: scheme.outlineVariant),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: minTapTarget,
        shape: buttonShape,
      ),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(minimumSize: const Size(48, 48)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceContainerLowest,
      contentPadding: const EdgeInsets.all(18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: BorderSide(color: scheme.outlineVariant),
      selectedColor: scheme.primaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
    ),
    listTileTheme: base.listTileTheme.copyWith(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      iconColor: scheme.primary,
    ),
    dividerTheme: DividerThemeData(color: scheme.outlineVariant, thickness: 1),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: scheme.primary,
      linearTrackColor: scheme.primaryContainer,
      circularTrackColor: scheme.primaryContainer,
    ),
    snackBarTheme: base.snackBarTheme.copyWith(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}

/// Preserve native route gestures and transitions when motion is enabled.
/// App-level MediaQuery combines system and PawSense accessibility settings.
class _OwnerPageTransitionsBuilder extends PageTransitionsBuilder {
  const _OwnerPageTransitionsBuilder(this.delegate);

  final PageTransitionsBuilder delegate;

  @override
  Duration get transitionDuration => delegate.transitionDuration;

  @override
  Duration get reverseTransitionDuration => delegate.reverseTransitionDuration;

  @override
  DelegatedTransitionBuilder? get delegatedTransition {
    final transition = delegate.delegatedTransition;
    if (transition == null) return null;
    return (context, animation, secondaryAnimation, allowSnapshotting, child) {
      if (MediaQuery.disableAnimationsOf(context)) return child;
      return transition(
        context,
        animation,
        secondaryAnimation,
        allowSnapshotting,
        child,
      );
    };
  }

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return delegate.buildTransitions(
      route,
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }
}
