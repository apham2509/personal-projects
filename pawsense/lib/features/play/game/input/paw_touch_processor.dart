import 'dart:math' as math;

import '../../../../shared/models/enums.dart';
import '../../domain/play_tuning.dart';
import '../../domain/touch_models.dart';
import 'touch_clusterer.dart';

/// Snapshot of the current target the classifier needs, in logical pixels.
class TargetSnapshot {
  const TargetSnapshot({
    required this.centreX,
    required this.centreY,
    required this.hitboxRadius,
    required this.active,
  });

  final double centreX;
  final double centreY;

  /// Inflated, minimum-enforced touch radius (not the visual radius).
  final double hitboxRadius;

  /// False between capture/timeout and the next spawn.
  final bool active;
}

/// Clusters and classifies raw paw contacts. Pure Dart, deterministic, no
/// Flutter/Flame dependencies; the play screen feeds it pointer events and
/// the session runner consumes classified results.
///
/// Classification precedence (first match wins):
/// 1. ignoredDuplicate — merged into a recent logical interaction
/// 2. hit — active target and inside the hitbox
/// 3. ownerGesture — inside a top-corner exit zone (excluded from misses)
/// 4. postCapture — between a capture and the next spawn
/// 5. edge — within the outer margin of the screen
/// 6. miss
///
/// `hit` outranks `ownerGesture` so a target legitimately roaming near a top
/// corner still registers catches; the exit gesture itself requires a
/// two-second simultaneous hold tracked separately (OwnerExitTracker).
class PawTouchProcessor {
  PawTouchProcessor({
    required this.tuning,
    required this.screenWidth,
    required this.screenHeight,
  }) : _clusterer = TouchClusterer(
         windowMs: tuning.clusterWindowMs,
         radiusPx:
             tuning.clusterRadiusFraction * math.min(screenWidth, screenHeight),
       ),
       _shortest = math.min(screenWidth, screenHeight);

  final PlayTuning tuning;
  final double screenWidth;
  final double screenHeight;

  final TouchClusterer _clusterer;
  final double _shortest;

  /// Active (down, not yet up) pointers: id -> down timestamp ms.
  final Map<int, int> _activePointers = {};

  ClassifiedTouch process(
    RawPointerDown raw, {
    required TargetSnapshot? target,
    required bool inPostCaptureWindow,
  }) {
    _activePointers[raw.pointerId] = raw.timestampMs;

    final cluster = _clusterer.register(raw);
    final xNorm = (raw.x / screenWidth).clamp(0.0, 1.0);
    final yNorm = (raw.y / screenHeight).clamp(0.0, 1.0);

    double? distance;
    if (target != null) {
      final dx = raw.x - target.centreX;
      final dy = raw.y - target.centreY;
      distance = math.sqrt(dx * dx + dy * dy) / _shortest;
    }

    TouchClassification classification;
    if (!cluster.isNew) {
      classification = TouchClassification.ignoredDuplicate;
    } else if (target != null &&
        target.active &&
        distance! * _shortest <= target.hitboxRadius) {
      classification = TouchClassification.hit;
    } else if (_inOwnerCorner(raw.x, raw.y)) {
      classification = TouchClassification.ownerGesture;
    } else if (inPostCaptureWindow) {
      classification = TouchClassification.postCapture;
    } else if (_inEdgeMargin(raw.x, raw.y)) {
      classification = TouchClassification.edge;
    } else {
      classification = TouchClassification.miss;
    }

    return ClassifiedTouch(
      raw: raw,
      logicalId: cluster.interaction.logicalId,
      isDuplicate: !cluster.isNew,
      classification: classification,
      xNormalised: xNorm,
      yNormalised: yNorm,
      distanceFromTarget: distance,
    );
  }

  /// Registers a pointer lift; returns the hold duration in ms so callers
  /// can raise a long-hold frustration signal when it exceeds the threshold.
  int registerPointerUp(int pointerId, int timestampMs) {
    final downAt = _activePointers.remove(pointerId);
    if (downAt == null) return 0;
    return timestampMs - downAt;
  }

  /// Longest currently-held pointer duration (for hold detection while the
  /// paw is still down).
  int longestActiveHoldMs(int nowMs) {
    var longest = 0;
    for (final downAt in _activePointers.values) {
      final held = nowMs - downAt;
      if (held > longest) longest = held;
    }
    return longest;
  }

  int get activePointerCount => _activePointers.length;

  bool _inEdgeMargin(double x, double y) {
    final mx = screenWidth * tuning.safeMarginFraction;
    final my = screenHeight * tuning.safeMarginFraction;
    return x < mx || x > screenWidth - mx || y < my || y > screenHeight - my;
  }

  bool _inOwnerCorner(double x, double y) {
    final cw = screenWidth * tuning.ownerExitCornerFraction;
    final ch = screenHeight * tuning.ownerExitCornerFraction;
    final top = y < ch;
    return top && (x < cw || x > screenWidth - cw);
  }
}
