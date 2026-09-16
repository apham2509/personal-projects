import 'dart:math' as math;
import 'dart:ui';

import 'prey_component.dart';

/// A little field mouse: velvet back, cupped ears, bead eyes and a curled
/// tail. Feet and body scurry only when its movement strategy is travelling.
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
    body: Color(0xFFCCBCA8),
    accent: Color(0xFF9D806F),
    detail: Color(0xFF302A27),
  );

  static const highContrastPalette = PreyPalette(
    body: Color(0xFFF2E9DC),
    accent: Color(0xFFCBB89F),
    detail: Color(0xFF14110E),
  );

  @override
  void renderPrey(Canvas canvas, double radius, double opacity) {
    canvas.save();
    canvas.scale(radius);

    final cream = Color.lerp(palette.body, const Color(0xFFFFF8E8), 0.65)!;
    final earColour = Color.lerp(palette.accent, const Color(0xFFE9B4A2), 0.6)!;
    final body = Paint()
      ..shader = Gradient.radial(
        const Offset(-0.13, -0.19),
        0.92,
        [
          cream.withValues(alpha: opacity),
          palette.body.withValues(alpha: opacity),
          palette.accent.withValues(alpha: opacity),
        ],
        const [0, 0.55, 1],
      );
    final accent = Paint()..color = palette.accent.withValues(alpha: opacity);
    final detail = Paint()..color = palette.detail.withValues(alpha: opacity);
    final highlight = Paint()..color = cream.withValues(alpha: opacity * 0.7);

    // This curled tail is intentionally compact: even its control points
    // and round caps stay inside the circular, rotation-safe art envelope.
    final tailSway =
        math.sin(elapsed * 2.3 + animationPhase) * 0.018 +
        math.sin(gaitPhase * 0.5) * movementAmount * 0.022;
    final tail = Path()
      ..moveTo(-0.59, 0.09)
      ..cubicTo(
        -0.91,
        0.05 + tailSway,
        -0.895,
        0.43 + tailSway,
        -0.68,
        0.58 + tailSway,
      )
      ..cubicTo(
        -0.49,
        0.68 + tailSway,
        -0.41,
        0.44 + tailSway,
        -0.57,
        0.43 + tailSway,
      );
    canvas.drawPath(
      tail,
      Paint()
        ..color = earColour.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 0.072,
    );
    canvas.drawPath(
      tail,
      Paint()
        ..color = cream.withValues(alpha: opacity * 0.45)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 0.022,
    );

    final step = math.sin(gaitPhase) * movementAmount;
    final squash = 1 + 0.024 * math.sin(gaitPhase * 2) * movementAmount;
    canvas.save();
    canvas.scale(squash, 1 / squash);

    // Small alternating paws peek from the silhouette, then tuck back in.
    for (final side in const [-1.0, 1.0]) {
      final stride = step * side * 0.055;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(-0.37 + stride, side * 0.41),
          width: 0.21,
          height: 0.12,
        ),
        accent,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(0.3 - stride, side * 0.28),
          width: 0.19,
          height: 0.11,
        ),
        accent,
      );
    }

    // A single connected silhouette gives the mouse a soft, plump rump
    // and a tapered inquisitive snout without a seam between body and head.
    final silhouette = Path()
      ..moveTo(0.87, 0)
      ..cubicTo(0.77, -0.15, 0.57, -0.29, 0.28, -0.32)
      ..cubicTo(0.08, -0.51, -0.54, -0.61, -0.75, -0.24)
      ..cubicTo(-0.93, 0.05, -0.69, 0.44, -0.33, 0.46)
      ..cubicTo(-0.05, 0.49, 0.14, 0.37, 0.31, 0.29)
      ..cubicTo(0.55, 0.26, 0.78, 0.13, 0.87, 0)
      ..close();
    canvas.drawPath(silhouette, body);

    // Soft saddle highlight and three short fur strokes: tactile at tablet
    // size, but the clean silhouette still reads at a small phone size.
    canvas.drawOval(
      const Rect.fromLTWH(-0.6, -0.32, 0.65, 0.38),
      Paint()..color = cream.withValues(alpha: opacity * 0.14),
    );
    final fur = Paint()
      ..color = cream.withValues(alpha: opacity * 0.48)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 0.018;
    for (var i = 0; i < 3; i++) {
      final x = -0.4 + i * 0.12;
      canvas.drawLine(Offset(x, -0.25), Offset(x + 0.045, -0.28), fur);
    }

    // Ears are cups, with an inset warm centre and a light upper rim.
    for (final side in const [-1.0, 1.0]) {
      final ear = Offset(0.29, side * 0.31);
      canvas.drawCircle(ear, 0.225, accent);
      canvas.drawCircle(
        ear + const Offset(0.012, -0.012),
        0.187,
        Paint()..color = cream.withValues(alpha: opacity),
      );
      canvas.drawCircle(
        ear + Offset(0.025, side * 0.012),
        0.137,
        Paint()..color = earColour.withValues(alpha: opacity),
      );
      canvas.drawArc(
        Rect.fromCircle(center: ear, radius: 0.175),
        math.pi,
        math.pi * 0.7,
        false,
        Paint()
          ..color = cream.withValues(alpha: opacity * 0.8)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.021,
      );
    }

    // Fine cream whiskers are readable against the dark play surface.
    final whisker = Paint()
      ..color = cream.withValues(alpha: opacity * 0.8)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 0.015;
    for (final side in const [-1.0, 1.0]) {
      canvas.drawLine(
        Offset(0.72, side * 0.07),
        Offset(0.9, side * 0.32),
        whisker,
      );
      canvas.drawLine(
        Offset(0.73, side * 0.06),
        Offset(0.98, side * 0.17),
        whisker,
      );
      canvas.drawCircle(Offset(0.62, side * 0.15), 0.063, detail);
      canvas.drawCircle(Offset(0.637, side * 0.15 - 0.018), 0.019, highlight);
    }
    canvas.drawOval(const Rect.fromLTWH(0.8, -0.064, 0.137, 0.128), detail);
    canvas.drawOval(
      const Rect.fromLTWH(0.821, -0.046, 0.055, 0.032),
      Paint()..color = earColour.withValues(alpha: opacity * 0.8),
    );
    canvas.restore();
    canvas.restore();
  }
}
