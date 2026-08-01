/// Deterministic pseudo-random source used everywhere randomness matters.
///
/// Dart's built-in [Random] algorithm is implementation-defined, so seeds
/// would not be guaranteed to reproduce across Dart versions or platforms.
/// PawSense instead uses SplitMix64, which is tiny, statistically solid for
/// game/scheduling purposes, and fully specified — a stored session seed will
/// replay identically forever.
library;

const int _mask64 = 0xFFFFFFFFFFFFFFFF;

class SeededRandom {
  SeededRandom(int seed) : _state = seed & _mask64;

  int _state;

  /// Next raw 64-bit value (SplitMix64 step).
  int nextInt64() {
    _state = (_state + 0x9E3779B97F4A7C15) & _mask64;
    var z = _state;
    z = ((z ^ (z >>> 30)) * 0xBF58476D1CE4E5B9) & _mask64;
    z = ((z ^ (z >>> 27)) * 0x94D049BB133111EB) & _mask64;
    return z ^ (z >>> 31);
  }

  /// Uniform double in [0, 1). Uses the top 53 bits.
  double nextDouble() => (nextInt64() >>> 11) / 9007199254740992.0;

  /// Uniform integer in [0, max). [max] must be positive.
  int nextInt(int max) {
    assert(max > 0, 'max must be positive');
    // Rejection sampling to avoid modulo bias.
    final limit = _mask64 - ((_mask64 % max + 1) % max) & _mask64;
    while (true) {
      final v = nextInt64() & _mask64;
      // Compare as unsigned via masking into the positive range.
      final u = v >>> 1; // 63-bit non-negative value keeps comparisons simple.
      final l = limit >>> 1;
      if (u <= l || max <= 1) return u % max;
    }
  }

  bool nextBool() => (nextInt64() & 1) == 1;

  /// Uniform double in [min, max).
  double nextDoubleInRange(double min, double max) =>
      min + nextDouble() * (max - min);

  /// Picks one element uniformly.
  T pick<T>(List<T> items) {
    assert(items.isNotEmpty);
    return items[nextInt(items.length)];
  }

  /// Fisher–Yates shuffle in place, deterministic for a given state.
  void shuffle<T>(List<T> items) {
    for (var i = items.length - 1; i > 0; i--) {
      final j = nextInt(i + 1);
      final tmp = items[i];
      items[i] = items[j];
      items[j] = tmp;
    }
  }

  /// Derives an independent child generator (for sub-streams such as a
  /// per-trial movement path from a per-session seed).
  SeededRandom fork() => SeededRandom(nextInt64());
}

/// Creates a non-deterministic seed for new sessions. Uses the current
/// microsecond clock mixed through one SplitMix64 step; sessions then store
/// the seed so they can be replayed.
int freshSeed(DateTime now) =>
    SeededRandom(now.microsecondsSinceEpoch).nextInt64();
