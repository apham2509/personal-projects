import 'dart:math' as math;
import 'dart:ui';

import 'prey_component.dart';

/// Procedural moth: two flapping wing pairs, a fuzzy capsule body, and
/// antennae. Stays mostly upright with a slight tilt into its heading —
/// moths flutter rather than point.
class MothComponent extends PreyComponent {
  MothComponent({
    required super.tuning,
    required super.strategy,
    required super.unitPx,
    required super.diameterPx,
    required super.palette,
    required super.animationRng,
  });

  static const regularPalette = PreyPalette(
    body: Color(0xFFD8C9A3),
    accent: Color(0xFFB3A17A),
    detail: Color(0xFF3A3222),
  );

  static const highContrastPalette = PreyPalette(
    body: Color(0xFFF7EEC9),
    accent: Color(0xFFE0D3A1),
    detail: Color(0xFF191507),
  );

  @override
  double headingForRender() {
    // Upright with a gentle tilt towards travel, plus flutter wobble.
    final tilt = math.sin(elapsed * 9) * 0.12;
    return super.headingForRender() * 0.15 + tilt;
  }

  @override
  void renderPrey(Canvas canvas, double radius, double opacity) {
    final wing = Paint()..color = palette.body.withValues(alpha: opacity);
    final wingBack = Paint()
      ..color = palette.accent.withValues(alpha: opacity * 0.9);
    final detail = Paint()..color = palette.detail.withValues(alpha: opacity);

    // Wing flap: vertical scale oscillation ~9 Hz (fast but not strobing —
    // rendered as smooth continuous motion, no flashing).
    final flap = 0.45 + 0.55 * math.sin(elapsed * 2 * math.pi * 4.5).abs();

    void drawWingPair(double lengthScale, Paint paint) {
      for (final side in const [-1.0, 1.0]) {
        final path = Path()
          ..moveTo(0, 0)
          ..quadraticBezierTo(
            side * radius * 1.05 * lengthScale,
            -radius * 0.9 * flap * lengthScale,
            side * radius * 1.25 * lengthScale,
            -radius * 0.15 * flap * lengthScale,
          )
          ..quadraticBezierTo(
            side * radius * 0.95 * lengthScale,
            radius * 0.35 * flap * lengthScale,
            0,
            radius * 0.12,
          )
          ..close();
        canvas.drawPath(path, paint);
      }
    }

    // Hind wings behind, forewings in front.
    canvas.save();
    canvas.translate(0, radius * 0.18);
    drawWingPair(0.7, wingBack);
    canvas.restore();
    drawWingPair(1.0, wing);

    // Body capsule.
    final bodyRect = Rect.fromCenter(
      center: Offset(0, radius * 0.05),
      width: radius * 0.34,
      height: radius * 1.05,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, Radius.circular(radius * 0.17)),
      detail,
    );

    // Antennae.
    final antenna = Paint()
      ..color = palette.detail.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = radius * 0.05;
    for (final side in const [-1.0, 1.0]) {
      final path = Path()
        ..moveTo(side * radius * 0.06, -radius * 0.42)
        ..quadraticBezierTo(
          side * radius * 0.3,
          -radius * 0.85,
          side * radius * 0.55,
          -radius * 0.95,
        );
      canvas.drawPath(path, antenna);
    }
  }
}
