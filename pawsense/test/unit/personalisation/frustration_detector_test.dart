import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/features/personalisation/domain/frustration_detector.dart';
import 'package:pawsense/shared/models/enums.dart';

void main() {
  test('missBurst: 3 deduplicated misses within 2 s', () {
    final detector = FrustrationDetector();
    detector.onMiss(1000);
    detector.onMiss(1800);
    expect(detector.activeFlags(1900), isEmpty);
    detector.onMiss(2600);
    expect(detector.activeFlags(2600), contains(FrustrationFlag.missBurst));
    expect(detector.severity(2600), 1);
  });

  test('missBurst window slides: spread-out misses never flag', () {
    final detector = FrustrationDetector();
    detector.onMiss(0);
    detector.onMiss(2500);
    detector.onMiss(5000);
    detector.onMiss(7500);
    expect(detector.activeFlags(7500), isEmpty);
  });

  test('edgeBurst: 4 edge touches within 3 s', () {
    final detector = FrustrationDetector();
    for (var i = 0; i < 4; i++) {
      detector.onEdgeTouch(1000 + i * 500);
    }
    expect(detector.activeFlags(2500), contains(FrustrationFlag.edgeBurst));
  });

  test('postCaptureBurst: 4 interactions within 1.5 s', () {
    final detector = FrustrationDetector();
    for (var i = 0; i < 4; i++) {
      detector.onPostCaptureTouch(1000 + i * 300);
    }
    expect(
      detector.activeFlags(1900),
      contains(FrustrationFlag.postCaptureBurst),
    );
  });

  test('rapidTapBurst: 10 logical touches in 5 s with low success', () {
    final detector = FrustrationDetector();
    for (var i = 0; i < 10; i++) {
      // Alternating spread-out miss/edge so no other burst window fires.
      if (i.isEven) {
        detector.onMiss(i * 450);
      } else {
        detector.onEdgeTouch(i * 450);
      }
    }
    expect(detector.activeFlags(4100), contains(FrustrationFlag.rapidTapBurst));
  });

  test('rapid tapping with catches is play, not frustration', () {
    final detector = FrustrationDetector();
    for (var i = 0; i < 10; i++) {
      if (i % 3 == 0) {
        detector.onCatch(i * 450);
      } else {
        detector.onMiss(i * 450);
      }
    }
    expect(
      detector.activeFlags(4100),
      isNot(contains(FrustrationFlag.rapidTapBurst)),
    );
  });

  test('longHold flags at 2 s and severity counts it once per trial', () {
    final detector = FrustrationDetector();
    detector.onHold(3000, 2400);
    expect(detector.activeFlags(3000), contains(FrustrationFlag.longHold));
    final (flags, severity) = detector.collectTrialFlags(3100);
    expect(flags, contains(FrustrationFlag.longHold));
    expect(severity, 1);
    // Cleared for the next trial.
    expect(detector.activeFlags(3200), isEmpty);
  });

  test('consecutiveTimeouts: 3 in a row, reset by a catch', () {
    final detector = FrustrationDetector();
    detector.onTrialTimeout(10000);
    detector.onTrialTimeout(25000);
    expect(
      detector.activeFlags(25000),
      isNot(contains(FrustrationFlag.consecutiveTimeouts)),
    );
    detector.onTrialTimeout(40000);
    expect(
      detector.activeFlags(40000),
      contains(FrustrationFlag.consecutiveTimeouts),
    );
    detector.onCatch(41000);
    detector.onTrialTimeout(55000);
    expect(
      detector.activeFlags(55000),
      isNot(contains(FrustrationFlag.consecutiveTimeouts)),
    );
  });

  test('repeatedImpossibleReach: 4 near-misses just outside the hitbox', () {
    final detector = FrustrationDetector();
    for (var i = 0; i < 4; i++) {
      detector.onMiss(1000 + i * 2000, distanceFromTargetEdge: 0.03);
    }
    expect(
      detector.activeFlags(7000),
      contains(FrustrationFlag.repeatedImpossibleReach),
    );
  });

  test('far misses never count as impossible reach', () {
    final detector = FrustrationDetector();
    for (var i = 0; i < 4; i++) {
      detector.onMiss(1000 + i * 2000, distanceFromTargetEdge: 0.3);
    }
    expect(
      detector.activeFlags(7000),
      isNot(contains(FrustrationFlag.repeatedImpossibleReach)),
    );
  });

  test('severity saturates at 3 with stacked flags', () {
    final detector = FrustrationDetector();
    // Stack miss burst + rapid taps + timeouts.
    detector.onTrialTimeout(0);
    detector.onTrialTimeout(1);
    detector.onTrialTimeout(2);
    for (var i = 0; i < 10; i++) {
      detector.onMiss(1000 + i * 100);
    }
    expect(detector.severity(2000), 3);
  });

  test('collectTrialFlags attributes mid-trial bursts to the trial', () {
    final detector = FrustrationDetector();
    // Burst early in the trial...
    detector.onMiss(1000);
    detector.onMiss(1200);
    detector.onMiss(1400);
    // ...long quiet period, then trial ends: windows are empty but the
    // trial still carries the flag.
    final (flags, severity) = detector.collectTrialFlags(11400);
    expect(flags, contains(FrustrationFlag.missBurst));
    expect(severity, greaterThanOrEqualTo(1));
  });
}
