import '../../../../core/utils/vec2.dart';
import 'movement_strategy.dart';

/// Continuous curved wandering: velocity steers smoothly towards a
/// waypoint; on arrival a new waypoint is chosen. The capped turn rate is
/// what makes the path curve rather than zig-zag.
class SmoothMovement extends MovementStrategy {
  SmoothMovement({
    required super.rng,
    required super.speed,
    required super.bounds,
    required super.start,
  }) {
    _waypoint = pickWaypoint();
    _velocity = (_waypoint - position).normalised() * speed;
  }

  static const _turnRate = 3.0; // fraction of velocity corrected per second
  static const _arriveDistance = 0.03;

  late Vec2 _waypoint;
  late Vec2 _velocity;

  @override
  void update(double dt) {
    if (dt <= 0) return;
    if (position.distanceTo(_waypoint) < _arriveDistance) {
      _waypoint = pickWaypoint();
    }
    final desired = (_waypoint - position).normalised() * speed;
    final blend = (_turnRate * dt).clamp(0.0, 1.0);
    _velocity = _velocity + (desired - _velocity) * blend;
    // Renormalise so curves do not slow the target down.
    _velocity = _velocity.normalised() * speed;
    final next = position + _velocity * dt;
    position = constrainStep(position, next, dt);
    if (!bounds.contains(position + _velocity * dt * 4)) {
      // Heading out soon: retarget inward early so we never hug walls.
      _waypoint = pickWaypoint();
    }
  }
}
