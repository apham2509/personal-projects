import 'dart:math' as math;

/// Minimal immutable 2D vector.
///
/// The domain layer deliberately avoids `dart:ui` and Flame types so that
/// movement, spawning, and touch logic stay pure Dart — runnable from plain
/// `dart` tooling and fast unit tests.
class Vec2 {
  const Vec2(this.x, this.y);

  static const zero = Vec2(0, 0);

  final double x;
  final double y;

  Vec2 operator +(Vec2 o) => Vec2(x + o.x, y + o.y);
  Vec2 operator -(Vec2 o) => Vec2(x - o.x, y - o.y);
  Vec2 operator *(double s) => Vec2(x * s, y * s);

  double get length => math.sqrt(x * x + y * y);

  Vec2 normalised() {
    final l = length;
    if (l < 1e-12) return const Vec2(1, 0);
    return Vec2(x / l, y / l);
  }

  Vec2 clampedLength(double maxLength) {
    final l = length;
    if (l <= maxLength || l < 1e-12) return this;
    return Vec2(x / l * maxLength, y / l * maxLength);
  }

  double distanceTo(Vec2 o) => (this - o).length;

  @override
  bool operator ==(Object other) =>
      other is Vec2 && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'Vec2(${x.toStringAsFixed(4)}, ${y.toStringAsFixed(4)})';
}

/// Axis-aligned rectangle used for movement bounds, in the same coordinate
/// space as the vectors passed in (PawSense uses aspect-corrected units where
/// 1.0 equals the shortest screen dimension).
class Bounds2 {
  const Bounds2(this.minX, this.minY, this.maxX, this.maxY)
    : assert(minX <= maxX),
      assert(minY <= maxY);

  final double minX;
  final double minY;
  final double maxX;
  final double maxY;

  double get width => maxX - minX;
  double get height => maxY - minY;
  Vec2 get centre => Vec2((minX + maxX) / 2, (minY + maxY) / 2);

  bool contains(Vec2 p, {double epsilon = 1e-9}) =>
      p.x >= minX - epsilon &&
      p.x <= maxX + epsilon &&
      p.y >= minY - epsilon &&
      p.y <= maxY + epsilon;

  Vec2 clamp(Vec2 p) => Vec2(p.x.clamp(minX, maxX), p.y.clamp(minY, maxY));

  /// Shrinks the rectangle by [amount] on every side. If that would invert
  /// the rectangle, collapses to the centre point.
  Bounds2 deflate(double amount) {
    final cx = (minX + maxX) / 2;
    final cy = (minY + maxY) / 2;
    return Bounds2(
      math.min(minX + amount, cx),
      math.min(minY + amount, cy),
      math.max(maxX - amount, cx),
      math.max(maxY - amount, cy),
    );
  }
}
