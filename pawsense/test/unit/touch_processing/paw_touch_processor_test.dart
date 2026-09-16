import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/features/play/domain/play_tuning.dart';
import 'package:pawsense/features/play/domain/touch_models.dart';
import 'package:pawsense/features/play/game/input/paw_touch_processor.dart';
import 'package:pawsense/shared/models/enums.dart';

void main() {
  const width = 1200.0;
  const height = 800.0; // shortest = 800

  PawTouchProcessor build() => PawTouchProcessor(
    tuning: defaultPlayTuning,
    screenWidth: width,
    screenHeight: height,
  );

  RawPointerDown raw(int pointer, int t, double x, double y) =>
      RawPointerDown(pointerId: pointer, timestampMs: t, x: x, y: y);

  // A medium target centred mid-screen: visual diameter 0.11*800 = 88 px,
  // hitbox radius = max(44*1.25, 0.10*800/2) = max(55, 40) = 55 px.
  const target = TargetSnapshot(
    centreX: 600,
    centreY: 400,
    hitboxRadius: 55,
    active: true,
  );

  test('touch inside the inflated hitbox classifies as hit', () {
    final processor = build();
    // 50 px from centre: outside the visual radius (44) but inside the
    // inflated hitbox (55) — inflation is what makes this a hit.
    final result = processor.process(
      raw(1, 1000, 650, 400),
      target: target,
      inPostCaptureWindow: false,
    );
    expect(result.classification, TouchClassification.hit);
    expect(result.distanceFromTarget, closeTo(50 / 800, 1e-9));
  });

  test('touch outside the hitbox is a miss with distance context', () {
    final processor = build();
    final result = processor.process(
      raw(1, 1000, 700, 400), // 100 px out
      target: target,
      inPostCaptureWindow: false,
    );
    expect(result.classification, TouchClassification.miss);
    expect(result.distanceFromTarget, closeTo(100 / 800, 1e-9));
  });

  test('duplicate paw-pad contact is ignoredDuplicate, not a second hit', () {
    final processor = build();
    final first = processor.process(
      raw(1, 1000, 600, 400),
      target: target,
      inPostCaptureWindow: false,
    );
    final duplicate = processor.process(
      raw(2, 1060, 610, 405),
      target: target,
      inPostCaptureWindow: false,
    );
    expect(first.classification, TouchClassification.hit);
    expect(duplicate.classification, TouchClassification.ignoredDuplicate);
    expect(duplicate.isDuplicate, isTrue);
    expect(duplicate.logicalId, first.logicalId);
  });

  test('inactive target cannot be hit', () {
    final processor = build();
    const inactive = TargetSnapshot(
      centreX: 600,
      centreY: 400,
      hitboxRadius: 55,
      active: false,
    );
    final result = processor.process(
      raw(1, 1000, 600, 400),
      target: inactive,
      inPostCaptureWindow: true,
    );
    expect(result.classification, TouchClassification.postCapture);
  });

  test('outer 8 percent margin classifies as edge', () {
    final processor = build();
    final result = processor.process(
      raw(1, 1000, 30, 400), // x < 1200*0.08 = 96
      target: null,
      inPostCaptureWindow: false,
    );
    expect(result.classification, TouchClassification.edge);
  });

  test('top corners classify as ownerGesture (excluded from misses)', () {
    final processor = build();
    final left = processor.process(
      raw(1, 1000, 40, 40),
      target: null,
      inPostCaptureWindow: false,
    );
    final right = processor.process(
      raw(2, 1300, width - 40, 40),
      target: null,
      inPostCaptureWindow: false,
    );
    expect(left.classification, TouchClassification.ownerGesture);
    expect(right.classification, TouchClassification.ownerGesture);
  });

  test('hit beats ownerGesture when a target roams near a corner', () {
    final processor = build();
    const cornerTarget = TargetSnapshot(
      centreX: 150,
      centreY: 120,
      hitboxRadius: 55,
      active: true,
    );
    final result = processor.process(
      raw(1, 1000, 150, 120),
      target: cornerTarget,
      inPostCaptureWindow: false,
    );
    expect(result.classification, TouchClassification.hit);
  });

  test('normalised coordinates are per-axis fractions', () {
    final processor = build();
    final result = processor.process(
      raw(1, 1000, 300, 200),
      target: null,
      inPostCaptureWindow: false,
    );
    expect(result.xNormalised, closeTo(300 / width, 1e-9));
    expect(result.yNormalised, closeTo(200 / height, 1e-9));
  });

  test('hold durations reported through registerPointerUp', () {
    final processor = build();
    processor.process(
      raw(7, 1000, 600, 400),
      target: null,
      inPostCaptureWindow: false,
    );
    expect(processor.longestActiveHoldMs(3500), 2500);
    expect(processor.registerPointerUp(7, 4000), 3000);
    expect(processor.activePointerCount, 0);
  });

  test('later pad promotes the same paw to one hit', () {
    final processor = build();
    final first = processor.process(
      raw(1, 1000, 660, 400),
      target: target,
      inPostCaptureWindow: false,
    );
    final second = processor.process(
      raw(2, 1060, 650, 400),
      target: target,
      inPostCaptureWindow: false,
    );
    final third = processor.process(
      raw(3, 1100, 645, 400),
      target: target,
      inPostCaptureWindow: false,
    );
    expect(first.classification, TouchClassification.miss);
    expect(second.logicalId, first.logicalId);
    expect(second.classification, TouchClassification.hit);
    expect(second.isDuplicate, isFalse);
    expect(third.classification, TouchClassification.ignoredDuplicate);
  });

  test('sweep catches between sampled endpoints without repeated hits', () {
    final processor = build();
    final down = processor.process(
      raw(1, 1000, 500, 400),
      target: target,
      inPostCaptureWindow: false,
    );
    final hit = processor.processMove(
      const RawPointerMove(pointerId: 1, timestampMs: 1100, x: 700, y: 400),
      target: target,
    );
    expect(hit, isNotNull);
    expect(hit!.raw, isA<RawPointerMove>());
    expect(hit.logicalId, down.logicalId);
    expect(hit.classification, TouchClassification.hit);
    expect(hit.xNormalised, 0.5);
    expect(hit.yNormalised, 0.5);
    expect(hit.distanceFromTarget, 0);
    expect(
      processor.processMove(
        const RawPointerMove(pointerId: 1, timestampMs: 1200, x: 500, y: 400),
        target: target,
      ),
      isNull,
    );
  });

  test('off-target moves emit no repeated misses', () {
    final processor = build();
    processor.process(
      raw(1, 1000, 500, 200),
      target: target,
      inPostCaptureWindow: false,
    );
    for (var i = 0; i < 100; i++) {
      expect(
        processor.processMove(
          RawPointerMove(
            pointerId: 1,
            timestampMs: 1010 + i,
            x: 500 + i * 1.0,
            y: 200,
          ),
          target: target,
        ),
        isNull,
      );
    }
  });

  test('stationary paw does not catch prey that moves underneath it', () {
    final processor = build();
    processor.process(
      raw(1, 1000, 500, 400),
      target: target,
      inPostCaptureWindow: false,
    );
    expect(
      processor.processMove(
        const RawPointerMove(pointerId: 1, timestampMs: 1100, x: 500, y: 400),
        target: const TargetSnapshot(
          centreX: 500,
          centreY: 400,
          hitboxRadius: 55,
          active: true,
        ),
      ),
      isNull,
    );
  });

  test('subpixel resting jitter does not catch', () {
    final processor = build();
    processor.process(
      raw(1, 1000, 500, 400),
      target: target,
      inPostCaptureWindow: false,
    );
    expect(
      processor.processMove(
        const RawPointerMove(pointerId: 1, timestampMs: 1150, x: 500.1, y: 400),
        target: const TargetSnapshot(
          centreX: 500,
          centreY: 400,
          hitboxRadius: 55,
          active: true,
        ),
      ),
      isNull,
    );
  });

  test('held paw cannot claim a later trial', () {
    final processor = build();
    processor.process(
      raw(1, 1000, 500, 400),
      target: target,
      inPostCaptureWindow: false,
    );
    expect(
      processor.processMove(
        const RawPointerMove(pointerId: 1, timestampMs: 15000, x: 700, y: 400),
        target: const TargetSnapshot(
          centreX: 600,
          centreY: 400,
          hitboxRadius: 55,
          active: true,
          targetId: 1,
        ),
      ),
      isNull,
    );
  });

  test('owner corner contacts create neither sweep catches nor hold flags', () {
    final processor = build();
    processor.process(
      raw(1, 1000, 40, 40),
      target: target,
      inPostCaptureWindow: false,
    );
    expect(
      processor.processMove(
        const RawPointerMove(pointerId: 1, timestampMs: 1100, x: 600, y: 400),
        target: target,
      ),
      isNull,
    );
    expect(processor.longestActiveHoldMs(4000), 0);
    expect(processor.registerPointerUp(1, 4000), 0);
  });

  test('released and cancelled contacts cannot catch on later movement', () {
    final processor = build();
    processor.process(
      raw(1, 1000, 500, 400),
      target: target,
      inPostCaptureWindow: false,
    );
    processor.registerPointerUp(1, 1100);
    expect(
      processor.processMove(
        const RawPointerMove(pointerId: 1, timestampMs: 1200, x: 700, y: 400),
        target: target,
      ),
      isNull,
    );
    expect(processor.activePointerCount, 0);
  });
}
