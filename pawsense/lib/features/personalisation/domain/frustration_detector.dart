import '../../../shared/models/enums.dart';

/// Thresholds for the frustration heuristics (product spec section 10).
/// All windows are milliseconds on the session's monotonic clock.
class FrustrationConfig {
  const FrustrationConfig({
    this.missBurstCount = 3,
    this.missBurstWindowMs = 2000,
    this.edgeBurstCount = 4,
    this.edgeBurstWindowMs = 3000,
    this.postCaptureBurstCount = 4,
    this.postCaptureBurstWindowMs = 1500,
    this.rapidTapCount = 10,
    this.rapidTapWindowMs = 5000,
    this.rapidTapMaxCatches = 1,
    this.longHoldMs = 2000,
    this.consecutiveTimeoutCount = 3,
    this.impossibleReachCount = 4,
    this.impossibleReachWindowMs = 10000,
    this.impossibleReachBandFraction = 0.06,
  });

  final int missBurstCount;
  final int missBurstWindowMs;
  final int edgeBurstCount;
  final int edgeBurstWindowMs;
  final int postCaptureBurstCount;
  final int postCaptureBurstWindowMs;

  /// Rapid tapping only counts as frustration when success stays low.
  final int rapidTapCount;
  final int rapidTapWindowMs;
  final int rapidTapMaxCatches;

  final int longHoldMs;
  final int consecutiveTimeoutCount;

  /// Repeated near-misses just outside the hitbox (possible hitbox problem).
  final int impossibleReachCount;
  final int impossibleReachWindowMs;

  /// Width of the near-miss band outside the hitbox edge, in
  /// shortest-dimension units.
  final double impossibleReachBandFraction;
}

/// Severity weights per flag; severity = min(3, sum of active flag weights).
const Map<FrustrationFlag, int> _flagWeights = {
  FrustrationFlag.missBurst: 1,
  FrustrationFlag.edgeBurst: 1,
  FrustrationFlag.postCaptureBurst: 1,
  FrustrationFlag.rapidTapBurst: 2,
  FrustrationFlag.longHold: 1,
  FrustrationFlag.consecutiveTimeouts: 2,
  FrustrationFlag.repeatedImpossibleReach: 2,
};

/// Pure sliding-window detector. The session runner feeds it classified
/// touches, hold durations, and trial outcomes; it answers with the flags
/// active right now and a 0-3 severity.
///
/// This is a heuristic signal for making play easier — never a welfare
/// diagnosis, and owner-facing copy must not present it as one.
class FrustrationDetector {
  FrustrationDetector({this.config = const FrustrationConfig()});

  final FrustrationConfig config;

  final List<int> _missTimes = [];
  final List<int> _edgeTimes = [];
  final List<int> _postCaptureTimes = [];
  final List<int> _logicalTouchTimes = [];
  final List<int> _catchTimes = [];
  final List<int> _nearMissTimes = [];
  int _consecutiveTimeouts = 0;
  bool _longHoldActive = false;

  /// Flags that have fired since the last [collectTrialFlags] call, so a
  /// burst that happens mid-trial is attributed to that trial even if it is
  /// no longer inside any window at trial end.
  final Set<FrustrationFlag> _sinceLastCollect = {};

  // --- Inputs -------------------------------------------------------------

  void onMiss(int nowMs, {double? distanceFromTargetEdge}) {
    _missTimes.add(nowMs);
    _logicalTouchTimes.add(nowMs);
    final d = distanceFromTargetEdge;
    if (d != null && d >= 0 && d <= config.impossibleReachBandFraction) {
      _nearMissTimes.add(nowMs);
    }
    _refresh(nowMs);
  }

  void onEdgeTouch(int nowMs) {
    _edgeTimes.add(nowMs);
    _logicalTouchTimes.add(nowMs);
    _refresh(nowMs);
  }

  void onPostCaptureTouch(int nowMs) {
    _postCaptureTimes.add(nowMs);
    _logicalTouchTimes.add(nowMs);
    _refresh(nowMs);
  }

  void onCatch(int nowMs) {
    _catchTimes.add(nowMs);
    _logicalTouchTimes.add(nowMs);
    _consecutiveTimeouts = 0;
    _nearMissTimes.clear();
    _refresh(nowMs);
  }

  void onHold(int nowMs, int heldMs) {
    if (heldMs >= config.longHoldMs) {
      _longHoldActive = true;
      _sinceLastCollect.add(FrustrationFlag.longHold);
    }
    _refresh(nowMs);
  }

  void onTrialTimeout(int nowMs) {
    _consecutiveTimeouts++;
    _refresh(nowMs);
  }

  // --- Outputs ------------------------------------------------------------

  /// Flags currently active given the sliding windows.
  Set<FrustrationFlag> activeFlags(int nowMs) {
    _prune(nowMs);
    final flags = <FrustrationFlag>{};
    if (_missTimes.length >= config.missBurstCount) {
      flags.add(FrustrationFlag.missBurst);
    }
    if (_edgeTimes.length >= config.edgeBurstCount) {
      flags.add(FrustrationFlag.edgeBurst);
    }
    if (_postCaptureTimes.length >= config.postCaptureBurstCount) {
      flags.add(FrustrationFlag.postCaptureBurst);
    }
    if (_logicalTouchTimes.length >= config.rapidTapCount &&
        _catchTimes.length <= config.rapidTapMaxCatches) {
      flags.add(FrustrationFlag.rapidTapBurst);
    }
    if (_longHoldActive) {
      flags.add(FrustrationFlag.longHold);
    }
    if (_consecutiveTimeouts >= config.consecutiveTimeoutCount) {
      flags.add(FrustrationFlag.consecutiveTimeouts);
    }
    if (_nearMissTimes.length >= config.impossibleReachCount) {
      flags.add(FrustrationFlag.repeatedImpossibleReach);
    }
    return flags;
  }

  /// 0 none, 1 mild, 2 repeated, 3 high.
  int severity(int nowMs) {
    var sum = 0;
    for (final flag in activeFlags(nowMs)) {
      sum += _flagWeights[flag]!;
    }
    return sum > 3 ? 3 : sum;
  }

  /// Returns and clears the flags accumulated during the ending trial, plus
  /// that trial's severity (union of live flags and accumulated ones).
  (Set<FrustrationFlag>, int) collectTrialFlags(int nowMs) {
    final flags = {...activeFlags(nowMs), ..._sinceLastCollect};
    var sum = 0;
    for (final flag in flags) {
      sum += _flagWeights[flag]!;
    }
    _sinceLastCollect.clear();
    _longHoldActive = false;
    return (flags, sum > 3 ? 3 : sum);
  }

  void _refresh(int nowMs) {
    // Fold currently-active flags into the per-trial accumulator.
    _sinceLastCollect.addAll(activeFlags(nowMs));
  }

  void _prune(int nowMs) {
    _missTimes.removeWhere((t) => nowMs - t > config.missBurstWindowMs);
    _edgeTimes.removeWhere((t) => nowMs - t > config.edgeBurstWindowMs);
    _postCaptureTimes.removeWhere(
      (t) => nowMs - t > config.postCaptureBurstWindowMs,
    );
    _logicalTouchTimes.removeWhere((t) => nowMs - t > config.rapidTapWindowMs);
    _catchTimes.removeWhere((t) => nowMs - t > config.rapidTapWindowMs);
    _nearMissTimes.removeWhere(
      (t) => nowMs - t > config.impossibleReachWindowMs,
    );
  }
}
