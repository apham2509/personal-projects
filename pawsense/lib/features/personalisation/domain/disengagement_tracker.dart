/// Watches for a cat losing interest and staggers the response:
///
/// 1. [attentionNudge] — subtle attention movement on the current target
/// 2. [easierTarget] — spawn a larger, preferred, centre-biased target
/// 3. [endSession] — end the session as disengaged
///
/// "Meaningful interaction" = any new logical paw interaction (hit, miss,
/// edge, or post-capture — the cat is engaging even when not catching).
/// Pure Dart; thresholds injected for testability.
class DisengagementTracker {
  DisengagementTracker({
    required this.attentionNudgeAfterMs,
    required this.easierTargetAfterMs,
    required this.endAfterMs,
  }) : assert(attentionNudgeAfterMs < easierTargetAfterMs),
       assert(easierTargetAfterMs < endAfterMs);

  final int attentionNudgeAfterMs;
  final int easierTargetAfterMs;
  final int endAfterMs;

  int _lastInteractionMs = 0;
  bool _nudgeIssued = false;
  bool _easierIssued = false;

  /// Starts (or restarts) the inactivity clock, e.g. at session start.
  void start(int nowMs) {
    _lastInteractionMs = nowMs;
    _nudgeIssued = false;
    _easierIssued = false;
  }

  void onMeaningfulInteraction(int nowMs) {
    _lastInteractionMs = nowMs;
    _nudgeIssued = false;
    _easierIssued = false;
  }

  int idleMs(int nowMs) => nowMs - _lastInteractionMs;

  /// Polled every frame; returns the action to take right now (each stage
  /// fires once per idle streak).
  DisengagementAction poll(int nowMs) {
    final idle = idleMs(nowMs);
    if (idle >= endAfterMs) {
      return DisengagementAction.endSession;
    }
    if (idle >= easierTargetAfterMs && !_easierIssued) {
      _easierIssued = true;
      return DisengagementAction.easierTarget;
    }
    if (idle >= attentionNudgeAfterMs && !_nudgeIssued) {
      _nudgeIssued = true;
      return DisengagementAction.attentionNudge;
    }
    return DisengagementAction.none;
  }
}

enum DisengagementAction { none, attentionNudge, easierTarget, endSession }
