import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

import '../../shared/models/enums.dart';

/// Owns every audio resource in the app: low-latency pools for the short
/// synthesised effects and a player for owner-recorded cues.
///
/// One engine (audioplayers) for everything — see DECISIONS.md D-002. All
/// sounds ship quiet by design; there is deliberately no API for loud or
/// looping playback.
class AudioService {
  AudioService();

  final Map<String, AudioPool> _pools = {};
  AudioPlayer? _cuePlayer;
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
      _pools[entry.key] ??= await AudioPool.createFromAsset(
        path: entry.value,
        maxPlayers: 2,
      );
    }
  }

  Future<void> playCapture() => _play('capture');

  Future<void> playSuccessChime() => _play('success');

  Future<void> playAttention() => _play('attention');

  Future<void> playPreyVoice(PreyType prey) => _play('prey_${prey.name}');

  Future<void> _play(String key) async {
    if (_disposed) return;
    final pool = _pools[key];
    if (pool == null) return;
    await pool.start();
  }

  /// Plays an owner-recorded cue file (absolute path); the returned future
  /// completes when playback finishes (or immediately on failure — a broken
  /// recording must never stall a session).
  Future<void> playCueFile(String absolutePath) async {
    if (_disposed) return;
    final player = _cuePlayer ??= AudioPlayer();
    final done = Completer<void>();
    StreamSubscription<void>? sub;
    sub = player.onPlayerComplete.listen((_) {
      sub?.cancel();
      if (!done.isCompleted) done.complete();
    });
    try {
      await player.stop();
      await player.play(DeviceFileSource(absolutePath));
      // Guard against a missing completion event.
      unawaited(
        Future<void>.delayed(const Duration(seconds: 6)).then((_) {
          sub?.cancel();
          if (!done.isCompleted) done.complete();
        }),
      );
    } on Exception {
      await sub.cancel();
      if (!done.isCompleted) done.complete();
    }
    return done.future;
  }

  Future<void> dispose() async {
    _disposed = true;
    for (final pool in _pools.values) {
      await pool.dispose();
    }
    _pools.clear();
    await _cuePlayer?.dispose();
    _cuePlayer = null;
  }
}
