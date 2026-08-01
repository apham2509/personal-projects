import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/features/play/domain/play_tuning.dart';
import 'package:pawsense/features/play/game/input/owner_exit_tracker.dart';

void main() {
  const width = 1200.0;
  const height = 800.0;
  // Corner zones: x < 216 or x > 984, y < 144 (18% of each dimension).

  OwnerExitTracker build() => OwnerExitTracker(
    tuning: defaultPlayTuning,
    screenWidth: width,
    screenHeight: height,
  );

  test('simultaneous two-corner hold for 2 s triggers', () {
    final tracker = build();
    tracker.pointerDown(1, 50, 50, 0);
    tracker.pointerDown(2, 1150, 50, 100);
    expect(tracker.isTriggered(1000), isFalse);
    expect(tracker.progress(1100), closeTo(0.5, 0.01));
    expect(tracker.isTriggered(2100), isTrue);
  });

  test('one corner alone never triggers', () {
    final tracker = build();
    tracker.pointerDown(1, 50, 50, 0);
    expect(tracker.isTriggered(60000), isFalse);
  });

  test('two pointers in the SAME corner never trigger', () {
    final tracker = build();
    tracker.pointerDown(1, 50, 50, 0);
    tracker.pointerDown(2, 120, 80, 0);
    expect(tracker.isTriggered(60000), isFalse);
  });

  test('releasing one corner resets the clock', () {
    final tracker = build();
    tracker.pointerDown(1, 50, 50, 0);
    tracker.pointerDown(2, 1150, 50, 0);
    tracker.pointerUpOrCancel(2, 1500);
    tracker.pointerDown(3, 1150, 50, 1600);
    expect(
      tracker.isTriggered(2500),
      isFalse,
      reason: 'the 2 s must be continuous',
    );
    expect(tracker.isTriggered(3600), isTrue);
  });

  test('dragging out of the corner breaks the hold', () {
    final tracker = build();
    tracker.pointerDown(1, 50, 50, 0);
    tracker.pointerDown(2, 1150, 50, 0);
    tracker.pointerMove(2, 600, 400, 800); // slid to centre
    expect(tracker.isTriggered(2500), isFalse);
  });

  test('centre touches are irrelevant to the tracker', () {
    final tracker = build();
    tracker.pointerDown(1, 600, 400, 0);
    tracker.pointerDown(2, 640, 420, 0);
    expect(tracker.bothCornersHeld, isFalse);
  });

  test('reset clears everything', () {
    final tracker = build();
    tracker.pointerDown(1, 50, 50, 0);
    tracker.pointerDown(2, 1150, 50, 0);
    tracker.reset();
    expect(tracker.isTriggered(60000), isFalse);
  });
}
