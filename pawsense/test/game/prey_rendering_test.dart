import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/core/random/seeded_random.dart';
import 'package:pawsense/core/utils/vec2.dart';
import 'package:pawsense/features/play/domain/movement/movement_strategy.dart';
import 'package:pawsense/features/play/domain/play_tuning.dart';
import 'package:pawsense/features/play/game/components/fish_component.dart';
import 'package:pawsense/features/play/game/components/moth_component.dart';
import 'package:pawsense/features/play/game/components/mouse_component.dart';
import 'package:pawsense/features/play/game/components/prey_component.dart';

/// Check rendered pixels, including curved tails, strokes, animation and
/// rotation. A rectangular path bound cannot establish an honest circular
/// catch target: the original mouse's trailing tail fell outside it.
void main() {
  for (final kind in _PreyKind.values) {
    for (final highContrast in [false, true]) {
      testWidgets('$kind ($highContrast) anatomy fits the unchanged catch '
          'radius through a full animation', (tester) async {
        await tester.runAsync(() async {
          final prey = _makePrey(kind, highContrast: highContrast);
          prey.update(prey.spawnInSeconds);
          const cell = 160;
          const columns = 8;
          const samples = 48;
          const rows = samples ~/ columns;
          final recorder = PictureRecorder();
          final canvas = Canvas(recorder);
          for (var sample = 0; sample < samples; sample++) {
            // Advancing by unequal intervals samples independent gait, tail,
            // wing and swim phases without locking to an animation period.
            for (var frame = 0; frame < 7 + sample % 5; frame++) {
              prey.update(1 / 60);
            }
            canvas.save();
            canvas.translate(
              (sample % columns + 0.5) * cell,
              (sample ~/ columns + 0.5) * cell,
            );
            canvas.rotate(sample * math.pi / 7 + prey.headingForRender());
            // 1.35 is the largest scale in any lifecycle state (capture).
            // The separate post-capture ripple is feedback, not anatomy.
            canvas.scale(1.35);
            prey.renderPrey(canvas, prey.diameterPx / 2 * 0.86, 1);
            canvas.restore();
          }
          final pixels = await _raster(recorder, columns * cell, rows * cell);
          var paintedPixels = 0;
          var furthest = 0.0;
          for (var y = 0; y < rows * cell; y++) {
            for (var x = 0; x < columns * cell; x++) {
              final alpha = pixels[(y * columns * cell + x) * 4 + 3];
              if (alpha == 0) continue;
              paintedPixels++;
              final dx = x % cell + 0.5 - cell / 2;
              final dy = y % cell + 0.5 - cell / 2;
              furthest = math.max(furthest, math.sqrt(dx * dx + dy * dy));
            }
          }
          expect(
            paintedPixels,
            greaterThan(samples * 500),
            reason: 'each frame must contain visible anatomy',
          );
          expect(
            furthest,
            lessThanOrEqualTo(prey.hitboxRadiusPx),
            reason:
                'even the largest animation must stay catchable; '
                'painted radius $furthest, catch radius ${prey.hitboxRadiusPx}',
          );
        });
      });
    }

    testWidgets('$kind reproduces art with the stored seed and varies '
        'animation between seeds', (tester) async {
      await tester.runAsync(() async {
        final first = _makePrey(kind, seed: 21);
        final replay = _makePrey(kind, seed: 21);
        final different = _makePrey(kind, seed: 84);
        for (var i = 0; i < 103; i++) {
          first.update(1 / 60);
          replay.update(1 / 60);
          different.update(1 / 60);
        }
        final firstPixels = await _renderSingle(first);
        expect(await _renderSingle(replay), orderedEquals(firstPixels));
        expect(
          await _renderSingle(different),
          isNot(orderedEquals(firstPixels)),
          reason: 'the seeded offset must affect the idle/gait artwork',
        );
      });
    });
  }

  testWidgets('mouse body and feet stop scurrying when the path pauses', (
    tester,
  ) async {
    await tester.runAsync(() async {
      final strategy = _ControllableMovement();
      final mouse = _makePrey(_PreyKind.mouse, strategy: strategy);
      mouse.update(mouse.spawnInSeconds);
      mouse.update(1 / 60);
      expect(mouse.movementAmount, greaterThan(0));
      final movingPhase = mouse.gaitPhase;
      mouse.update(1 / 60);
      expect(mouse.gaitPhase, greaterThan(movingPhase));

      strategy.isMoving = false;
      mouse.update(1 / 60);
      final restingPhase = mouse.gaitPhase;
      final before = await _renderSingle(mouse);
      for (var i = 0; i < 37; i++) {
        mouse.update(1 / 60);
      }
      final after = await _renderSingle(mouse);
      expect(mouse.movementAmount, 0);
      expect(mouse.gaitPhase, restingPhase);
      // The body (local x > -0.4 radii) excludes the idle tail curl. Compare
      // real pixels so a time-driven squash or foot animation regresses.
      for (var y = 0; y < 160; y++) {
        for (var x = 64; x < 160; x++) {
          final offset = (y * 160 + x) * 4;
          expect(
            after.sublist(offset, offset + 4),
            orderedEquals(before.sublist(offset, offset + 4)),
            reason: 'resting mouse body changed at ($x, $y)',
          );
        }
      }
      expect(
        after,
        isNot(orderedEquals(before)),
        reason: 'a small, seeded idle tail breath remains',
      );
    });
  });
}

enum _PreyKind { mouse, moth, fish }

PreyComponent _makePrey(
  _PreyKind kind, {
  int seed = 42,
  bool highContrast = false,
  _ControllableMovement? strategy,
}) {
  final movement = strategy ?? _ControllableMovement();
  final rng = SeededRandom(seed);
  return switch (kind) {
    _PreyKind.mouse => MouseComponent(
      tuning: defaultPlayTuning,
      strategy: movement,
      unitPx: 600,
      diameterPx: 96,
      animationRng: rng,
      palette: highContrast
          ? MouseComponent.highContrastPalette
          : MouseComponent.regularPalette,
    ),
    _PreyKind.moth => MothComponent(
      tuning: defaultPlayTuning,
      strategy: movement,
      unitPx: 600,
      diameterPx: 96,
      animationRng: rng,
      palette: highContrast
          ? MothComponent.highContrastPalette
          : MothComponent.regularPalette,
    ),
    _PreyKind.fish => FishComponent(
      tuning: defaultPlayTuning,
      strategy: movement,
      unitPx: 600,
      diameterPx: 96,
      animationRng: rng,
      palette: highContrast
          ? FishComponent.highContrastPalette
          : FishComponent.regularPalette,
    ),
  };
}

class _ControllableMovement extends MovementStrategy {
  _ControllableMovement()
    : super(
        rng: SeededRandom(1),
        speed: 0.22,
        bounds: const Bounds2(0, 0, 100, 100),
        start: const Vec2(1, 1),
      );

  bool isMoving = true;

  @override
  void update(double dt) {
    if (isMoving) position = position + Vec2(speed * dt, 0);
  }
}

Future<Uint8List> _raster(
  PictureRecorder recorder,
  int width,
  int height,
) async {
  final picture = recorder.endRecording();
  final image = await picture.toImage(width, height);
  final bytes = await image.toByteData(format: ImageByteFormat.rawRgba);
  image.dispose();
  picture.dispose();
  return bytes!.buffer.asUint8List();
}

Future<Uint8List> _renderSingle(PreyComponent prey) {
  final recorder = PictureRecorder();
  final canvas = Canvas(recorder)..translate(80, 80);
  prey.renderPrey(canvas, prey.diameterPx / 2 * 0.86, 1);
  return _raster(recorder, 160, 160);
}
