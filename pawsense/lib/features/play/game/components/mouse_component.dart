import 'dart:math' as math;
import 'dart:ui';

import 'prey_component.dart';

/// Procedural mouse: plump body, round ears, whiskers, and a trailing tail.
/// Faces its movement direction; the body squashes subtly while moving.
class MouseComponent extends PreyComponent {
  MouseComponent({
    required super.tuning,
    required super.strategy,
    required super.unitPx,
    required super.diameterPx,
    required super.palette,
    required super.animationRng,
  });

  static const regularPalette = PreyPalette(
    body: Color(0xFFBFB3A4),
    accent: Color(0xFF8C7F6F),
    detail: Color(0xFF2E2A26),
  );

  static const highContrastPalette = PreyPalette(
    body: Color(0xFFF2E9DC),
    accent: Color(0xFFCBB89F),
    detail: Color(0xFF14110E),
  );

  @override
  void renderPrey(Canvas canvas, double radius, double opacity) {
    final body = Paint()..color = palette.body.withValues(alpha: opacity);
    final accent = Paint()..color = palette.accent.withValues(alpha: opacity);
    final detail = Paint()..color = palette.detail.withValues(alpha: opacity);

    // Gentle gait: body squashes along the travel axis while moving.
    final squash = 1 + 0.04 * math.sin(elapsed * 10);

    // Tail: cubic curve trailing behind (drawn first, under the body).
    final tailPaint = Paint()
      ..color = palette.accent.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = radius * 0.12;
    final wag = math.sin(elapsed * 6) * radius * 0.25;
    final tail = Path()
      ..moveTo(-radius * 0.55, 0)
      ..cubicTo(
        -radius * 1.1,
        wag * 0.4,
        -radius * 1.4,
        wag,
        -radius * 1.7,
        wag * 0.6,
      );
    canvas.drawPath(tail, tailPaint);

    // Body: teardrop pointing forward (+x).
    final bodyRect = Rect.fromCenter(
      center: Offset(-radius * 0.08, 0),
      width: radius * 1.5 * squash,
      height: radius * 1.05 / squash,
    );
    canvas.drawOval(bodyRect, body);

    // Head wedge.
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(radius * 0.62, 0),
        width: radius * 0.85,
        height: radius * 0.7,
      ),
      body,
    );

    // Ears.
    canvas.drawCircle(
      Offset(radius * 0.42, -radius * 0.38),
      radius * 0.24,
      accent,
    );
    canvas.drawCircle(
      Offset(radius * 0.42, radius * 0.38),
      radius * 0.24,
      accent,
    );

    // Nose and eye.
    canvas.drawCircle(Offset(radius * 1.02, 0), radius * 0.09, detail);
    canvas.drawCircle(
      Offset(radius * 0.66, -radius * 0.14),
      radius * 0.07,
      detail,
    );
    canvas.drawCircle(
      Offset(radius * 0.66, radius * 0.14),
      radius * 0.07,
      detail,
    );

    // Whiskers.
    final whisker = Paint()
      ..color = palette.detail.withValues(alpha: opacity * 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.035;
    for (final side in const [-1.0, 1.0]) {
      for (var i = 0; i < 2; i++) {
        canvas.drawLine(
          Offset(radius * 0.95, side * radius * 0.05),
          Offset(radius * 1.35, side * radius * (0.16 + 0.14 * i)),
          whisker,
        );
      }
    }
  }
}
