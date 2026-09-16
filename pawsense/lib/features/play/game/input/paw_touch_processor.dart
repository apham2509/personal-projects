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
    this.targetId = 0,
  });

  final double centreX;
  final double centreY;

  /// Inflated, minimum-enforced touch radius (not the visual radius).
  final double hitboxRadius;

  /// False between capture/timeout and the next spawn.
  final bool active;

  /// Session-local trial identity. A held paw cannot claim a later target.
  final int targetId;
}

/// Clusters and classifies raw paw contacts. Pure Dart, deterministic, no
/// Flutter/Flame dependencies; the play screen feeds it pointer events and
/// the session runner consumes classified results.
///
/// Classification precedence (first match wins):
/// 1. hit — active target and inside the hitbox, unless the paw already caught
/// 2. ignoredDuplicate — merged into a recent logical interaction
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

  final Map<int, _ActiveContact> _activePointers = {};
  final Map<int, int> _caughtInteractions = {};

  ClassifiedTouch process(
    RawPointerDown raw, {
    required TargetSnapshot? target,
    required bool inPostCaptureWindow,
  }) {
    final cluster = _clusterer.register(raw);
    _pruneCaughtInteractions(raw.timestampMs);
    final xNorm = (raw.x / screenWidth).clamp(0.0, 1.0);
    final yNorm = (raw.y / screenHeight).clamp(0.0, 1.0);

    double? distance;
    if (target != null) {
      final dx = raw.x - target.centreX;
      final dy = raw.y - target.centreY;
      distance = math.sqrt(dx * dx + dy * dy) / _shortest;
    }

    TouchClassification classification;
    if (target != null &&
        target.active &&
        !_caughtInteractions.containsKey(cluster.interaction.logicalId) &&
        distance! * _shortest <= target.hitboxRadius) {
      classification = TouchClassification.hit;
      _caughtInteractions[cluster.interaction.logicalId] = raw.timestampMs;
    } else if (!cluster.isNew) {
      classification = TouchClassification.ignoredDuplicate;
    } else if (_inOwnerCorner(raw.x, raw.y)) {
      classification = TouchClassification.ownerGesture;
    } else if (inPostCaptureWindow) {
      classification = TouchClassification.postCapture;
    } else if (_inEdgeMargin(raw.x, raw.y)) {
      classification = TouchClassification.edge;
    } else {
      classification = TouchClassification.miss;
    }

    final ownerContact =
        _inOwnerCorner(raw.x, raw.y) &&
        classification != TouchClassification.hit;
    _activePointers[raw.pointerId] = _ActiveContact(
      downAtMs: raw.timestampMs,
      logicalId: cluster.interaction.logicalId,
      x: raw.x,
      y: raw.y,
      targetId: target != null && target.active && !ownerContact
          ? target.targetId
          : null,
      ownerContact: ownerContact,
    );

    return ClassifiedTouch(
      raw: raw,
      logicalId: cluster.interaction.logicalId,
      isDuplicate: classification == TouchClassification.ignoredDuplicate,
      classification: classification,
      xNormalised: xNorm,
      yNormalised: yNorm,
      distanceFromTarget: distance,
    );
  }

  /// Only a new catch is emitted for movement. Off-target movement updates
  /// the contact position without creating repeated misses or raw down events.
  /// Segment hit-testing catches fast swipes even when both sampled endpoints
  /// lie outside the prey. A stationary or previously caught paw does nothing.
  ClassifiedTouch? processMove(
    RawPointerMove raw, {
    required TargetSnapshot? target,
  }) {
    final contact = _activePointers[raw.pointerId];
    if (contact == null) return null;
    final fromX = contact.x;
    final fromY = contact.y;
    contact.x = raw.x;
    contact.y = raw.y;
    final dx = raw.x - fromX;
    final dy = raw.y - fromY;
    final lengthSquared = dx * dx + dy * dy;
    // Ignore subpixel contact jitter from a paw resting on the screen.
    if (lengthSquared < 0.25 ||
        target == null ||
        !target.active ||
        contact.targetId != target.targetId ||
        contact.ownerContact ||
        _caughtInteractions.containsKey(contact.logicalId)) {
      return null;
    }
    final progress =
        (((target.centreX - fromX) * dx + (target.centreY - fromY) * dy) /
                lengthSquared)
            .clamp(0.0, 1.0);
    final closestX = fromX + progress * dx;
    final closestY = fromY + progress * dy;
    final tx = closestX - target.centreX;
    final ty = closestY - target.centreY;
    if (tx * tx + ty * ty > target.hitboxRadius * target.hitboxRadius) {
      return null;
    }
    _caughtInteractions[contact.logicalId] = raw.timestampMs;
    // The recorded position is the closest point along the observed sweep;
    // its time is the movement sample time. Do not invent an interpolated time.
    return ClassifiedTouch(
      raw: raw,
      logicalId: contact.logicalId,
      isDuplicate: false,
      classification: TouchClassification.hit,
      xNormalised: (closestX / screenWidth).clamp(0.0, 1.0),
      yNormalised: (closestY / screenHeight).clamp(0.0, 1.0),
      distanceFromTarget: math.sqrt(tx * tx + ty * ty) / _shortest,
    );
  }

  /// Registers a pointer lift; returns the hold duration in ms so callers
  /// can raise a long-hold frustration signal when it exceeds the threshold.
  int registerPointerUp(int pointerId, int timestampMs) {
    final contact = _activePointers.remove(pointerId);
    _pruneCaughtInteractions(timestampMs);
    if (contact == null || contact.ownerContact) return 0;
    return timestampMs - contact.downAtMs;
  }

  /// Longest currently-held pointer duration (for hold detection while the
  /// paw is still down).
  int longestActiveHoldMs(int nowMs) {
    var longest = 0;
    for (final contact in _activePointers.values) {
      if (contact.ownerContact) continue;
      final held = nowMs - contact.downAtMs;
      if (held > longest) longest = held;
    }
    return longest;
  }

  int get activePointerCount => _activePointers.length;

  void _pruneCaughtInteractions(int nowMs) {
    final heldInteractions = _activePointers.values
        .map((c) => c.logicalId)
        .toSet();
    _caughtInteractions.removeWhere(
      (id, caughtAt) =>
          nowMs - caughtAt > tuning.clusterWindowMs &&
          !heldInteractions.contains(id),
    );
  }

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

class _ActiveContact {
  _ActiveContact({
    required this.downAtMs,
    required this.logicalId,
    required this.x,
    required this.y,
    required this.targetId,
    required this.ownerContact,
  });

  final int downAtMs;
  final int logicalId;
  double x;
  double y;
  final int? targetId;
  final bool ownerContact;
}
