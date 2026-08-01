import '../../../shared/models/enums.dart';

/// A raw pointer-down contact in logical pixels (as delivered by Flutter).
class RawPointerDown {
  const RawPointerDown({
    required this.pointerId,
    required this.timestampMs,
    required this.x,
    required this.y,
  });

  final int pointerId;

  /// Milliseconds on the session's monotonic clock.
  final int timestampMs;
  final double x;
  final double y;
}

/// One deduplicated paw interaction (a cluster of near-simultaneous raw
/// contacts — several paw pads landing together count once).
class LogicalPawInteraction {
  LogicalPawInteraction({
    required this.logicalId,
    required this.firstTimestampMs,
    required this.x,
    required this.y,
  }) : rawContactCount = 1;

  final int logicalId;
  final int firstTimestampMs;

  /// Anchor position (first contact of the cluster), logical pixels.
  final double x;
  final double y;
  int rawContactCount;
}

/// Result of pushing one raw contact through the clusterer.
class ClusterResult {
  const ClusterResult({required this.interaction, required this.isNew});

  final LogicalPawInteraction interaction;

  /// False when the contact was merged into an existing interaction
  /// (i.e. it is a duplicate for gameplay purposes).
  final bool isNew;
}

/// A classified touch ready for persistence and live decision-making.
class ClassifiedTouch {
  const ClassifiedTouch({
    required this.raw,
    required this.logicalId,
    required this.isDuplicate,
    required this.classification,
    required this.xNormalised,
    required this.yNormalised,
    required this.distanceFromTarget,
  });

  final RawPointerDown raw;
  final int logicalId;
  final bool isDuplicate;
  final TouchClassification classification;
  final double xNormalised;
  final double yNormalised;

  /// Distance from the active target centre in shortest-dimension units;
  /// null when no target was active at the time of the touch.
  final double? distanceFromTarget;
}
