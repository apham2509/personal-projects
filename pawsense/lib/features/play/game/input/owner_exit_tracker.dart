import '../../domain/play_tuning.dart';

/// Detects the owner exit gesture: at least one pointer held in *each* top
/// corner simultaneously for [PlayTuning.ownerExitHoldMs].
///
/// Cats defeat this by construction: a single paw cannot hold two zones a
/// screen-width apart, and casual double-paw taps do not sustain a
/// two-second simultaneous hold. Pure Dart and fully unit-tested.
class OwnerExitTracker {
  OwnerExitTracker({
    required this.tuning,
    required this.screenWidth,
    required this.screenHeight,
  });

  final PlayTuning tuning;
  final double screenWidth;
  final double screenHeight;

  final Set<int> _leftCornerPointers = {};
  final Set<int> _rightCornerPointers = {};

  /// Timestamp when both corners first became simultaneously held.
  int? _bothHeldSinceMs;

  void pointerDown(int pointerId, double x, double y, int timestampMs) {
    final corner = _cornerFor(x, y);
    if (corner == _Corner.left) _leftCornerPointers.add(pointerId);
    if (corner == _Corner.right) _rightCornerPointers.add(pointerId);
    _updateHold(timestampMs);
  }

  /// Pointer moved: if it leaves its corner, the hold breaks.
  void pointerMove(int pointerId, double x, double y, int timestampMs) {
    final corner = _cornerFor(x, y);
    if (corner != _Corner.left) _leftCornerPointers.remove(pointerId);
    if (corner != _Corner.right) _rightCornerPointers.remove(pointerId);
    if (corner == _Corner.left) _leftCornerPointers.add(pointerId);
    if (corner == _Corner.right) _rightCornerPointers.add(pointerId);
    _updateHold(timestampMs);
  }

  void pointerUpOrCancel(int pointerId, int timestampMs) {
    _leftCornerPointers.remove(pointerId);
    _rightCornerPointers.remove(pointerId);
    _updateHold(timestampMs);
  }

  /// True once the simultaneous hold has lasted long enough. Callers check
  /// this on a ticker (every frame is fine).
  bool isTriggered(int nowMs) {
    final since = _bothHeldSinceMs;
    return since != null && nowMs - since >= tuning.ownerExitHoldMs;
  }

  /// 0..1 progress towards triggering, for a subtle owner-facing affordance.
  double progress(int nowMs) {
    final since = _bothHeldSinceMs;
    if (since == null) return 0;
    return ((nowMs - since) / tuning.ownerExitHoldMs).clamp(0.0, 1.0);
  }

  bool get bothCornersHeld => _bothHeldSinceMs != null;

  void reset() {
    _leftCornerPointers.clear();
    _rightCornerPointers.clear();
    _bothHeldSinceMs = null;
  }

  void _updateHold(int timestampMs) {
    final both =
        _leftCornerPointers.isNotEmpty && _rightCornerPointers.isNotEmpty;
    if (both) {
      _bothHeldSinceMs ??= timestampMs;
    } else {
      _bothHeldSinceMs = null;
    }
  }

  _Corner? _cornerFor(double x, double y) {
    final cw = screenWidth * tuning.ownerExitCornerFraction;
    final ch = screenHeight * tuning.ownerExitCornerFraction;
    if (y >= ch) return null;
    if (x < cw) return _Corner.left;
    if (x > screenWidth - cw) return _Corner.right;
    return null;
  }
}

enum _Corner { left, right }
