import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/core/random/seeded_random.dart';
import 'package:pawsense/core/utils/vec2.dart';
import 'package:pawsense/features/play/domain/movement/movement_strategy.dart';
import 'package:pawsense/shared/models/enums.dart';

void main() {
  const bounds = Bounds2(0.12, 0.12, 1.55, 0.88); // landscape-ish safe area
  const speeds = [0.12, 0.22, 0.35];
  const frame = 1 / 60;

  MovementStrategy build(MovementStyle style, double speed, int seed) =>
      MovementStrategy.create(
        style: style,
        rng: SeededRandom(seed),
        speed: speed,
        bounds: bounds,
        start: bounds.centre,
      );

  for (final style in MovementStyle.values) {
    group(style.name, () {
      test('never leaves safe bounds over 120 simulated seconds', () {
        for (final speed in speeds) {
          for (var seed = 0; seed < 10; seed++) {
            final strategy = build(style, speed, seed);
            for (var i = 0; i < 120 * 60; i++) {
              strategy.update(frame);
              expect(
                bounds.contains(strategy.position),
                isTrue,
                reason:
                    '${style.name} speed=$speed seed=$seed left bounds at '
                    'frame $i: ${strategy.position}',
              );
            }
          }
        }
      });

      test('no teleporting: per-frame step respects the hard cap', () {
        for (final speed in speeds) {
          final strategy = build(style, speed, 3);
          var previous = strategy.position;
          final maxStep =
              speed * MovementStrategy.maxStepMultiplier * frame + 1e-9;
          for (var i = 0; i < 30 * 60; i++) {
            strategy.update(frame);
            final step = strategy.position.distanceTo(previous);
            expect(
              step,
              lessThanOrEqualTo(maxStep),
              reason: '${style.name} speed=$speed jumped $step at frame $i',
            );
            previous = strategy.position;
          }
        }
      });

      test('same seed reproduces the identical path', () {
        final a = build(style, 0.22, 1234);
        final b = build(style, 0.22, 1234);
        for (var i = 0; i < 10 * 60; i++) {
          a.update(frame);
          b.update(frame);
          expect(a.position, b.position);
        }
      });

      test('actually travels (no corner trapping / permanent stalls)', () {
        final strategy = build(style, 0.22, 42);
        var travelled = 0.0;
        var previous = strategy.position;
        for (var i = 0; i < 30 * 60; i++) {
          strategy.update(frame);
          travelled += strategy.position.distanceTo(previous);
          previous = strategy.position;
        }
        // 30 s at nominal 0.22/s would be 6.6 units; pauses reduce that,
        // but anything above 2 units means healthy movement.
        expect(travelled, greaterThan(2.0));
      });

      test('irregular frame times stay within bounds too', () {
        final strategy = build(style, 0.35, 9);
        final dts = [0.008, 0.033, 0.016, 0.05, 0.021];
        for (var i = 0; i < 5000; i++) {
          strategy.update(dts[i % dts.length]);
          expect(bounds.contains(strategy.position), isTrue);
        }
      });
    });
  }
}
