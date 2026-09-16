import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// Small seam so tests never need the native screen-awake plugin.
abstract interface class ScreenWakeLockPlatform {
  Future<void> setEnabled(bool enabled);
}

class NativeScreenWakeLock implements ScreenWakeLockPlatform {
  const NativeScreenWakeLock();

  @override
  Future<void> setEnabled(bool enabled) => WakelockPlus.toggle(enable: enabled);
}

final screenWakeLockPlatformProvider = Provider<ScreenWakeLockPlatform>(
  (ref) => const NativeScreenWakeLock(),
);

final screenWakeLockProvider = Provider<ScreenWakeLock>((ref) {
  final lock = ScreenWakeLock(ref.watch(screenWakeLockPlatformProvider));
  ref.onDispose(() => lock.dispose().ignore());
  return lock;
});

/// Serialises native changes across route/lifecycle transitions. Every queued
/// operation reads the latest intent, so an obsolete enable cannot run after a
/// newer disable. An enable already in flight is followed by the final disable.
class ScreenWakeLock {
  ScreenWakeLock(this._platform);

  final ScreenWakeLockPlatform _platform;
  Future<void> _pending = Future.value();
  bool _enabled = false;
  bool _disposed = false;

  Future<void> setEnabled(bool enabled) {
    if (_disposed) return _pending;
    _enabled = enabled;
    return _enqueue();
  }

  Future<void> _enqueue() {
    // A failed OS request must not prevent a later release from being sent.
    _pending = _pending
        .catchError((Object _) {})
        .then((_) => _platform.setEnabled(_enabled && !_disposed));
    return _pending;
  }

  Future<void> dispose() {
    _disposed = true;
    _enabled = false;
    return _enqueue();
  }
}

/// Keeps a cat's play surface awake only while it is active and foregrounded.
/// The owner UI and background app retain the device's normal sleep behaviour.
class PlayKeepAwake extends ConsumerStatefulWidget {
  const PlayKeepAwake({super.key, required this.active, required this.child});

  final bool active;
  final Widget child;

  @override
  ConsumerState<PlayKeepAwake> createState() => _PlayKeepAwakeState();
}

class _PlayKeepAwakeState extends ConsumerState<PlayKeepAwake>
    with WidgetsBindingObserver {
  late final ScreenWakeLock _lock;
  bool _foreground = true;

  @override
  void initState() {
    super.initState();
    _lock = ref.read(screenWakeLockProvider);
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    _foreground = lifecycle == null || lifecycle == AppLifecycleState.resumed;
    WidgetsBinding.instance.addObserver(this);
    _sync();
  }

  @override
  void didUpdateWidget(PlayKeepAwake oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.active != widget.active) _sync();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _foreground = state == AppLifecycleState.resumed;
    _sync();
  }

  void _sync() => _lock.setEnabled(widget.active && _foreground).ignore();

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _lock.setEnabled(false).ignore();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
