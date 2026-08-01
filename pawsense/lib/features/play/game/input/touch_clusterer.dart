import '../../domain/touch_models.dart';

/// Merges near-simultaneous, near-identical raw contacts into logical paw
/// interactions.
///
/// A cat pressing one paw down often produces several pointer events (pads
/// and toes land within a few dozen milliseconds and millimetres). Two raw
/// contacts belong to the same logical interaction when they occur within
/// [windowMs] AND within [radiusPx] of the interaction's anchor point.
///
/// Pure and deterministic; operates in logical pixels (see DECISIONS.md
/// D-006 for why not normalised coordinates).
class TouchClusterer {
  TouchClusterer({required this.windowMs, required this.radiusPx});

  final int windowMs;
  final double radiusPx;

  final List<LogicalPawInteraction> _recent = [];
  int _nextLogicalId = 1;

  /// Registers a raw contact, returning the logical interaction it belongs
  /// to and whether that interaction is new.
  ClusterResult register(RawPointerDown raw) {
    _prune(raw.timestampMs);
    for (final interaction in _recent) {
      final dx = raw.x - interaction.x;
      final dy = raw.y - interaction.y;
      final withinRadius = dx * dx + dy * dy <= radiusPx * radiusPx;
      final withinWindow =
          raw.timestampMs - interaction.firstTimestampMs <= windowMs;
      if (withinRadius && withinWindow) {
        interaction.rawContactCount++;
        return ClusterResult(interaction: interaction, isNew: false);
      }
    }
    final interaction = LogicalPawInteraction(
      logicalId: _nextLogicalId++,
      firstTimestampMs: raw.timestampMs,
      x: raw.x,
      y: raw.y,
    );
    _recent.add(interaction);
    return ClusterResult(interaction: interaction, isNew: true);
  }

  void _prune(int nowMs) {
    _recent.removeWhere((i) => nowMs - i.firstTimestampMs > windowMs);
  }

  /// Total logical interactions created (diagnostics/tests).
  int get logicalInteractionCount => _nextLogicalId - 1;

  void reset() {
    _recent.clear();
  }
}
