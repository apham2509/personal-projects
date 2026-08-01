import 'dart:math' as math;

import '../../../core/random/seeded_random.dart';
import '../../../core/utils/stats.dart';
import '../../../core/utils/vec2.dart';
import '../../../shared/models/enums.dart';
import '../../../shared/models/trial_configuration.dart';
import '../../personalisation/domain/disengagement_tracker.dart';
import '../../personalisation/domain/frustration_detector.dart';
import '../../personalisation/domain/safety_constraints.dart';
import '../domain/play_tuning.dart';
import '../domain/session_models.dart';
import '../domain/touch_models.dart';
import 'input/paw_touch_processor.dart';

/// Supplies the next trial configuration. Calibration wraps a fixed
/// schedule; adaptive play wraps the configuration selector; the developer
/// screen wraps a single replayed configuration.
abstract class TrialSource {
  /// Next configuration given the session's history.
  TrialConfiguration next({
    required int difficulty,
    required List<TrialConfiguration> history,
  });

  /// A deliberately easy configuration (disengagement stage 2): large,
  /// slow, centre-spawned, using the most promising prey available.
  TrialConfiguration easier({required List<TrialConfiguration> history});

  /// Feedback for learning-valid finished trials (no-op for fixed
  /// schedules).
  void onTrialOutcome(TrialRecord outcome) {}

  /// Adaptive sources own a difficulty controller and expose its current
  /// value here; the session controller mirrors it.
  int? get difficultyOverride => null;

  /// Null = unlimited (free play); calibration returns its remaining count.
  int? get remainingTrials => null;
}

/// Plays owner cues and built-in effects. Implemented over audioplayers in
/// the app; faked in tests. Cue futures complete when playback finishes.
abstract class SessionAudio {
  bool hasCue(CueType type);
  Future<void> playCue(CueType type);
  void playEffect(SessionEffect effect, {PreyType? prey});
}

enum SessionEffect { capturePop, successChime, attention, preyVoice }

/// Receives controller decisions. The play screen implements the visual
/// parts; the persistence pipeline wraps it for the record parts.
abstract class SessionDelegate {
  void onCountdownTick(int secondsRemaining) {}

  void onSpawnTarget({
    required TrialConfiguration configuration,
    required int pathSeed,
    required Vec2 unitPosition,
    required double diameterPx,
  });

  void onTargetCaptured() {}

  void onTargetExpired() {}

  void onAttentionNudge() {}

  void onRewardReminder() {}

  void onTrialFinalised(TrialRecord trial, List<TouchRecord> touches) {}

  void onSessionEnded(SessionSummary summary) {}
}

enum _Phase { countdown, cuePlaying, cueDelay, targetActive, interTrial, ended }

/// The single authority for a live session: trial lifecycle, catches,
/// timeouts, disengagement, frustration response, reward reminders, cue
/// sequencing, and typed session end.
///
/// Pure Dart and tick-driven: the play screen forwards pointer events and
/// the game loop calls [update]; tests drive it deterministically with a
/// fake delegate and audio. No database access happens in here — records
/// stream out through the delegate at trial boundaries.
class GameSessionController {
  GameSessionController({
    required this.plan,
    required this.tuning,
    required this.constraints,
    required this.trialSource,
    required this.audio,
    required this.delegate,
    required this.screenWidth,
    required this.screenHeight,
  }) : rng = SeededRandom(plan.seed),
       processor = PawTouchProcessor(
         tuning: tuning,
         screenWidth: screenWidth,
         screenHeight: screenHeight,
       ),
       frustration = FrustrationDetector(),
       disengagement = DisengagementTracker(
         attentionNudgeAfterMs: tuning.attentionNudgeAfterMs,
         easierTargetAfterMs: tuning.easierTargetAfterMs,
         endAfterMs: tuning.endDisengagedAfterMs,
       ),
       _unitPx = math.min(screenWidth, screenHeight);

  final SessionPlan plan;
  final PlayTuning tuning;
  final SafetyConstraints constraints;
  final TrialSource trialSource;
  final SessionAudio audio;
  final SessionDelegate delegate;
  final double screenWidth;
  final double screenHeight;

  final SeededRandom rng;
  final PawTouchProcessor processor;
  final FrustrationDetector frustration;
  final DisengagementTracker disengagement;
  final double _unitPx;

  static const int _maxBufferedTouches = 512;

  // --- Live state ----------------------------------------------------------

  _Phase _phase = _Phase.countdown;
  double _sessionMs = 0;
  double _phaseMs = 0;
  int _countdownShown = -1;
  bool _endRequested = false;

  int _trialIndex = -1;
  TrialConfiguration? _currentConfig;
  int? _currentPathSeed;
  Vec2 _currentUnitPos = Vec2.zero;
  Vec2 _spawnUnitPos = Vec2.zero;
  double _spawnMs = 0;
  double _becameTouchableMs = 0;
  bool _targetHit = false;
  int _trialMissCount = 0;
  int? _reactionMs;
  int? _firstCatchMs;
  CueType? _trialCue;
  CueType? _trialPraise;
  bool _trialRewardReminderShown = false;
  bool _lastTrialEndedInCapture = false;
  bool _nextTrialEasier = false;
  double _cueDelayTargetMs = 0;

  final List<TrialConfiguration> _history = [];
  final List<TouchRecord> _trialTouches = [];
  final List<TrialRecord> _trials = [];
  int _difficulty = 0;
  int _consecutiveHighFrustrationTrials = 0;

  // Reward reminders.
  int _remindersShown = 0;
  int _catchesTowardsReward = 0;
  int _nextVariableThreshold = 0;

  bool get isEnded => _phase == _Phase.ended;
  int get sessionMs => _sessionMs.round();
  int get difficulty => _difficulty;
  List<TrialRecord> get trials => List.unmodifiable(_trials);
  int get bufferedTouchCount => _trialTouches.length;

  /// Target snapshot for the touch classifier, logical pixels.
  TargetSnapshot? get currentTargetSnapshot {
    final config = _currentConfig;
    if (config == null) return null;
    return TargetSnapshot(
      centreX: _currentUnitPos.x * _unitPx,
      centreY: _currentUnitPos.y * _unitPx,
      hitboxRadius: _hitboxRadiusPx(config),
      active:
          _phase == _Phase.targetActive &&
          !_targetHit &&
          _sessionMs >= _becameTouchableMs,
    );
  }

  // --- Lifecycle -----------------------------------------------------------

  void start() {
    _difficulty = plan.initialDifficulty;
    _nextVariableThreshold = 2 + rng.nextInt(4); // 2..5
    disengagement.start(0);
    if (plan.mode == SessionMode.touchTraining &&
        audio.hasCue(CueType.catName)) {
      // Greeting by name primes attention before the first cue trial.
      audio.playCue(CueType.catName).ignore();
    }
  }

  /// Advances the session clock. Call from the game loop with seconds.
  void update(double dt) {
    if (_phase == _Phase.ended) return;
    final dtMs = dt * 1000;
    _sessionMs += dtMs;
    _phaseMs += dtMs;

    // Session duration cap applies in every phase.
    if (_sessionMs >= plan.plannedDurationSeconds * 1000 && !_endRequested) {
      _end(SessionStatus.completed);
      return;
    }

    switch (_phase) {
      case _Phase.countdown:
        final remaining = tuning.countdownSeconds - (_sessionMs / 1000).floor();
        if (remaining != _countdownShown && remaining > 0) {
          _countdownShown = remaining;
          delegate.onCountdownTick(remaining);
        }
        if (_sessionMs >= tuning.countdownSeconds * 1000) {
          disengagement.start(_sessionMs.round());
          _beginTrial();
        }
      case _Phase.cuePlaying:
        break; // waiting for the cue future to complete
      case _Phase.cueDelay:
        if (_phaseMs >= _cueDelayTargetMs) _spawnTarget();
      case _Phase.targetActive:
        if (!_targetHit &&
            _sessionMs - _becameTouchableMs >= tuning.trialTimeoutMs) {
          _onTimeout();
        } else {
          _pollHold();
          _pollDisengagement();
        }
      case _Phase.interTrial:
        _pollDisengagement();
        if (_phase == _Phase.interTrial &&
            _phaseMs >= tuning.interTrialDelayMs) {
          _beginTrial();
        }
      case _Phase.ended:
        break;
    }
  }

  /// Raw pointer-down from the play screen's Listener.
  void handlePointerDown(int pointerId, double x, double y) {
    if (_phase == _Phase.ended || _phase == _Phase.countdown) return;
    final nowMs = _sessionMs.round();
    final classified = processor.process(
      RawPointerDown(pointerId: pointerId, timestampMs: nowMs, x: x, y: y),
      target: currentTargetSnapshot,
      inPostCaptureWindow:
          _phase == _Phase.interTrial && _lastTrialEndedInCapture,
    );
    _recordTouch(classified, nowMs);

    switch (classified.classification) {
      case TouchClassification.hit:
        _onCatch(nowMs);
      case TouchClassification.miss:
        _trialMissCount++;
        final config = _currentConfig;
        final distance = classified.distanceFromTarget;
        final distanceFromEdge = (distance == null || config == null)
            ? null
            : distance - _hitboxRadiusPx(config) / _unitPx;
        frustration.onMiss(nowMs, distanceFromTargetEdge: distanceFromEdge);
        disengagement.onMeaningfulInteraction(nowMs);
      case TouchClassification.edge:
        frustration.onEdgeTouch(nowMs);
        disengagement.onMeaningfulInteraction(nowMs);
      case TouchClassification.postCapture:
        frustration.onPostCaptureTouch(nowMs);
        disengagement.onMeaningfulInteraction(nowMs);
      case TouchClassification.ownerGesture:
        break; // never counts towards cat metrics
      case TouchClassification.ignoredDuplicate:
        break;
    }
  }

  void handlePointerUp(int pointerId) {
    final nowMs = _sessionMs.round();
    final heldMs = processor.registerPointerUp(pointerId, nowMs);
    if (heldMs >= tuning.longHoldMs) {
      frustration.onHold(nowMs, heldMs);
    }
  }

  /// Owner exit gesture confirmed through the owner gate.
  void ownerRequestedEnd() => _end(SessionStatus.ownerStopped);

  /// App moved to background mid-session.
  void appBackgrounded() {
    if (_phase != _Phase.ended) _end(SessionStatus.backgrounded);
  }

  /// Game loop reports the target's live position (unit space) each frame
  /// so hit-testing tracks the moving prey.
  void reportTargetPosition(Vec2 unitPosition) {
    _currentUnitPos = unitPosition;
  }

  // --- Trial lifecycle -----------------------------------------------------

  void _beginTrial() {
    // No time for a meaningful trial? End as completed.
    final remainingMs = plan.plannedDurationSeconds * 1000 - _sessionMs;
    if (remainingMs < 2000) {
      _end(SessionStatus.completed);
      return;
    }
    final remaining = trialSource.remainingTrials;
    if (remaining != null && remaining <= 0) {
      _end(SessionStatus.completed);
      return;
    }

    _trialIndex++;
    TrialConfiguration config;
    if (_nextTrialEasier) {
      _nextTrialEasier = false;
      config = trialSource.easier(history: _history);
    } else {
      config = trialSource.next(difficulty: _difficulty, history: _history);
    }
    // Edge-burst adaptation: pull placement to the centre while the cat is
    // hammering the bezel.
    if (frustration
        .activeFlags(_sessionMs.round())
        .contains(FrustrationFlag.edgeBurst)) {
      config = config.copyWith(spawnZone: SpawnZone.centre);
    }
    assert(
      constraints.allows(config),
      'trial sources must respect safety constraints',
    );
    _currentConfig = config;
    _history.add(config);
    _targetHit = false;
    _trialMissCount = 0;
    _reactionMs = null;
    _firstCatchMs = null;
    _trialPraise = null;
    _trialRewardReminderShown = false;
    _trialCue = null;

    if (plan.mode == SessionMode.touchTraining && audio.hasCue(CueType.touch)) {
      _trialCue = CueType.touch;
      _setPhase(_Phase.cuePlaying);
      audio.playCue(CueType.touch).whenComplete(() {
        if (_phase != _Phase.cuePlaying) return;
        _cueDelayTargetMs = rng
            .nextDoubleInRange(
              tuning.cueDelayMinMs.toDouble(),
              tuning.cueDelayMaxMs.toDouble(),
            )
            .floorToDouble();
        _setPhase(_Phase.cueDelay);
      });
    } else {
      _spawnTarget();
    }
  }

  void _spawnTarget() {
    final config = _currentConfig!;
    _currentPathSeed = rng.nextInt64();
    _spawnUnitPos = _spawnPointFor(config);
    _currentUnitPos = _spawnUnitPos;
    _spawnMs = _sessionMs;
    _becameTouchableMs = _sessionMs + tuning.targetSpawnInMs;
    _setPhase(_Phase.targetActive);

    delegate.onSpawnTarget(
      configuration: config,
      pathSeed: _currentPathSeed!,
      unitPosition: _spawnUnitPos,
      diameterPx: tuning.sizeFraction(config.sizeLevel) * _unitPx,
    );
    if (_soundAllowedForTrial(config)) {
      audio.playEffect(SessionEffect.preyVoice, prey: config.preyType);
    }
  }

  void _onCatch(int nowMs) {
    if (_targetHit || _phase != _Phase.targetActive) return;
    _targetHit = true; // one catch per target, enforced synchronously
    _firstCatchMs = nowMs;
    _reactionMs = math.max(0, nowMs - _becameTouchableMs.round());
    frustration.onCatch(nowMs);
    disengagement.onMeaningfulInteraction(nowMs);
    delegate.onTargetCaptured();

    final config = _currentConfig!;
    if (_soundAllowedForTrial(config)) {
      audio.playEffect(SessionEffect.capturePop);
    }
    // Praise: owner recording when available, subtle chime otherwise.
    final praiseOptions = [
      if (audio.hasCue(CueType.good)) CueType.good,
      if (audio.hasCue(CueType.goodJob)) CueType.goodJob,
    ];
    if (praiseOptions.isNotEmpty) {
      _trialPraise = praiseOptions[rng.nextInt(praiseOptions.length)];
      audio.playCue(_trialPraise!).ignore();
    } else if (_soundAllowedForTrial(config)) {
      audio.playEffect(SessionEffect.successChime);
    }

    _maybeRemindReward();
    _finaliseTrial(success: true, timedOut: false);
    _lastTrialEndedInCapture = true;
    // Finalisation can end the session (frustration policy); never clobber
    // a terminal phase.
    if (_phase != _Phase.ended) _setPhase(_Phase.interTrial);
  }

  void _onTimeout() {
    frustration.onTrialTimeout(_sessionMs.round());
    delegate.onTargetExpired();
    _finaliseTrial(success: false, timedOut: true);
    _lastTrialEndedInCapture = false;
    if (_phase != _Phase.ended) _setPhase(_Phase.interTrial);
  }

  void _finaliseTrial({required bool success, required bool timedOut}) {
    final config = _currentConfig;
    if (config == null) return;
    final nowMs = _sessionMs.round();
    final (flags, severity) = frustration.collectTrialFlags(nowMs);

    final record = TrialRecord(
      trialIndex: _trialIndex,
      configuration: config,
      spawnedAtMs: _spawnMs.round(),
      becameTouchableAtMs: _becameTouchableMs.round(),
      endedAtMs: nowMs,
      spawnXNormalised: (_spawnUnitPos.x * _unitPx / screenWidth).clamp(
        0.0,
        1.0,
      ),
      spawnYNormalised: (_spawnUnitPos.y * _unitPx / screenHeight).clamp(
        0.0,
        1.0,
      ),
      pathSeed: _currentPathSeed ?? 0,
      success: success,
      firstSuccessfulTouchAtMs: _firstCatchMs,
      reactionTimeMs: _reactionMs,
      missCount: _trialMissCount,
      timedOut: timedOut,
      cueType: _trialCue,
      praiseCueType: _trialPraise,
      rewardReminderShown: _trialRewardReminderShown,
      frustrationSeverity: severity,
      frustrationFlags: flags,
      difficultyAtTrial: _difficulty,
    );
    _trials.add(record);
    delegate.onTrialFinalised(record, List.of(_trialTouches));
    _trialTouches.clear();
    _currentConfig = null;

    if (record.isValidForLearning) {
      trialSource.onTrialOutcome(record);
      _difficulty = trialSource.difficultyOverride ?? _difficulty;
      _applyFrustrationPolicy(record);
    }
  }

  void _applyFrustrationPolicy(TrialRecord record) {
    if (record.frustrationSeverity >= 2) {
      _consecutiveHighFrustrationTrials++;
      // Immediate relief regardless of the difficulty controller: the next
      // trial is the easy configuration.
      _nextTrialEasier = true;
    } else {
      _consecutiveHighFrustrationTrials = 0;
    }
    if (_consecutiveHighFrustrationTrials >= 2) {
      _end(SessionStatus.frustrated);
    }
  }

  void _pollDisengagement() {
    switch (disengagement.poll(_sessionMs.round())) {
      case DisengagementAction.none:
        break;
      case DisengagementAction.attentionNudge:
        delegate.onAttentionNudge();
        if (plan.soundEnabled && constraints.soundAllowed) {
          audio.playEffect(SessionEffect.attention);
        }
      case DisengagementAction.easierTarget:
        _nextTrialEasier = true;
        if (_phase == _Phase.targetActive) {
          // Quietly retire the ignored target and bring on the easy one.
          delegate.onTargetExpired();
          _finaliseTrial(success: false, timedOut: false);
          _lastTrialEndedInCapture = false;
          if (_phase != _Phase.ended) _setPhase(_Phase.interTrial);
        }
      case DisengagementAction.endSession:
        _end(SessionStatus.disengaged);
    }
  }

  void _pollHold() {
    final nowMs = _sessionMs.round();
    final held = processor.longestActiveHoldMs(nowMs);
    if (held >= tuning.longHoldMs) {
      frustration.onHold(nowMs, held);
    }
  }

  void _maybeRemindReward() {
    if (_remindersShown >= plan.maxRewardReminders) return;
    _catchesTowardsReward++;
    final due = switch (plan.rewardSchedule) {
      RewardSchedule.none || RewardSchedule.manualOnly => false,
      RewardSchedule.everyThreeCatches => _catchesTowardsReward >= 3,
      RewardSchedule.variableTwoToFive =>
        _catchesTowardsReward >= _nextVariableThreshold,
    };
    if (due) {
      _catchesTowardsReward = 0;
      _nextVariableThreshold = 2 + rng.nextInt(4);
      _remindersShown++;
      _trialRewardReminderShown = true;
      delegate.onRewardReminder();
    }
  }

  void _end(SessionStatus status) {
    if (_phase == _Phase.ended || _endRequested) return;
    _endRequested = true;
    // Finalise any in-flight trial as cut short (kept as raw history, not
    // used for learning).
    if (_currentConfig != null) {
      delegate.onTargetExpired();
      _finaliseTrial(success: false, timedOut: false);
    }
    _setPhase(_Phase.ended);
    if (audio.hasCue(CueType.allDone)) {
      audio.playCue(CueType.allDone).ignore();
    }
    delegate.onSessionEnded(_summary(status));
  }

  SessionSummary _summary(SessionStatus status) {
    final valid = _trials.where((t) => t.isValidForLearning).toList();
    final reactions = valid
        .where((t) => t.success && t.reactionTimeMs != null)
        .map((t) => t.reactionTimeMs!);
    return SessionSummary(
      status: status,
      actualDurationMs: _sessionMs.round(),
      catches: _trials.where((t) => t.success).length,
      misses: _trials.fold(0, (sum, t) => sum + t.missCount),
      timeouts: _trials.where((t) => t.timedOut).length,
      medianReactionMs: medianInt(reactions),
      frustrationCount: valid.where((t) => t.frustrationSeverity >= 1).length,
      endDifficulty: _difficulty,
    );
  }

  // --- Helpers -------------------------------------------------------------

  void _recordTouch(ClassifiedTouch touch, int nowMs) {
    if (_trialTouches.length >= _maxBufferedTouches) {
      // Pathological input rates: drop the oldest rather than grow without
      // bound. Trial boundaries flush long before this in practice.
      _trialTouches.removeAt(0);
    }
    _trialTouches.add(
      TouchRecord(
        trialIndex: _currentConfig == null ? null : _trialIndex,
        pointerId: touch.raw.pointerId,
        logicalInteractionId: touch.logicalId,
        occurredAtMs: nowMs,
        xNormalised: touch.xNormalised,
        yNormalised: touch.yNormalised,
        classification: touch.classification,
        deduplicated: touch.isDuplicate,
        distanceFromTarget: touch.distanceFromTarget,
      ),
    );
  }

  double _hitboxRadiusPx(TrialConfiguration config) {
    final visual = tuning.sizeFraction(config.sizeLevel) * _unitPx / 2;
    final inflated = visual * tuning.hitboxInflationFactor;
    final minimum = tuning.minHitboxDiameterFraction * _unitPx / 2;
    return math.max(inflated, minimum);
  }

  bool _soundAllowedForTrial(TrialConfiguration config) =>
      plan.soundEnabled &&
      constraints.soundAllowed &&
      config.soundMode == SoundMode.sound;

  /// Uniform point inside the requested zone of the safe area (unit space).
  Vec2 _spawnPointFor(TrialConfiguration config) {
    final radiusUnits = tuning.sizeFraction(config.sizeLevel) / 2;
    final bounds = safeBounds(radiusUnits);
    final zone = zoneRect(config.spawnZone, bounds);
    final trialRng = SeededRandom(_currentPathSeed!);
    return Vec2(
      trialRng.nextDoubleInRange(zone.minX, zone.maxX),
      trialRng.nextDoubleInRange(zone.minY, zone.maxY),
    );
  }

  /// Safe movement bounds in unit space for a target of [radiusUnits].
  Bounds2 safeBounds(double radiusUnits) {
    final w = screenWidth / _unitPx;
    final h = screenHeight / _unitPx;
    final mx = w * tuning.safeMarginFraction + radiusUnits;
    final my = h * tuning.safeMarginFraction + radiusUnits;
    return Bounds2(mx, my, w - mx, h - my);
  }

  /// Zone sub-rectangles of the safe bounds.
  static Bounds2 zoneRect(SpawnZone zone, Bounds2 b) {
    final w = b.width;
    final h = b.height;
    return switch (zone) {
      SpawnZone.centre => Bounds2(
        b.minX + w * 0.28,
        b.minY + h * 0.28,
        b.maxX - w * 0.28,
        b.maxY - h * 0.28,
      ),
      SpawnZone.top => Bounds2(b.minX, b.minY, b.maxX, b.minY + h * 0.3),
      SpawnZone.bottom => Bounds2(b.minX, b.maxY - h * 0.3, b.maxX, b.maxY),
      SpawnZone.left => Bounds2(b.minX, b.minY, b.minX + w * 0.3, b.maxY),
      SpawnZone.right => Bounds2(b.maxX - w * 0.3, b.minY, b.maxX, b.maxY),
    };
  }

  void _setPhase(_Phase phase) {
    _phase = phase;
    _phaseMs = 0;
  }
}
