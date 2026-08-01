import 'package:record/record.dart';

/// Result of a finished recording.
class RecordingResult {
  const RecordingResult({required this.path, required this.durationMs});

  final String path;
  final int durationMs;
}

/// Thin, test-friendly seam over the platform recorder. All recordings are
/// local temporary files; the repository moves them into the profile tree.
abstract class CueRecorder {
  /// True when microphone permission is granted (triggers the system
  /// request on first call where the platform allows).
  Future<bool> hasPermission();

  Future<void> start(String path);

  /// Stops and returns the finished recording, or null if nothing was
  /// recording.
  Future<RecordingResult?> stop();

  Future<void> cancel();

  Future<void> dispose();
}

/// Production implementation over `package:record` (AAC in an m4a
/// container, mono, voice-appropriate bitrate).
class RecordPackageCueRecorder implements CueRecorder {
  RecordPackageCueRecorder() : _recorder = AudioRecorder();

  final AudioRecorder _recorder;
  DateTime? _startedAt;

  @override
  Future<bool> hasPermission() => _recorder.hasPermission();

  @override
  Future<void> start(String path) async {
    _startedAt = DateTime.now();
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 96000,
        sampleRate: 44100,
        numChannels: 1,
      ),
      path: path,
    );
  }

  @override
  Future<RecordingResult?> stop() async {
    final path = await _recorder.stop();
    final startedAt = _startedAt;
    _startedAt = null;
    if (path == null || startedAt == null) return null;
    return RecordingResult(
      path: path,
      durationMs: DateTime.now().difference(startedAt).inMilliseconds,
    );
  }

  @override
  Future<void> cancel() async {
    await _recorder.cancel();
    _startedAt = null;
  }

  @override
  Future<void> dispose() async {
    await _recorder.dispose();
  }
}
