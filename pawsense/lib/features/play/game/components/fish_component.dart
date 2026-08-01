import 'dart:math' as math;
import 'dart:ui';

import 'prey_component.dart';

/// Procedural fish: teardrop body, oscillating tail fin, dorsal fin, and a
/// bright eye. Faces its travel direction and "swims" with a body wave.
class FishComponent extends PreyComponent {
  FishComponent({
    required super.tuning,
    required super.strategy,
    required super.unitPx,
    required super.diameterPx,
    required super.palette,
    required super.animationRng,
  });

  static const regularPalette = PreyPalette(
    body: Color(0xFF89BFCB),
    accent: Color(0xFF5E98A6),
    detail: Color(0xFF1E2F33),
  );

  static const highContrastPalette = PreyPalette(
    body: Color(0xFFBDEBF5),
    accent: Color(0xFF8FD2E2),
    detail: Color(0xFF06181D),
  );

  @override
  void renderPrey(Canvas canvas, double radius, double opacity) {
    final body = Paint()..color = palette.body.withValues(alpha: opacity);
    final accent = Paint()..color = palette.accent.withValues(alpha: opacity);
    final detail = Paint()..color = palette.detail.withValues(alpha: opacity);

    final swim = math.sin(elapsed * 8);

    // Tail fin: triangle wagging behind the body.
    final tail = Path()
      ..moveTo(-radius * 0.55, 0)
      ..lineTo(-radius * 1.25, -radius * 0.5 + swim * radius * 0.22)
      ..lineTo(-radius * 1.25, radius * 0.5 + swim * radius * 0.22)
      ..close();
    canvas.drawPath(tail, accent);

    // Body teardrop (nose at +x).
    final bodyPath = Path()
      ..moveTo(radius * 1.05, 0)
      ..quadraticBezierTo(
        radius * 0.55,
        -radius * 0.62,
        -radius * 0.25,
        -radius * 0.42 + swim * radius * 0.05,
      )
      ..quadraticBezierTo(
        -radius * 0.72,
        0,
        -radius * 0.25,
        radius * 0.42 + swim * radius * 0.05,
      )
      ..quadraticBezierTo(radius * 0.55, radius * 0.62, radius * 1.05, 0)
      ..close();
    canvas.drawPath(bodyPath, body);

    // Dorsal fin.
    final dorsal = Path()
      ..moveTo(-radius * 0.05, -radius * 0.4)
      ..quadraticBezierTo(
        radius * 0.1,
        -radius * 0.85,
        radius * 0.42,
        -radius * 0.45,
      )
      ..close();
    canvas.drawPath(dorsal, accent);

    // Side fin.
    final sideFin = Path()
      ..moveTo(radius * 0.12, radius * 0.1)
      ..quadraticBezierTo(
        -radius * 0.12,
        radius * 0.5 + swim * radius * 0.1,
        radius * 0.3,
        radius * 0.42,
      )
      ..close();
    canvas.drawPath(sideFin, accent);

    // Gill line and eye.
    final line = Paint()
      ..color = palette.accent.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.06;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius * 0.42, 0), radius: radius * 0.3),
      math.pi * 0.7,
      math.pi * 0.6,
      false,
      line,
    );
    canvas.drawCircle(
      Offset(radius * 0.68, -radius * 0.12),
      radius * 0.11,
      detail,
    );
    canvas.drawCircle(
      Offset(radius * 0.70, -radius * 0.14),
      radius * 0.04,
      Paint()..color = const Color(0xFFFFFFFF).withValues(alpha: opacity),
    );
  }
}
