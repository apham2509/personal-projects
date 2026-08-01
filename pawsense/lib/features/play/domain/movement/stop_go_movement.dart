import '../../../../core/utils/vec2.dart';
import 'movement_strategy.dart';

/// Rodent-like scurry/pause cycling: a straight dash, a still pause, then a
/// new direction. Dashes run faster than nominal speed so the average pace
/// over a cycle stays near the configured level.
class StopGoMovement extends MovementStrategy {
  StopGoMovement({
    required super.rng,
    required super.speed,
    required super.bounds,
    required super.start,
  }) {
    _startPause(initial: true);
  }

  static const _dashSpeedMultiplier = 1.6;

  bool _dashing = false;
  double _phaseRemaining = 0;
  Vec2 _direction = const Vec2(1, 0);

  void _startDash() {
    _dashing = true;
    _phaseRemaining = rng.nextDoubleInRange(0.35, 1.0);
    final target = pickWaypoint();
    _direction = (target - position).normalised();
  }

  void _startPause({bool initial = false}) {
    _dashing = false;
    _phaseRemaining = initial
        ? rng.nextDoubleInRange(0.1, 0.5)
        : rng.nextDoubleInRange(0.3, 1.4);
  }

  @override
  void update(double dt) {
    var remaining = dt;
    while (remaining > 0) {
      final slice = remaining < _phaseRemaining ? remaining : _phaseRemaining;
      if (_dashing && slice > 0) {
        final next =
            position + _direction * (speed * _dashSpeedMultiplier * slice);
        final constrained = constrainStep(position, next, slice);
        // Hitting a wall ends the dash early.
        final blocked = constrained.distanceTo(position) < speed * slice * 0.5;
        position = constrained;
        if (blocked) {
          _startPause();
          remaining -= slice;
          continue;
        }
      }
      _phaseRemaining -= slice;
      remaining -= slice;
      if (_phaseRemaining <= 0) {
        if (_dashing) {
          _startPause();
        } else {
          _startDash();
        }
      }
    }
  }
}
