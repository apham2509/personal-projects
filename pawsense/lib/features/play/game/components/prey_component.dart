import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../../core/random/seeded_random.dart';
import '../../../../core/utils/vec2.dart' as domain;
import '../../domain/movement/movement_strategy.dart';
import '../../domain/play_tuning.dart';

/// Colour palette for one prey type: regular and high-contrast variants.
class PreyPalette {
  const PreyPalette({
    required this.body,
    required this.accent,
    required this.detail,
  });

  final Color body;
  final Color accent;
  final Color detail;
}

/// Base class for the three procedural prey.
///
/// Rendering is pure Canvas vector work — no image assets. The component
/// only *renders*; movement comes from the injected [MovementStrategy]
/// (pure Dart), and all catch/timeout decisions live in the session
/// controller. Position is the prey's centre (Anchor.center).
///
/// Lifecycle: spawnIn (scale/fade in, not yet touchable) -> active
/// (moving, touchable) -> captured (celebration animation) or expired
/// (gentle fade) -> removed by the game.
abstract class PreyComponent extends PositionComponent {
  PreyComponent({
    required this.tuning,
    required this.strategy,
    required this.unitPx,
    required this.diameterPx,
    required this.palette,
    required SeededRandom animationRng,
  }) : _animationPhase = animationRng.nextDouble() * math.pi * 2,
       super(
         size: Vector2.all(diameterPx),
         anchor: Anchor.center,
         position: Vector2(
           strategy.position.x * unitPx,
           strategy.position.y * unitPx,
         ),
       );

  final PlayTuning tuning;
  final MovementStrategy strategy;

  /// Pixels per movement-space unit (= shortest screen dimension).
  final double unitPx;
  final double diameterPx;
  final PreyPalette palette;

  /// Spawn-in duration comes from tuning: it must equal the controller's
  /// becameTouchable delay so visuals and hit-testing agree.
  double get spawnInSeconds => tuning.targetSpawnInMs / 1000;
  static const double captureSeconds = 0.45;
  static const double expireSeconds = 0.35;

  /// Total lifetime seconds (drives idle animation).
  double elapsed = 0;

  /// Continuous animation phase offset so two spawns never look identical.
  final double _animationPhase;

  _PreyState _state = _PreyState.spawningIn;
  double _stateElapsed = 0;

  /// Direction the prey visually faces (radians), smoothed.
  double _heading = 0;
  Vector2 _lastPosition = Vector2.zero();

  /// Attention nudge (disengagement stage 1): brief scale wobble.
  double _nudgeRemaining = 0;

  bool get isTouchable => _state == _PreyState.active;
  bool get isFinished => _state == _PreyState.removedPending;

  /// Radius of the *touch* hitbox in pixels: inflated visible bounds with a
  /// minimum enforced (small prey stay honestly catchable).
  double get hitboxRadiusPx {
    final inflated = diameterPx / 2 * tuning.hitboxInflationFactor;
    final minimum = tuning.minHitboxDiameterFraction * unitPx / 2;
    return math.max(inflated, minimum);
  }

  @override
  void onMount() {
    super.onMount();
    _lastPosition = position.clone();
  }

  @override
  void update(double dt) {
    super.update(dt);
    elapsed += dt;
    _stateElapsed += dt;
    if (_nudgeRemaining > 0) _nudgeRemaining -= dt;

    switch (_state) {
      case _PreyState.spawningIn:
        if (_stateElapsed >= spawnInSeconds) _setState(_PreyState.active);
      case _PreyState.active:
        strategy.update(dt);
        position.setValues(
          strategy.position.x * unitPx,
          strategy.position.y * unitPx,
        );
        _updateHeading(dt);
      case _PreyState.captured:
        if (_stateElapsed >= captureSeconds) {
          _setState(_PreyState.removedPending);
        }
      case _PreyState.expiring:
        if (_stateElapsed >= expireSeconds) {
          _setState(_PreyState.removedPending);
        }
      case _PreyState.removedPending:
        break;
    }
  }

  void _updateHeading(double dt) {
    final dx = position.x - _lastPosition.x;
    final dy = position.y - _lastPosition.y;
    if (dx * dx + dy * dy > 0.01) {
      final target = math.atan2(dy, dx);
      var delta = target - _heading;
      while (delta > math.pi) {
        delta -= 2 * math.pi;
      }
      while (delta < -math.pi) {
        delta += 2 * math.pi;
      }
      _heading += delta * (6 * dt).clamp(0.0, 1.0);
    }
    _lastPosition.setFrom(position);
  }

  /// Marks the prey caught: freezes movement, plays the capture animation.
  void capture() {
    if (_state == _PreyState.active || _state == _PreyState.spawningIn) {
      _setState(_PreyState.captured);
    }
  }

  /// Times the prey out: gentle fade, no celebration.
  void expire() {
    if (_state == _PreyState.active || _state == _PreyState.spawningIn) {
      _setState(_PreyState.expiring);
    }
  }

  void attentionNudge() {
    _nudgeRemaining = 0.6;
  }

  void _setState(_PreyState next) {
    _state = next;
    _stateElapsed = 0;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final centre = Offset(size.x / 2, size.y / 2);
    final r = size.x / 2;

    var scale = 1.0;
    var opacity = 1.0;
    switch (_state) {
      case _PreyState.spawningIn:
        final t = (_stateElapsed / spawnInSeconds).clamp(0.0, 1.0);
        scale = 0.55 + 0.45 * Curves.easeOutBack(t);
        opacity = t;
      case _PreyState.active:
        if (_nudgeRemaining > 0) {
          scale = 1 + 0.10 * math.sin(_nudgeRemaining * math.pi / 0.6);
        }
      case _PreyState.captured:
        final t = (_stateElapsed / captureSeconds).clamp(0.0, 1.0);
        scale = 1 + 0.35 * math.sin(t * math.pi);
        opacity = 1 - Curves.easeIn(t);
      case _PreyState.expiring:
        final t = (_stateElapsed / expireSeconds).clamp(0.0, 1.0);
        opacity = 1 - t;
      case _PreyState.removedPending:
        return;
    }

    canvas.save();
    canvas.translate(centre.dx, centre.dy);
    canvas.scale(scale);
    canvas.rotate(headingForRender());
    renderPrey(canvas, r * 0.86, opacity);
    canvas.restore();

    if (_state == _PreyState.captured) {
      _renderCaptureBurst(canvas, centre, r);
    }
  }

  /// Subclasses may damp or ignore heading (moths stay mostly upright).
  double headingForRender() => _heading;

  /// Draws the prey centred at the origin within [radius], applying
  /// [opacity] to all paints.
  void renderPrey(Canvas canvas, double radius, double opacity);

  void _renderCaptureBurst(Canvas canvas, Offset centre, double r) {
    final t = (_stateElapsed / captureSeconds).clamp(0.0, 1.0);
    final burstPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.10 * (1 - t)
      ..color = palette.accent.withValues(alpha: (1 - t) * 0.9);
    canvas.drawCircle(centre, r * (0.7 + 1.1 * t), burstPaint);
    final dotPaint = Paint()
      ..color = palette.body.withValues(alpha: (1 - t) * 0.8);
    for (var i = 0; i < 6; i++) {
      final angle = _animationPhase + i * math.pi / 3;
      final distance = r * (0.5 + 1.3 * t);
      canvas.drawCircle(
        centre + Offset(math.cos(angle), math.sin(angle)) * distance,
        r * 0.09 * (1 - t),
        dotPaint,
      );
    }
  }

  /// Movement-space position for spawn logging (normalised 0-1 per axis is
  /// derived by the controller; this is the unit-space position).
  domain.Vec2 get unitPosition => strategy.position;
}

enum _PreyState { spawningIn, active, captured, expiring, removedPending }

/// Minimal curve helpers (avoiding a Flutter dependency in this layer).
class Curves {
  static double easeOutBack(double t) {
    const c1 = 1.70158;
    const c3 = c1 + 1;
    final u = t - 1;
    return 1 + c3 * u * u * u + c1 * u * u;
  }

  static double easeIn(double t) => t * t;
}
