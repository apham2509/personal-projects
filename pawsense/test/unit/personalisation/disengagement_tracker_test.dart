import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/features/personalisation/domain/disengagement_tracker.dart';

void main() {
  DisengagementTracker build() => DisengagementTracker(
    attentionNudgeAfterMs: 12000,
    easierTargetAfterMs: 20000,
    endAfterMs: 30000,
  );

  test('stages fire in order at 12 s, 20 s, 30 s of idleness', () {
    final tracker = build()..start(0);
    expect(tracker.poll(11999), DisengagementAction.none);
    expect(tracker.poll(12000), DisengagementAction.attentionNudge);
    expect(
      tracker.poll(12100),
      DisengagementAction.none,
      reason: 'nudge fires once per idle streak',
    );
    expect(tracker.poll(20000), DisengagementAction.easierTarget);
    expect(tracker.poll(20100), DisengagementAction.none);
    expect(tracker.poll(30000), DisengagementAction.endSession);
  });

  test('meaningful interaction resets the whole ladder', () {
    final tracker = build()..start(0);
    expect(tracker.poll(12000), DisengagementAction.attentionNudge);
    tracker.onMeaningfulInteraction(15000);
    expect(tracker.poll(26000), DisengagementAction.none);
    expect(tracker.poll(27000), DisengagementAction.attentionNudge);
    expect(tracker.poll(35000), DisengagementAction.easierTarget);
    expect(tracker.poll(45000), DisengagementAction.endSession);
  });

  test('idleMs tracks since last interaction', () {
    final tracker = build()..start(1000);
    tracker.onMeaningfulInteraction(5000);
    expect(tracker.idleMs(9000), 4000);
  });
}
