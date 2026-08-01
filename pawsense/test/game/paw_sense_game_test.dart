import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/core/utils/vec2.dart' as domain;
import 'package:pawsense/features/personalisation/domain/safety_constraints.dart';
import 'package:pawsense/features/play/domain/play_tuning.dart';
import 'package:pawsense/features/play/domain/session_models.dart';
import 'package:pawsense/features/play/game/game_session_controller.dart';
import 'package:pawsense/features/play/game/paw_sense_game.dart';
import 'package:pawsense/shared/models/enums.dart';
import 'package:pawsense/shared/models/trial_configuration.dart';

import 'fakes.dart';

void main() {
  const width = 1200.0;
  const height = 800.0;
  const frame = 1 / 60;

  const config = TrialConfiguration(
    preyType: PreyType.moth,
    movementStyle: MovementStyle.unpredictable,
    speedLevel: SpeedLevel.medium,
    sizeLevel: SizeLevel.medium,
    soundMode: SoundMode.silent,
    spawnZone: SpawnZone.top,
  );

  Future<(PawSenseGame, GameSessionController, RecordingDelegate)>
  buildGame() async {
    final delegate = RecordingDelegate();
    final controller = GameSessionController(
      plan: const SessionPlan(
        mode: SessionMode.freePlay,
        catId: 'cat-1',
        plannedDurationSeconds: 300,
        soundEnabled: false,
        seed: 7,
        initialDifficulty: 2,
        rewardSchedule: RewardSchedule.none,
        maxRewardReminders: 3,
        isCalibration: false,
      ),
      tuning: defaultPlayTuning,
      constraints: const SafetyConstraints(),
      trialSource: FixedTrialSource(config),
      audio: FakeAudio(),
      delegate: delegate,
      screenWidth: width,
      screenHeight: height,
    );
    final game = PawSenseGame(
      controller: controller,
      tuning: defaultPlayTuning,
      highContrast: false,
    );
    game.onGameResize(Vector2(width, height));
    await game.onLoad();
    controller.start();
    return (game, controller, delegate);
  }

  void tick(PawSenseGame game, RecordingDelegate delegate, double seconds) {
    final frames = (seconds / frame).round();
    for (var i = 0; i < frames; i++) {
      // The play screen forwards spawn callbacks to the game; emulate that
      // wiring here.
      final spawnsBefore = delegate.spawns.length;
      game.update(frame);
      if (delegate.spawns.length > spawnsBefore) {
        final configuration = delegate.spawns.last;
        game.spawnPrey(
          configuration: configuration,
          pathSeed: 1234,
          unitPosition: delegate.spawnPositions.last,
          diameterPx:
              defaultPlayTuning.sizeFraction(configuration.sizeLevel) * height,
        );
      }
    }
  }

  testWidgets('spawned prey exists, moves, and stays reachable', (
    tester,
  ) async {
    final (game, controller, delegate) = await buildGame();
    tick(game, delegate, 3.5);
    expect(game.currentPrey, isNotNull);

    final radiusUnits = defaultPlayTuning.sizeFractionMedium / 2;
    final bounds = controller.safeBounds(radiusUnits);
    domain.Vec2? previous;
    var moved = 0.0;
    for (var i = 0; i < 8 * 60; i++) {
      game.update(frame);
      final prey = game.currentPrey;
      if (prey == null || !prey.isTouchable) continue;
      final position = prey.unitPosition;
      expect(
        bounds.contains(position),
        isTrue,
        reason: 'prey left safe bounds at frame $i: $position',
      );
      if (previous != null) moved += position.distanceTo(previous);
      previous = position;
    }
    expect(moved, greaterThan(0.5), reason: 'prey must actually move');
  });

  testWidgets('capture deactivates the target immediately', (tester) async {
    final (game, controller, delegate) = await buildGame();
    tick(game, delegate, 3.5);

    final snapshot = controller.currentTargetSnapshot!;
    expect(snapshot.active, isTrue);
    controller.handlePointerDown(1, snapshot.centreX, snapshot.centreY);
    game.captureCurrentPrey();

    // Immediately inactive for hit-testing...
    expect(controller.currentTargetSnapshot, isNull);
    expect(game.currentPrey!.isTouchable, isFalse);

    // ...and the component finishes its celebration then leaves the tree.
    for (var i = 0; i < 60; i++) {
      game.update(frame);
    }
    expect(game.currentPrey, isNull);
  });

  testWidgets('expiry fades the prey out and removes it', (tester) async {
    final (game, controller, delegate) = await buildGame();
    tick(game, delegate, 3.5);
    game.expireCurrentPrey();
    expect(game.currentPrey!.isTouchable, isFalse);
    for (var i = 0; i < 40; i++) {
      game.update(frame);
    }
    expect(game.currentPrey, isNull);
  });

  testWidgets('prey components render without errors', (tester) async {
    // Smoke-render each prey type across its states onto a real canvas.
    final (game, controller, delegate) = await buildGame();
    tick(game, delegate, 3.5);
    final prey = game.currentPrey!;
    await tester.runAsync(() async {
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      prey.render(canvas);
      game.update(frame);
      prey.render(canvas);
      prey.capture();
      game.update(frame);
      prey.render(canvas);
      recorder.endRecording();
    });
  });
}
