import '../../../../core/utils/vec2.dart';
import 'movement_strategy.dart';

/// Bounded, non-teleporting erratic motion: waypoint and speed multiplier
/// retarget at random intervals, with a high (but finite) turn rate and
/// occasional micro-pauses. Reads as "unpredictable" without ever jumping.
class UnpredictableMovement extends MovementStrategy {
  UnpredictableMovement({
    required super.rng,
    required super.speed,
    required super.bounds,
    required super.start,
  }) {
    _waypoint = pickWaypoint();
    _velocity = (_waypoint - position).normalised() * speed;
    _scheduleRetarget();
  }

  static const _turnRate = 6.0;
  static const _arriveDistance = 0.03;

  late Vec2 _waypoint;
  late Vec2 _velocity;
  double _untilRetarget = 0;
  double _speedMultiplier = 1;
  double _pauseRemaining = 0;

  void _scheduleRetarget() {
    _untilRetarget = rng.nextDoubleInRange(0.4, 1.8);
    _speedMultiplier = rng.nextDoubleInRange(0.6, 1.5);
    if (rng.nextDouble() < 0.15) {
      _pauseRemaining = rng.nextDoubleInRange(0.12, 0.35);
    }
    _waypoint = pickWaypoint();
  }

  @override
  void update(double dt) {
    if (dt <= 0) return;
    if (_pauseRemaining > 0) {
      _pauseRemaining -= dt;
      return;
    }
    _untilRetarget -= dt;
    if (_untilRetarget <= 0 ||
        position.distanceTo(_waypoint) < _arriveDistance) {
      _scheduleRetarget();
    }
    final targetSpeed = speed * _speedMultiplier;
    final desired = (_waypoint - position).normalised() * targetSpeed;
    final blend = (_turnRate * dt).clamp(0.0, 1.0);
    _velocity = _velocity + (desired - _velocity) * blend;
    _velocity = _velocity.clampedLength(targetSpeed);
    final next = position + _velocity * dt;
    position = constrainStep(position, next, dt);
    if (!bounds.contains(position + _velocity * dt * 4)) {
      _waypoint = pickWaypoint();
    }
  }
}
