import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/features/play/domain/touch_models.dart';
import 'package:pawsense/features/play/game/input/touch_clusterer.dart';

void main() {
  TouchClusterer build() => TouchClusterer(windowMs: 180, radiusPx: 32);

  RawPointerDown raw(int pointer, int t, double x, double y) =>
      RawPointerDown(pointerId: pointer, timestampMs: t, x: x, y: y);

  test('near-simultaneous nearby contacts merge into one interaction', () {
    final clusterer = build();
    final first = clusterer.register(raw(1, 1000, 100, 100));
    final second = clusterer.register(raw(2, 1050, 115, 110)); // paw pads
    final third = clusterer.register(raw(3, 1120, 95, 92));

    expect(first.isNew, isTrue);
    expect(second.isNew, isFalse);
    expect(third.isNew, isFalse);
    expect(second.interaction.logicalId, first.interaction.logicalId);
    expect(third.interaction.logicalId, first.interaction.logicalId);
    expect(first.interaction.rawContactCount, 3);
    expect(clusterer.logicalInteractionCount, 1);
  });

  test('contacts outside the radius are separate interactions', () {
    final clusterer = build();
    final first = clusterer.register(raw(1, 1000, 100, 100));
    final second = clusterer.register(raw(2, 1010, 200, 100)); // second paw

    expect(second.isNew, isTrue);
    expect(second.interaction.logicalId, isNot(first.interaction.logicalId));
  });

  test('contacts outside the time window are separate interactions', () {
    final clusterer = build();
    final first = clusterer.register(raw(1, 1000, 100, 100));
    final second = clusterer.register(raw(2, 1181, 100, 100)); // 181 ms later

    expect(second.isNew, isTrue);
    expect(second.interaction.logicalId, isNot(first.interaction.logicalId));
  });

  test('boundary: exactly windowMs and radiusPx still merge', () {
    final clusterer = build();
    final first = clusterer.register(raw(1, 1000, 100, 100));
    final second = clusterer.register(raw(2, 1180, 132, 100)); // dx = radius

    expect(second.isNew, isFalse);
    expect(second.interaction.logicalId, first.interaction.logicalId);
  });

  test('clusters anchor on the first contact, not a drifting mean', () {
    final clusterer = build();
    clusterer.register(raw(1, 1000, 100, 100));
    // 30 px from anchor: merges.
    clusterer.register(raw(2, 1040, 130, 100));
    // 30 px from the second but 60 px from the anchor: new interaction.
    final third = clusterer.register(raw(3, 1080, 160, 100));
    expect(third.isNew, isTrue);
  });

  test('rapid distinct taps at the same spot count separately over time', () {
    final clusterer = build();
    var interactions = 0;
    for (var i = 0; i < 10; i++) {
      final result = clusterer.register(raw(i, 1000 + i * 200, 100, 100));
      if (result.isNew) interactions++;
    }
    expect(interactions, 10);
  });
}
