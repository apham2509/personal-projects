import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/l10n_ext.dart';
import '../../../core/utils/vec2.dart' as domain;
import '../../../shared/models/trial_configuration.dart';
import '../../../shared/providers/core_providers.dart';
import '../domain/session_models.dart';
import '../game/game_session_controller.dart';
import '../game/input/owner_exit_tracker.dart';
import '../game/paw_sense_game.dart';
import 'session_launch.dart';

/// The cat-facing full-screen play surface.
///
/// Structure (bottom to top):
/// 1. GameWidget (renders prey; no input handling of its own)
/// 2. Listener (routes every pointer event through the touch pipeline and
///    the owner-exit tracker)
/// 3. Countdown / reward-hint / owner-gate overlays. Only the owner gate is
///    interactive, and it appears solely after the two-corner hold.
class PlayScreen extends ConsumerStatefulWidget {
  const PlayScreen({super.key, required this.launch});

  final SessionLaunch launch;

  @override
  ConsumerState<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends ConsumerState<PlayScreen>
    with WidgetsBindingObserver
    implements SessionDelegate {
  GameSessionController? _controller;
  PawSenseGame? _game;
  OwnerExitTracker? _exitTracker;
  Timer? _exitPoll;
  bool _buildRequested = false;

  int _countdown = 0;
  bool _showOwnerGate = false;
  bool _rewardHintVisible = false;
  bool _ended = false;
  Object? _buildError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Immersive, landscape-preferred play. Restored on dispose.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _exitPoll?.cancel();
    _restoreSystemUi();
    super.dispose();
  }

  void _restoreSystemUi() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      _controller?.appBackgrounded();
    }
  }

  void _requestBuild(Size size) {
    if (_buildRequested) return;
    _buildRequested = true;
    final runner = ref.read(sessionRunnerFactoryProvider);
    runner
        .build(launch: widget.launch, screenSize: size, delegate: this)
        .then((built) {
          if (!mounted) return;
          setState(() {
            _controller = built.controller;
            _exitTracker = OwnerExitTracker(
              tuning: built.tuning,
              screenWidth: size.width,
              screenHeight: size.height,
            );
            _game = PawSenseGame(
              controller: built.controller,
              tuning: built.tuning,
              highContrast: built.highContrast,
            );
          });
          built.controller.start();
          _exitPoll = Timer.periodic(const Duration(milliseconds: 120), (_) {
            final tracker = _exitTracker;
            final controller = _controller;
            if (tracker == null || controller == null) return;
            if (!_showOwnerGate && tracker.isTriggered(controller.sessionMs)) {
              setState(() => _showOwnerGate = true);
            }
          });
        })
        .catchError((Object error) {
          if (mounted) setState(() => _buildError = error);
        });
  }

  // --- SessionDelegate ------------------------------------------------------

  @override
  void onCountdownTick(int secondsRemaining) {
    if (mounted) setState(() => _countdown = secondsRemaining);
  }

  @override
  void onSpawnTarget({
    required TrialConfiguration configuration,
    required int pathSeed,
    required domain.Vec2 unitPosition,
    required double diameterPx,
  }) {
    if (_countdown != 0 && mounted) setState(() => _countdown = 0);
    _game?.spawnPrey(
      configuration: configuration,
      pathSeed: pathSeed,
      unitPosition: unitPosition,
      diameterPx: diameterPx,
    );
  }

  @override
  void onTargetCaptured() => _game?.captureCurrentPrey();

  @override
  void onTargetExpired() => _game?.expireCurrentPrey();

  @override
  void onAttentionNudge() => _game?.nudgeCurrentPrey();

  @override
  void onRewardReminder() {
    if (!mounted) return;
    setState(() => _rewardHintVisible = true);
    Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _rewardHintVisible = false);
    });
  }

  @override
  void onTrialFinalised(TrialRecord trial, List<TouchRecord> touches) {}

  @override
  void onSessionEnded(SessionSummary summary) {
    if (_ended || !mounted) return;
    _ended = true;
    _restoreSystemUi();
    final runner = ref.read(sessionRunnerFactoryProvider);
    runner.finish(summary).then((sessionId) {
      if (!mounted) return;
      context.pushReplacement('/results/$sessionId');
    });
  }

  // --- Input ----------------------------------------------------------------

  void _pointerDown(PointerDownEvent event) {
    final controller = _controller;
    if (controller == null) return;
    _exitTracker?.pointerDown(
      event.pointer,
      event.localPosition.dx,
      event.localPosition.dy,
      controller.sessionMs,
    );
    controller.handlePointerDown(
      event.pointer,
      event.localPosition.dx,
      event.localPosition.dy,
    );
  }

  void _pointerMove(PointerMoveEvent event) {
    _exitTracker?.pointerMove(
      event.pointer,
      event.localPosition.dx,
      event.localPosition.dy,
      _controller?.sessionMs ?? 0,
    );
  }

  void _pointerUpOrCancel(int pointer) {
    _exitTracker?.pointerUpOrCancel(pointer, _controller?.sessionMs ?? 0);
    _controller?.handlePointerUp(pointer);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (_buildError != null) {
      return Scaffold(
        backgroundColor: PawSenseGame.backgroundColour,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.errorGenericTitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 20),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => context.pop(),
                  child: Text(l10n.actionClose),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: PawSenseGame.backgroundColour,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);
          _requestBuild(size);
          final game = _game;
          if (game == null) {
            return const ColoredBox(color: PawSenseGame.backgroundColour);
          }
          return Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: _pointerDown,
            onPointerMove: _pointerMove,
            onPointerUp: (e) => _pointerUpOrCancel(e.pointer),
            onPointerCancel: (e) => _pointerUpOrCancel(e.pointer),
            child: Stack(
              fit: StackFit.expand,
              children: [
                GameWidget(game: game),
                if (_countdown > 0) _CountdownOverlay(count: _countdown),
                if (_rewardHintVisible) const _RewardHint(),
                if (_showOwnerGate)
                  _OwnerGate(
                    onCancel: () {
                      _exitTracker?.reset();
                      setState(() => _showOwnerGate = false);
                    },
                    onConfirm: () {
                      setState(() => _showOwnerGate = false);
                      _controller?.ownerRequestedEnd();
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Calm three-second start: large dim digits, no sound, no motion.
class _CountdownOverlay extends StatelessWidget {
  const _CountdownOverlay({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Text(
          '$count',
          style: TextStyle(
            fontSize: 120,
            fontWeight: FontWeight.w200,
            color: Colors.white.withValues(alpha: 0.35),
          ),
        ),
      ),
    );
  }
}

/// Non-textual, brief, dim treat hint for the supervising owner.
class _RewardHint extends StatelessWidget {
  const _RewardHint();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Center(
          child: AnimatedOpacity(
            opacity: 0.5,
            duration: const Duration(milliseconds: 400),
            child: Icon(Icons.pets, size: 28, color: Colors.amber.shade200),
          ),
        ),
      ),
    );
  }
}

/// Owner gate: press-and-hold confirmation, or PIN when one is configured.
class _OwnerGate extends ConsumerStatefulWidget {
  const _OwnerGate({required this.onCancel, required this.onConfirm});

  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  @override
  ConsumerState<_OwnerGate> createState() => _OwnerGateState();
}

class _OwnerGateState extends ConsumerState<_OwnerGate> {
  final _pinController = TextEditingController();
  bool _pinError = false;
  double _holdProgress = 0;
  Timer? _holdTimer;

  @override
  void dispose() {
    _holdTimer?.cancel();
    _pinController.dispose();
    super.dispose();
  }

  void _startHold() {
    _holdTimer?.cancel();
    _holdTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() => _holdProgress += 0.05 / 1.2);
      if (_holdProgress >= 1) {
        timer.cancel();
        widget.onConfirm();
      }
    });
  }

  void _endHold() {
    _holdTimer?.cancel();
    if (mounted) setState(() => _holdProgress = 0);
  }

  Future<void> _submitPin() async {
    final ok = await ref
        .read(settingsRepositoryProvider)
        .verifyOwnerPin(_pinController.text);
    if (!mounted) return;
    if (ok) {
      widget.onConfirm();
    } else {
      setState(() => _pinError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider).value;
    final pinRequired = settings?.ownerPinHash != null;

    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.82),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.ownerGateTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  pinRequired ? l10n.ownerGatePinBody : l10n.ownerGateHoldBody,
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (pinRequired) ...[
                  TextField(
                    controller: _pinController,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 4,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      counterText: '',
                      errorText: _pinError ? l10n.ownerGatePinError : null,
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white38),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    onSubmitted: (_) => _submitPin(),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _submitPin,
                    child: Text(l10n.ownerGateEndSession),
                  ),
                ] else
                  GestureDetector(
                    onTapDown: (_) => _startHold(),
                    onTapUp: (_) => _endHold(),
                    onTapCancel: _endHold,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 96,
                          height: 96,
                          child: CircularProgressIndicator(
                            value: _holdProgress,
                            strokeWidth: 6,
                            color: Colors.white,
                            backgroundColor: Colors.white24,
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Text(
                            l10n.ownerGateHoldLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: widget.onCancel,
                  child: Text(
                    l10n.ownerGateResume,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
