import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pawsense/core/device/play_keep_awake.dart';
import 'package:pawsense/features/personalisation/domain/safety_constraints.dart';
import 'package:pawsense/features/play/domain/play_tuning.dart';
import 'package:pawsense/features/play/domain/session_models.dart';
import 'package:pawsense/features/play/game/game_session_controller.dart';
import 'package:pawsense/features/play/presentation/play_screen.dart';
import 'package:pawsense/features/play/presentation/session_launch.dart';
import 'package:pawsense/l10n/generated/app_localizations.dart';
import 'package:pawsense/shared/models/enums.dart';
import 'package:pawsense/shared/providers/core_providers.dart';

import '../game/fakes.dart';
import 'harness.dart';

class TestScreenWakeLock implements ScreenWakeLockPlatform {
  @override
  Future<void> setEnabled(bool enabled) async {}
}

class TestSessionRunner extends SessionRunnerFactory {
  TestSessionRunner(super.ref);

  Completer<void>? pendingBuild;
  GameSessionController? controller;
  Size? boardSize;
  final summaries = <SessionSummary>[];

  @override
  Future<BuiltSession> build({
    required SessionLaunch launch,
    required Size screenSize,
    required SessionDelegate delegate,
  }) async {
    boardSize = screenSize;
    final builtController = controller = GameSessionController(
      plan: const SessionPlan(
        mode: SessionMode.freePlay,
        catId: 'cat',
        plannedDurationSeconds: 180,
        soundEnabled: false,
        seed: 42,
        initialDifficulty: 2,
        rewardSchedule: RewardSchedule.none,
        maxRewardReminders: 0,
        isCalibration: false,
      ),
      tuning: defaultPlayTuning,
      constraints: const SafetyConstraints(),
      trialSource: FixedTrialSource(FixedTrialSource.easy),
      audio: FakeAudio(),
      delegate: delegate,
      screenWidth: screenSize.width,
      screenHeight: screenSize.height,
    );
    await pendingBuild?.future;
    return BuiltSession(
      controller: builtController,
      tuning: defaultPlayTuning,
      highContrast: false,
    );
  }

  @override
  Future<String> finish(SessionSummary summary) {
    summaries.add(summary);
    // Leave the result pending so each test can inspect the finished surface.
    return Completer<String>().future;
  }
}

void main() {
  Future<(GoRouter, TestSessionRunner)> openPlay(
    WidgetTester tester, {
    Completer<void>? pendingBuild,
  }) async {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (_) async => null,
    );
    addTearDown(() {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      );
    });
    final app = TestApp.create();
    addTearDown(app.dispose);
    late TestSessionRunner runner;
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(body: Text('Owner screen')),
        ),
        GoRoute(
          path: '/play',
          builder: (_, _) => const PlayScreen(
            launch: SessionLaunch(
              mode: SessionMode.freePlay,
              catId: 'cat',
              durationSeconds: 180,
              soundEnabled: false,
            ),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          screenWakeLockPlatformProvider.overrideWithValue(
            TestScreenWakeLock(),
          ),
          databaseProvider.overrideWithValue(app.db),
          fileServiceProvider.overrideWithValue(app.files),
          clockProvider.overrideWithValue(app.clock),
          sessionRunnerFactoryProvider.overrideWith((ref) {
            runner = TestSessionRunner(ref)..pendingBuild = pendingBuild;
            return runner;
          }),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    unawaited(router.push('/play'));
    for (var i = 0; i < 50; i++) {
      await tester.pump(const Duration(milliseconds: 30));
    }
    expect(runner.controller, isNotNull);
    return (router, runner);
  }

  testWidgets(
    'system Back cannot bypass the owner gate; removal persists interruption',
    (tester) async {
      final (router, runner) = await openPlay(tester);
      await tester.binding.handlePopRoute();
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.byType(PlayScreen), findsOneWidget);
      expect(runner.summaries, isEmpty);
      router.go('/');
      await tester.pumpAndSettle();
      expect(runner.summaries.single.status, SessionStatus.interrupted);
      await tearDownApp(tester);
    },
  );

  testWidgets('a session constructed after navigation is still finalised', (
    tester,
  ) async {
    final pending = Completer<void>();
    final (router, runner) = await openPlay(tester, pendingBuild: pending);
    router.go('/');
    await tester.pumpAndSettle();
    pending.complete();
    await tester.pump();
    expect(runner.summaries.single.status, SessionStatus.interrupted);
    expect(tester.takeException(), isNull);
    await tearDownApp(tester);
  });

  testWidgets('changing board dimensions safely interrupts the session', (
    tester,
  ) async {
    final (_, runner) = await openPlay(tester);
    tester.view.physicalSize = const Size(600, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pump();
    await tester.pump();
    expect(runner.summaries.single.status, SessionStatus.interrupted);
    expect(runner.controller!.isEnded, isTrue);
    await tearDownApp(tester);
  });

  testWidgets('backgrounding finalises a live session exactly once', (
    tester,
  ) async {
    final (_, runner) = await openPlay(tester);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();
    expect(runner.summaries.single.status, SessionStatus.backgrounded);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tearDownApp(tester);
    expect(runner.summaries, hasLength(1));
  });

  testWidgets('two-corner gate pauses play and requires the owner hold', (
    tester,
  ) async {
    final (_, runner) = await openPlay(tester);
    final board = runner.boardSize!;
    final left = await tester.startGesture(const Offset(12, 12), pointer: 1);
    final right = await tester.startGesture(
      Offset(board.width - 12, 12),
      pointer: 2,
    );
    for (var i = 0; i < 125; i++) {
      await tester.pump(const Duration(milliseconds: 20));
    }
    expect(find.text('Owner check'), findsOneWidget);
    await left.up();
    await right.up();
    final pausedAt = runner.controller!.sessionMs;
    await tester.pump(const Duration(seconds: 2));
    expect(runner.controller!.sessionMs, pausedAt);
    expect(runner.summaries, isEmpty);
    final hold = await tester.startGesture(
      tester.getCenter(find.text('Hold to end')),
    );
    await tester.pump(const Duration(milliseconds: 1300));
    await hold.up();
    await tester.pump();
    expect(runner.summaries.single.status, SessionStatus.ownerStopped);
    await tearDownApp(tester);
  });

  testWidgets('a paw swipe through live prey reaches the catch pipeline', (
    tester,
  ) async {
    final (_, runner) = await openPlay(tester);
    for (var i = 0; i < 140; i++) {
      await tester.pump(const Duration(milliseconds: 20));
    }
    final controller = runner.controller!;
    final target = controller.currentTargetSnapshot!;
    expect(target.active, isTrue);
    final reach = target.hitboxRadius + 20;
    final paw = await tester.startGesture(
      Offset(target.centreX - reach, target.centreY),
    );
    await paw.moveTo(Offset(target.centreX + reach, target.centreY));
    expect(controller.trials.single.success, isTrue);
    expect(controller.trials.single.missCount, 0);
    await paw.up();
    expect(controller.processor.activePointerCount, 0);
    await tearDownApp(tester);
  });
}
