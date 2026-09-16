import '../../../shared/models/enums.dart';

/// A pointer contact sample in logical pixels (as delivered by Flutter).
/// Down contacts start paw interactions; movement samples can complete a
/// catch. Persistence records classified contact samples, not pointer kinds.
abstract class RawPointerContact {
  const RawPointerContact({
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

/// A new contact with the screen, eligible for paw-pad clustering.
class RawPointerDown extends RawPointerContact {
  const RawPointerDown({
    required super.pointerId,
    required super.timestampMs,
    required super.x,
    required super.y,
  });
}

/// Movement of an already-down contact. This never starts a new interaction.
class RawPointerMove extends RawPointerContact {
  const RawPointerMove({
    required super.pointerId,
    required super.timestampMs,
    required super.x,
    required super.y,
  });
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

  /// False when the contact was merged into an existing interaction. A later
  /// pad can still resolve that interaction's first successful catch.
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

  final RawPointerContact raw;
  final int logicalId;

  /// True for ignored contacts, false for a later pad that resolves a catch.
  final bool isDuplicate;
  final TouchClassification classification;
  final double xNormalised;
  final double yNormalised;

  /// Distance from the active target centre in shortest-dimension units;
  /// null when no target was active at the time of the touch.
  final double? distanceFromTarget;
}
