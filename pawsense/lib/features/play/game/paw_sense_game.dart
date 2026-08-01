import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';

import '../../../core/random/seeded_random.dart';
import '../../../core/utils/vec2.dart' as domain;
import '../../../shared/models/enums.dart';
import '../../../shared/models/trial_configuration.dart';
import '../domain/movement/movement_strategy.dart';
import '../domain/play_tuning.dart';
import 'components/fish_component.dart';
import 'components/moth_component.dart';
import 'components/mouse_component.dart';
import 'components/prey_component.dart';
import 'game_session_controller.dart';

/// The cat-facing Flame surface: a calm dark background and at most one
/// prey. All decisions live in [GameSessionController]; the game renders,
/// animates, and reports the target's live position back for hit testing.
///
/// Deliberately contains no Flame input handlers — raw pointer events are
/// captured by the Flutter [Listener] above the GameWidget and routed
/// through the pure touch pipeline (DECISIONS.md D-009).
class PawSenseGame extends FlameGame {
  PawSenseGame({
    required this.controller,
    required this.tuning,
    required this.highContrast,
  });

  final GameSessionController controller;
  final PlayTuning tuning;
  final bool highContrast;

  /// Calm near-black green-tinted backdrop; prey palettes are chosen for
  /// contrast against this.
  static const backgroundColour = Color(0xFF101512);

  PreyComponent? _prey;

  @override
  Color backgroundColor() => backgroundColour;

  @override
  void update(double dt) {
    super.update(dt);
    controller.update(dt);
    final prey = _prey;
    if (prey != null) {
      if (prey.isFinished) {
        prey.removeFromParent();
        _prey = null;
      } else if (prey.isTouchable) {
        controller.reportTargetPosition(prey.unitPosition);
      }
    }
  }

  /// Spawns the trial's prey. Called by the session runner in response to
  /// [SessionDelegate.onSpawnTarget].
  void spawnPrey({
    required TrialConfiguration configuration,
    required int pathSeed,
    required domain.Vec2 unitPosition,
    required double diameterPx,
  }) {
    _prey?.removeFromParent();
    final unitPx = size.x < size.y ? size.x : size.y;
    final radiusUnits = diameterPx / 2 / unitPx;
    final bounds = controller.safeBounds(radiusUnits);
    final rng = SeededRandom(pathSeed);
    final strategy = MovementStrategy.create(
      style: configuration.movementStyle,
      rng: rng,
      speed: tuning.speedFraction(configuration.speedLevel),
      bounds: bounds,
      start: unitPosition,
    );
    final prey = _buildPrey(
      configuration.preyType,
      strategy,
      unitPx,
      diameterPx,
      rng.fork(),
    );
    _prey = prey;
    add(prey);
  }

  PreyComponent _buildPrey(
    PreyType type,
    MovementStrategy strategy,
    double unitPx,
    double diameterPx,
    SeededRandom animationRng,
  ) {
    return switch (type) {
      PreyType.mouse => MouseComponent(
        tuning: tuning,
        strategy: strategy,
        unitPx: unitPx,
        diameterPx: diameterPx,
        palette: highContrast
            ? MouseComponent.highContrastPalette
            : MouseComponent.regularPalette,
        animationRng: animationRng,
      ),
      PreyType.moth => MothComponent(
        tuning: tuning,
        strategy: strategy,
        unitPx: unitPx,
        diameterPx: diameterPx,
        palette: highContrast
            ? MothComponent.highContrastPalette
            : MothComponent.regularPalette,
        animationRng: animationRng,
      ),
      PreyType.fish => FishComponent(
        tuning: tuning,
        strategy: strategy,
        unitPx: unitPx,
        diameterPx: diameterPx,
        palette: highContrast
            ? FishComponent.highContrastPalette
            : FishComponent.regularPalette,
        animationRng: animationRng,
      ),
    };
  }

  void captureCurrentPrey() => _prey?.capture();

  void expireCurrentPrey() => _prey?.expire();

  void nudgeCurrentPrey() => _prey?.attentionNudge();

  /// Test hook: the live prey component, if any.
  @visibleForTesting
  PreyComponent? get currentPrey => _prey;
}
