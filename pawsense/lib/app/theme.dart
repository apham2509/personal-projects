import 'package:flutter/material.dart';

/// Owner-facing Material 3 theme: calm, friendly, with generous tap targets.
/// The cat-facing play screen does not use this theme (it renders its own
/// dark, low-stimulation canvas).
ThemeData buildTheme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF316B5D),
    brightness: brightness,
  );
  final base = ThemeData(useMaterial3: true, colorScheme: scheme);

  const minTapTarget = Size(64, 52);

  return base.copyWith(
    materialTapTargetSize: MaterialTapTargetSize.padded,
    visualDensity: VisualDensity.standard,
    appBarTheme: base.appBarTheme.copyWith(
      centerTitle: false,
      titleTextStyle: base.textTheme.titleLarge?.copyWith(
        color: scheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: base.cardTheme.copyWith(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: scheme.surfaceContainerLow,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(minimumSize: minTapTarget),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(minimumSize: minTapTarget),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(minimumSize: minTapTarget),
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: SegmentedButton.styleFrom(minimumSize: const Size(48, 44)),
    ),
    listTileTheme: base.listTileTheme.copyWith(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    snackBarTheme: base.snackBarTheme.copyWith(
      behavior: SnackBarBehavior.floating,
    ),
  );
}
