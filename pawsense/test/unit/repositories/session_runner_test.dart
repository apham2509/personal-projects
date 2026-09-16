import 'dart:ui';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/core/audio/audio_service.dart';
import 'package:pawsense/core/database/app_database.dart';
import 'package:pawsense/features/play/presentation/session_launch.dart';
import 'package:pawsense/shared/models/enums.dart';
import 'package:pawsense/shared/providers/core_providers.dart';

import '../../game/fakes.dart';
import '../../widget/harness.dart';

class _SilentAudio extends AudioService {
  @override
  Future<void> preload() async {}

  @override
  Future<void> playCapture() async {}

  @override
  Future<void> playSuccessChime() async {}

  @override
  Future<void> playPreyVoice(PreyType prey) async {}

  @override
  Future<void> playAttention() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final completedTrials in [0, 7, 8]) {
    test(
      'calibration completion requires eight valid trials ($completedTrials)',
      () async {
        final app = TestApp.create();
        final container = ProviderContainer(
          overrides: [
            databaseProvider.overrideWithValue(app.db),
            fileServiceProvider.overrideWithValue(app.files),
            clockProvider.overrideWithValue(app.clock),
            audioServiceProvider.overrideWithValue(_SilentAudio()),
          ],
        );
        addTearDown(() async {
          container.dispose();
          await app.dispose();
        });
        await app.seedCat('Miso');
        final cat = await app.db.select(app.db.catProfiles).getSingle();
        final delegate = RecordingDelegate();
        final runner = container.read(sessionRunnerFactoryProvider);
        final session = await runner.build(
          launch: SessionLaunch(
            mode: SessionMode.calibration,
            catId: cat.id,
            durationSeconds: 30,
            soundEnabled: false,
          ),
          screenSize: const Size(1024, 768),
          delegate: delegate,
        );
        final controller = session.controller..start();
        var caught = 0;
        // Keep the target at its spawn location, drive real controller timing
        // and pointer input, then let the duration cap complete the session.
        for (var i = 0; i < 2000 && !controller.isEnded; i++) {
          controller.update(0.02);
          final target = controller.currentTargetSnapshot;
          if (caught < completedTrials && target != null && target.active) {
            controller.handlePointerDown(
              caught + 1,
              target.centreX,
              target.centreY,
            );
            controller.handlePointerUp(caught + 1);
            caught++;
            if (caught == completedTrials) controller.ownerRequestedEnd();
          }
        }
        expect(caught, completedTrials);
        expect(delegate.summary, isNotNull);
        await runner.finish(delegate.summary!);
        final updated = await app.profileRepo.getById(cat.id);
        // Natural duration completion alone must never mark an unobserved
        // calibration complete. Timeouts also count as valid observations.
        final valid = controller.trials
            .where((trial) => trial.isValidForLearning)
            .length;
        if (completedTrials > 0) expect(valid, completedTrials);
        expect(
          updated!.calibrationState,
          valid >= 8 ? CalibrationState.completed : CalibrationState.inProgress,
        );
        if (completedTrials == 0) {
          expect(delegate.summary!.status, SessionStatus.completed);
          expect(updated.calibrationState, CalibrationState.inProgress);
        }
      },
    );
  }

  test(
    'explicit sound choice overrides the saved default for the session',
    () async {
      final app = TestApp.create();
      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(app.db),
          fileServiceProvider.overrideWithValue(app.files),
          clockProvider.overrideWithValue(app.clock),
          audioServiceProvider.overrideWithValue(_SilentAudio()),
        ],
      );
      addTearDown(() async {
        container.dispose();
        await app.dispose();
      });
      await app.db
          .update(app.db.appSettings)
          .write(const AppSettingsCompanion(soundEnabled: Value(false)));
      final runner = container.read(sessionRunnerFactoryProvider);
      final delegate = RecordingDelegate();
      final session = await runner.build(
        launch: const SessionLaunch(
          mode: SessionMode.mixed,
          catId: null,
          durationSeconds: 60,
          soundEnabled: true,
        ),
        screenSize: const Size(1024, 768),
        delegate: delegate,
      );
      expect(session.controller.plan.soundEnabled, isTrue);
      session.controller.interrupt();
      await runner.finish(delegate.summary!);
    },
  );
}
