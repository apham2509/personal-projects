import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawsense/core/device/play_keep_awake.dart';

class FakeScreenWakeLock implements ScreenWakeLockPlatform {
  final requests = <bool>[];
  Completer<void>? pendingEnable;
  bool enabled = false;
  bool failEnable = false;

  @override
  Future<void> setEnabled(bool value) async {
    requests.add(value);
    if (value) {
      await pendingEnable?.future;
      if (failEnable) throw StateError('Native enable failed');
    }
    enabled = value;
  }
}

void main() {
  Widget surface(FakeScreenWakeLock platform, {bool active = true}) {
    return ProviderScope(
      overrides: [screenWakeLockPlatformProvider.overrideWithValue(platform)],
      child: PlayKeepAwake(active: active, child: const SizedBox()),
    );
  }

  testWidgets('only an active foreground play surface holds the screen awake', (
    tester,
  ) async {
    final platform = FakeScreenWakeLock();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpWidget(surface(platform));
    await tester.pump();
    expect(platform.enabled, isTrue);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
    await tester.pump();
    expect(platform.enabled, isFalse);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(platform.enabled, isTrue);

    // Session ended, even if persistence/result navigation is still pending.
    await tester.pumpWidget(surface(platform, active: false));
    await tester.pump();
    expect(platform.enabled, isFalse);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();
    expect(platform.enabled, isFalse);
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(platform.enabled, isFalse);
  });

  testWidgets('leaving the play route releases the screen lock', (
    tester,
  ) async {
    final platform = FakeScreenWakeLock();
    await tester.pumpWidget(surface(platform));
    await tester.pump();
    expect(platform.enabled, isTrue);
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(platform.enabled, isFalse);
    expect(platform.requests.last, isFalse);
  });

  testWidgets('a delayed enable cannot leave a lock behind after disposal', (
    tester,
  ) async {
    final enable = Completer<void>();
    final platform = FakeScreenWakeLock()..pendingEnable = enable;
    await tester.pumpWidget(surface(platform));
    await tester.pump();
    expect(platform.requests, [true]);
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    // The native enable is in flight; its release must follow in order.
    expect(platform.requests, [true]);
    enable.complete();
    await tester.pump();
    expect(platform.enabled, isFalse);
    expect(platform.requests.last, isFalse);
  });

  test(
    'an enable queued before disposal uses the newer disabled intent',
    () async {
      final platform = FakeScreenWakeLock();
      final lock = ScreenWakeLock(platform);
      final enable = lock.setEnabled(true);
      await lock.dispose();
      await enable;
      expect(platform.requests, everyElement(isFalse));
      expect(platform.enabled, isFalse);
    },
  );

  test('a failed native enable does not block the final release', () async {
    final platform = FakeScreenWakeLock()..failEnable = true;
    final lock = ScreenWakeLock(platform);
    await expectLater(lock.setEnabled(true), throwsStateError);
    await lock.dispose();
    expect(platform.requests.last, isFalse);
    expect(platform.enabled, isFalse);
  });
}
