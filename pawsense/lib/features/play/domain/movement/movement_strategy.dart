import '../../../../core/random/seeded_random.dart';
import '../../../../core/utils/vec2.dart';
import '../../../../shared/models/enums.dart';
import 'smooth_movement.dart';
import 'stop_go_movement.dart';
import 'unpredictable_movement.dart';

/// Drives a prey target's position over time.
///
/// Coordinate space: aspect-corrected units where 1.0 equals the shortest
/// screen dimension. The x axis spans `[0, width/shortest]`, y spans
/// `[0, height/shortest]`. In this space, distances and speeds are
/// isotropic (a speed of 0.22/s means the same physical pace in any
/// direction), which is exactly how the product spec defines them.
///
/// Contract (unit-tested for every implementation):
/// - the position never leaves [bounds];
/// - per-update displacement never exceeds
///   `speed * maxStepMultiplier * dt` (no visible teleporting);
/// - two instances with the same seed and update cadence produce identical
///   paths (determinism).
abstract class MovementStrategy {
  MovementStrategy({
    required this.rng,
    required this.speed,
    required this.bounds,
    required Vec2 start,
  }) : position = bounds.clamp(start);

  final SeededRandom rng;

  /// Nominal speed in shortest-dimension units per second.
  final double speed;

  /// Safe area for the target centre (already inset by margin + radius).
  final Bounds2 bounds;

  Vec2 position;

  /// Hard cap on instantaneous speed relative to [speed]; implementations
  /// may briefly move faster than nominal (scurries) but never beyond this.
  static const double maxStepMultiplier = 2.2;

  /// Advances the simulation by [dt] seconds.
  void update(double dt);

  /// Constrains a candidate next position to the contract: clamped into
  /// bounds and capped to the maximum step length.
  Vec2 constrainStep(Vec2 from, Vec2 candidate, double dt) {
    final maxStep = speed * maxStepMultiplier * dt;
    final step = (candidate - from).clampedLength(maxStep);
    return bounds.clamp(from + step);
  }

  /// A random point inside [bounds], biased away from the current position
  /// so paths keep travelling instead of jittering in place.
  Vec2 pickWaypoint() {
    for (var attempt = 0; attempt < 8; attempt++) {
      final p = Vec2(
        rng.nextDoubleInRange(bounds.minX, bounds.maxX),
        rng.nextDoubleInRange(bounds.minY, bounds.maxY),
      );
      final minTravel =
          0.25 * (bounds.width < bounds.height ? bounds.width : bounds.height);
      if (p.distanceTo(position) >= minTravel) return p;
    }
    return bounds.centre;
  }

  static MovementStrategy create({
    required MovementStyle style,
    required SeededRandom rng,
    required double speed,
    required Bounds2 bounds,
    required Vec2 start,
  }) => switch (style) {
    MovementStyle.smooth => SmoothMovement(
      rng: rng,
      speed: speed,
      bounds: bounds,
      start: start,
    ),
    MovementStyle.stopAndGo => StopGoMovement(
      rng: rng,
      speed: speed,
      bounds: bounds,
      start: start,
    ),
    MovementStyle.unpredictable => UnpredictableMovement(
      rng: rng,
      speed: speed,
      bounds: bounds,
      start: start,
    ),
  };
}
