import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

import '../../shared/models/enums.dart';

/// Narrow seam for native cue startup and completion. Keeping preparation
/// separate from resume lets a lifecycle cancellation invalidate a pending
/// start before any voice is played.
abstract interface class CuePlayer {
  Stream<void> get onComplete;
  Future<void> stop();
  Future<void> setSourceFile(String absolutePath);
  Future<void> resume();
  Future<void> dispose();
}

class _NativeCuePlayer implements CuePlayer {
  final AudioPlayer _player = AudioPlayer();

  @override
  Stream<void> get onComplete => _player.onPlayerComplete;

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> setSourceFile(String path) => _player.setSourceDeviceFile(path);

  @override
  Future<void> resume() => _player.resume();

  @override
  Future<void> dispose() => _player.dispose();
}

/// Owns every audio resource in the app: low-latency pools for the short
/// synthesised effects and a player for owner-recorded cues.
///
/// One engine (audioplayers) for everything — see DECISIONS.md D-002. All
/// sounds ship quiet by design; there is deliberately no API for loud or
/// looping playback.
class AudioService {
  AudioService({CuePlayer Function()? cuePlayerFactory})
    : _cuePlayerFactory = cuePlayerFactory ?? _NativeCuePlayer.new;

  final CuePlayer Function() _cuePlayerFactory;
  final Map<String, AudioPool> _pools = {};
  CuePlayer? _cuePlayer;
  _PendingCue? _pendingCue;
  Future<void> _cueOperations = Future.value();
  Future<void>? _disposeFuture;
  int _cueGeneration = 0;
  bool _disposed = false;

  static const _effectAssets = <String, String>{
    'capture': 'audio/capture_pop.wav',
    'success': 'audio/success_soft.wav',
    'attention': 'audio/attention_soft.wav',
    'prey_mouse': 'audio/prey_mouse.wav',
    'prey_moth': 'audio/prey_moth.wav',
    'prey_fish': 'audio/prey_fish.wav',
  };

  Future<void> preload() async {
    for (final entry in _effectAssets.entries) {
      if (_disposed) return;
      if (_pools.containsKey(entry.key)) continue;
      final pool = await AudioPool.createFromAsset(
        path: entry.value,
        maxPlayers: 2,
      );
      if (_disposed) {
        await pool.dispose();
        return;
      }
      _pools[entry.key] = pool;
    }
  }

  Future<void> playCapture() => _play('capture');

  Future<void> playSuccessChime() => _play('success');

  Future<void> playAttention() => _play('attention');

  Future<void> playPreyVoice(PreyType prey) => _play('prey_${prey.name}');

  /// Immediately cancels pending cue waits and invalidates asynchronous
  /// startup. Native stop is ordered after any operation already in flight.
  Future<void> stopCue() {
    _cueGeneration++;
    _completeCue(_pendingCue);
    if (_disposed) return _disposeFuture ?? _cueOperations;
    return _enqueueCueOperation(() async => _cuePlayer?.stop());
  }

  Future<void> _play(String key) async {
    if (_disposed) return;
    final pool = _pools[key];
    if (pool == null) return;
    await pool.start();
  }

  /// Plays an owner-recorded cue file (absolute path). Completion, replacement,
  /// stop, disposal, failure, and the six-second guard all settle the returned
  /// future, so a broken recording cannot stall a session.
  Future<void> playCueFile(String absolutePath) {
    if (_disposed) return Future.value();
    final generation = ++_cueGeneration;
    _completeCue(_pendingCue);
    final cue = _pendingCue = _PendingCue(generation);
    // Include source preparation in the bound, not just audible playback.
    cue.guard = Timer(const Duration(seconds: 6), () {
      if (_isCurrent(cue)) stopCue().ignore();
    });
    _enqueueCueOperation(() async {
      if (!_isCurrent(cue)) return;
      try {
        final player = _cuePlayer ??= _cuePlayerFactory();
        await player.stop();
        if (!_isCurrent(cue)) return;
        await player.setSourceFile(absolutePath);
        if (!_isCurrent(cue)) return;
        cue.subscription = player.onComplete.listen(
          (_) => _completeCue(cue),
          onError: (Object _) => _completeCue(cue),
        );
        await player.resume();
        // A stop/dispose requested during resume is queued next and cannot
        // be overtaken by another cue's preparation or resume.
      } catch (_) {
        _completeCue(cue);
      }
    }).ignore();
    return cue.done.future;
  }

  bool _isCurrent(_PendingCue cue) =>
      !_disposed &&
      cue.generation == _cueGeneration &&
      identical(_pendingCue, cue);

  void _completeCue(_PendingCue? cue) {
    if (cue == null) return;
    cue.complete();
    if (identical(_pendingCue, cue)) _pendingCue = null;
  }

  Future<void> _enqueueCueOperation(Future<void> Function() operation) {
    _cueOperations = _cueOperations
        .catchError((Object _) {})
        .then((_) => operation());
    return _cueOperations;
  }

  Future<void> dispose() {
    if (_disposed) return _disposeFuture ?? _cueOperations;
    _disposed = true;
    _cueGeneration++;
    _completeCue(_pendingCue);
    return _disposeFuture = _disposeResources();
  }

  Future<void> _disposeResources() async {
    await _enqueueCueOperation(() async {
      final player = _cuePlayer;
      _cuePlayer = null;
      if (player != null) await player.dispose();
    });
    for (final pool in _pools.values) {
      await pool.dispose();
    }
    _pools.clear();
  }
}

class _PendingCue {
  _PendingCue(this.generation);

  final int generation;
  final Completer<void> done = Completer<void>();
  StreamSubscription<void>? subscription;
  Timer? guard;

  void complete() {
    guard?.cancel();
    subscription?.cancel().ignore();
    subscription = null;
    if (!done.isCompleted) done.complete();
  }
}
