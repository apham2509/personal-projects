// Generates PawSense's built-in sound effects as 16-bit PCM WAV files.
//
// Every audio asset shipped with the app is synthesised here from first
// principles (sine partials, noise, and envelopes), so the project contains
// no third-party or copyright-encumbered audio. Re-run after changing a
// recipe:
//
//   dart run tool/generate_placeholder_audio.dart
//
// Design intent: quiet, soft-attack, non-startling sounds. Amplitudes are
// deliberately low; sudden loud audio is a safety no-go for cat-facing play.

import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

const sampleRate = 44100;

void main() {
  final outDir = Directory('assets/audio');
  outDir.createSync(recursive: true);

  final recipes = <String, List<double>>{
    // Soft two-note chime used when no owner praise recording exists.
    'success_soft.wav': _mix([
      _tone(659.25, 0.28, amp: 0.18, attack: 0.02, release: 0.22),
      _delay(_tone(783.99, 0.30, amp: 0.16, attack: 0.02, release: 0.24), 0.12),
    ]),
    // Gentle low pop played when a target is captured.
    'capture_pop.wav': _sweep(520, 240, 0.11, amp: 0.22, release: 0.09),
    // Very quiet double chirp used as a subtle attention nudge.
    'attention_soft.wav': _mix([
      _tone(1174.66, 0.06, amp: 0.10, attack: 0.008, release: 0.05),
      _delay(
        _tone(1318.51, 0.06, amp: 0.09, attack: 0.008, release: 0.05),
        0.14,
      ),
    ]),
    // Prey idle/capture sounds: one short original voice per prey type.
    'prey_mouse.wav': _squeak(),
    'prey_moth.wav': _flutter(),
    'prey_fish.wav': _bloop(),
  };

  recipes.forEach((name, samples) {
    final file = File('${outDir.path}/$name');
    file.writeAsBytesSync(_wav(samples));
    stdout.writeln(
      'wrote ${file.path} '
      '(${(samples.length / sampleRate).toStringAsFixed(2)}s, '
      '${file.lengthSync()} bytes)',
    );
  });
}

/// Sine tone with a soft attack/release envelope and a mellow 2nd harmonic.
List<double> _tone(
  double freq,
  double seconds, {
  double amp = 0.2,
  double attack = 0.01,
  double release = 0.08,
}) {
  final n = (seconds * sampleRate).round();
  final out = List<double>.filled(n, 0);
  for (var i = 0; i < n; i++) {
    final t = i / sampleRate;
    final env = _envelope(t, seconds, attack, release);
    final s =
        math.sin(2 * math.pi * freq * t) +
        0.35 * math.sin(2 * math.pi * freq * 2 * t);
    out[i] = amp * env * s / 1.35;
  }
  return out;
}

/// Exponential frequency sweep from [from] Hz to [to] Hz.
List<double> _sweep(
  double from,
  double to,
  double seconds, {
  double amp = 0.2,
  double attack = 0.005,
  double release = 0.08,
}) {
  final n = (seconds * sampleRate).round();
  final out = List<double>.filled(n, 0);
  var phase = 0.0;
  for (var i = 0; i < n; i++) {
    final t = i / sampleRate;
    final progress = t / seconds;
    final freq = from * math.pow(to / from, progress);
    phase += 2 * math.pi * freq / sampleRate;
    final env = _envelope(t, seconds, attack, release);
    out[i] = amp * env * math.sin(phase);
  }
  return out;
}

/// Mouse squeak: fast falling chirp with slight vibrato.
List<double> _squeak() {
  final n = (0.14 * sampleRate).round();
  final out = List<double>.filled(n, 0);
  var phase = 0.0;
  for (var i = 0; i < n; i++) {
    final t = i / sampleRate;
    final vibrato = 1 + 0.04 * math.sin(2 * math.pi * 55 * t);
    final freq = (1900 - 900 * (t / 0.14)) * vibrato;
    phase += 2 * math.pi * freq / sampleRate;
    final env = _envelope(t, 0.14, 0.01, 0.08);
    out[i] = 0.14 * env * math.sin(phase);
  }
  return out;
}

/// Moth flutter: quiet band-limited noise, amplitude-modulated at wing rate.
List<double> _flutter() {
  final n = (0.22 * sampleRate).round();
  final out = List<double>.filled(n, 0);
  final rng = math.Random(7);
  var lp = 0.0;
  for (var i = 0; i < n; i++) {
    final t = i / sampleRate;
    // One-pole low-pass over white noise keeps it soft and papery.
    lp = lp * 0.92 + (rng.nextDouble() * 2 - 1) * 0.08;
    final wings = 0.5 + 0.5 * math.sin(2 * math.pi * 26 * t);
    final env = _envelope(t, 0.22, 0.03, 0.12);
    out[i] = 0.5 * env * wings * lp * 6;
  }
  return out;
}

/// Fish bloop: soft low sweep with a watery second partial.
List<double> _bloop() {
  final n = (0.18 * sampleRate).round();
  final out = List<double>.filled(n, 0);
  var phase = 0.0;
  var phase2 = 0.0;
  for (var i = 0; i < n; i++) {
    final t = i / sampleRate;
    final freq = 330 - 170 * (t / 0.18);
    phase += 2 * math.pi * freq / sampleRate;
    phase2 += 2 * math.pi * freq * 1.5 / sampleRate;
    final env = _envelope(t, 0.18, 0.015, 0.1);
    out[i] = env * (0.16 * math.sin(phase) + 0.05 * math.sin(phase2));
  }
  return out;
}

double _envelope(double t, double total, double attack, double release) {
  if (t < attack) return t / attack;
  final tail = total - release;
  if (t > tail) return math.max(0, (total - t) / release);
  return 1;
}

List<double> _delay(List<double> samples, double seconds) {
  final pad = List<double>.filled((seconds * sampleRate).round(), 0);
  return [...pad, ...samples];
}

List<double> _mix(List<List<double>> tracks) {
  final length = tracks.map((t) => t.length).reduce(math.max);
  final out = List<double>.filled(length, 0);
  for (final track in tracks) {
    for (var i = 0; i < track.length; i++) {
      out[i] += track[i];
    }
  }
  return out;
}

/// Encodes mono float samples as a 16-bit PCM WAV byte stream.
Uint8List _wav(List<double> samples) {
  final dataLength = samples.length * 2;
  final bytes = BytesBuilder();
  void str(String s) => bytes.add(s.codeUnits);
  void u32(int v) => bytes.add(
    Uint8List(4)..buffer.asByteData().setUint32(0, v, Endian.little),
  );
  void u16(int v) => bytes.add(
    Uint8List(2)..buffer.asByteData().setUint16(0, v, Endian.little),
  );

  str('RIFF');
  u32(36 + dataLength);
  str('WAVE');
  str('fmt ');
  u32(16);
  u16(1); // PCM
  u16(1); // mono
  u32(sampleRate);
  u32(sampleRate * 2); // byte rate
  u16(2); // block align
  u16(16); // bits per sample
  str('data');
  u32(dataLength);
  final pcm = ByteData(dataLength);
  for (var i = 0; i < samples.length; i++) {
    final clamped = samples[i].clamp(-1.0, 1.0);
    pcm.setInt16(i * 2, (clamped * 32767).round(), Endian.little);
  }
  bytes.add(pcm.buffer.asUint8List());
  return bytes.toBytes();
}
