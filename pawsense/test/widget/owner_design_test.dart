import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/app/theme.dart';
import 'package:pawsense/features/onboarding/presentation/intro_screen.dart';
import 'package:pawsense/l10n/generated/app_localizations.dart';
import 'package:pawsense/shared/widgets/cat_avatar.dart';
import 'package:pawsense/shared/widgets/owner_motion.dart';
import 'package:pawsense/shared/widgets/pawsense_illustration.dart';

Widget designHarness(
  Widget child, {
  bool appReduceMotion = false,
  bool systemReduceMotion = false,
  double textScale = 1,
  Brightness brightness = Brightness.light,
}) => ProviderScope(
  overrides: [reduceOwnerMotionProvider.overrideWithValue(appReduceMotion)],
  child: MaterialApp(
    theme: buildTheme(brightness),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        disableAnimations: systemReduceMotion,
        textScaler: TextScaler.linear(textScale),
      ),
      child: child!,
    ),
    home: child,
  ),
);

void main() {
  for (final size in [const Size(360, 640), const Size(640, 320)]) {
    testWidgets('intro scrolls without overflow at $size and 200% text', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        designHarness(const IntroScreen(), textScale: 2, appReduceMotion: true),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Continue'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Private by design'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      expect(find.text('Calm, short, and safe'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  for (final system in [false, true]) {
    testWidgets(
      'owner entrance skips motion for ${system ? 'OS' : 'app'} preference',
      (tester) async {
        await tester.pumpWidget(
          designHarness(
            const OwnerEntrance(child: Text('Ready')),
            appReduceMotion: !system,
            systemReduceMotion: system,
          ),
        );
        final opacity = tester.widget<Opacity>(
          find.descendant(
            of: find.byType(OwnerEntrance),
            matching: find.byType(Opacity),
          ),
        );
        expect(opacity.opacity, 1);
        expect(tester.hasRunningAnimations, isFalse);
      },
    );
  }

  testWidgets('owner entrance completes within 280ms and stays settled', (
    tester,
  ) async {
    await tester.pumpWidget(
      designHarness(const OwnerEntrance(child: Text('Ready'))),
    );
    final opacity = find.descendant(
      of: find.byType(OwnerEntrance),
      matching: find.byType(Opacity),
    );
    expect(tester.widget<Opacity>(opacity).opacity, 0);
    await tester.pump(const Duration(milliseconds: 280));
    expect(tester.widget<Opacity>(opacity).opacity, 1);
    await tester.pump(const Duration(milliseconds: 50));
    expect(tester.hasRunningAnimations, isFalse);
    expect(await tester.pumpAndSettle(), 1);
  });

  testWidgets('all monogram colours retain accessible contrast at large text', (
    tester,
  ) async {
    await tester.pumpWidget(
      designHarness(
        Scaffold(
          body: Wrap(
            children: [
              for (final name in ['A', 'B', 'C', 'D', 'E', 'F'])
                CatAvatar(name: name, photoPath: null),
            ],
          ),
        ),
        textScale: 2,
      ),
    );
    for (final avatar in tester.widgetList<CircleAvatar>(
      find.byType(CircleAvatar),
    )) {
      const ink = Color(0xFF2C4638);
      final contrast =
          (avatar.backgroundColor!.computeLuminance() + 0.05) /
          (ink.computeLuminance() + 0.05);
      expect(contrast, greaterThanOrEqualTo(4.5));
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('owner art renders in light and dark themes', (tester) async {
    final boundaryKey = GlobalKey();
    tester.view.physicalSize = const Size(800, 460);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      designHarness(
        RepaintBoundary(
          key: boundaryKey,
          child: Column(
            children: [
              for (final brightness in Brightness.values)
                Expanded(
                  child: Theme(
                    data: buildTheme(brightness),
                    child: Builder(
                      builder: (context) => ColoredBox(
                        color: Theme.of(context).colorScheme.surface,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for (final variant
                                in PawSenseIllustrationVariant.values)
                              PawSenseIllustration(variant: variant),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    // Optional local visual QA output; normal test runs create no files.
    const preview = String.fromEnvironment('PAWSENSE_ART_PREVIEW');
    if (preview.isNotEmpty) {
      final boundary =
          boundaryKey.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;
      await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: 2);
        final data = await image.toByteData(format: ui.ImageByteFormat.png);
        await File(preview).writeAsBytes(data!.buffer.asUint8List());
        image.dispose();
      });
    }
  });
}
