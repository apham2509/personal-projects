import 'dart:math' as math;
import 'dart:ui';

import 'prey_component.dart';

/// A patterned night moth with scalloped wings and a soft collar. Its
/// continuous wing fold changes geometry gently, never brightness.
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
    body: Color(0xFFE0CBA0),
    accent: Color(0xFFA78A5E),
    detail: Color(0xFF4A3C2E),
  );

  static const highContrastPalette = PreyPalette(
    body: Color(0xFFF7EEC9),
    accent: Color(0xFFE0D3A1),
    detail: Color(0xFF191507),
  );

  @override
  double headingForRender() {
    // A bounded bank into travel, with a tiny seeded hover. Using sin keeps
    // the moth upright even after a movement path completes many turns.
    return math.sin(super.headingForRender()) * 0.14 +
        math.sin(elapsed * 5.2 + animationPhase) * 0.055;
  }

  @override
  void renderPrey(Canvas canvas, double radius, double opacity) {
    canvas.save();
    canvas.scale(radius);
    final cream = Color.lerp(palette.body, const Color(0xFFFFF8E4), 0.72)!;
    final warmShade = Color.lerp(palette.accent, palette.detail, 0.2)!;
    final detail = Paint()..color = palette.detail.withValues(alpha: opacity);

    // Smooth signed sinusoid avoids the sharp reversal and doubled flap
    // frequency of abs(sin). Wings retain at least 68% of their span.
    final flutter = math.sin(elapsed * math.pi * 2 * 3.1 + animationPhase);
    final wingSpan = 0.84 + flutter * 0.16;
    for (final side in const [-1.0, 1.0]) {
      canvas.save();
      canvas.scale(side * wingSpan, 1);

      final hind = Path()
        ..moveTo(0.07, 0.05)
        ..cubicTo(0.35, 0.01, 0.78, 0.15, 0.71, 0.42)
        ..quadraticBezierTo(0.69, 0.64, 0.52, 0.6)
        ..quadraticBezierTo(0.45, 0.71, 0.32, 0.57)
        ..quadraticBezierTo(0.14, 0.56, 0.07, 0.24)
        ..close();
      canvas.drawPath(
        hind,
        Paint()
          ..shader =
              Gradient.linear(const Offset(0.1, 0.1), const Offset(0.6, 0.65), [
                palette.body.withValues(alpha: opacity),
                warmShade.withValues(alpha: opacity),
              ]),
      );
      final hindBand = Path()
        ..moveTo(0.23, 0.36)
        ..quadraticBezierTo(0.43, 0.58, 0.66, 0.36);
      canvas.drawPath(
        hindBand,
        Paint()
          ..color = cream.withValues(alpha: opacity * 0.42)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 0.045,
      );

      final wing = Path()
        ..moveTo(0.08, -0.25)
        ..cubicTo(0.35, -0.57, 0.67, -0.73, 0.8, -0.53)
        ..quadraticBezierTo(0.94, -0.36, 0.98, -0.1)
        ..quadraticBezierTo(0.95, 0.09, 0.82, 0.09)
        ..quadraticBezierTo(0.77, 0.25, 0.61, 0.18)
        ..quadraticBezierTo(0.44, 0.31, 0.1, 0.12)
        ..close();
      canvas.drawPath(
        wing,
        Paint()
          ..shader = Gradient.linear(
            const Offset(0.3, -0.52),
            const Offset(0.72, 0.25),
            [
              cream.withValues(alpha: opacity),
              palette.body.withValues(alpha: opacity),
              palette.accent.withValues(alpha: opacity),
            ],
            const [0, 0.58, 1],
          ),
      );

      // A continuous scalloped edge, delicate veins and one small eyespot
      // per wing give the moth its own identity without visual noise.
      final edge = Path()
        ..moveTo(0.76, -0.52)
        ..quadraticBezierTo(0.89, -0.3, 0.88, -0.1)
        ..quadraticBezierTo(0.85, 0.04, 0.75, 0)
        ..quadraticBezierTo(0.66, 0.15, 0.56, 0.1)
        ..quadraticBezierTo(0.4, 0.2, 0.2, 0.1);
      canvas.drawPath(
        edge,
        Paint()
          ..color = warmShade.withValues(alpha: opacity * 0.58)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 0.038,
      );
      final vein = Paint()
        ..color = palette.accent.withValues(alpha: opacity * 0.44)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 0.013;
      canvas.drawPath(
        Path()
          ..moveTo(0.11, -0.16)
          ..quadraticBezierTo(0.42, -0.22, 0.75, -0.48),
        vein,
      );
      canvas.drawPath(
        Path()
          ..moveTo(0.14, -0.08)
          ..quadraticBezierTo(0.52, -0.12, 0.82, -0.02),
        vein,
      );
      canvas.drawOval(
        const Rect.fromLTWH(0.48, -0.35, 0.22, 0.17),
        Paint()..color = warmShade.withValues(alpha: opacity * 0.9),
      );
      canvas.drawOval(
        const Rect.fromLTWH(0.515, -0.317, 0.12, 0.09),
        Paint()..color = cream.withValues(alpha: opacity),
      );
      canvas.restore();
    }

    // The abdomen has a quiet segmented highlight, with a fuzzy collar
    // made from small overlapping shapes rather than a costly blur.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-0.13, -0.25, 0.26, 0.83),
        const Radius.circular(0.13),
      ),
      detail,
    );
    final segment = Paint()
      ..color = palette.accent.withValues(alpha: opacity * 0.9)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 0.025;
    for (var i = 0; i < 4; i++) {
      final y = 0.08 + i * 0.105;
      canvas.drawLine(Offset(-0.072, y), Offset(0.072, y + 0.014), segment);
    }
    for (var i = 0; i < 7; i++) {
      final angle = i * math.pi * 2 / 7;
      canvas.drawCircle(
        Offset(math.cos(angle) * 0.105, -0.21 + math.sin(angle) * 0.12),
        0.078,
        Paint()..color = palette.body.withValues(alpha: opacity),
      );
    }
    canvas.drawOval(
      const Rect.fromLTWH(-0.095, -0.335, 0.17, 0.2),
      Paint()..color = cream.withValues(alpha: opacity * 0.7),
    );
    canvas.drawCircle(const Offset(0, -0.385), 0.106, detail);

    final antenna = Paint()
      ..color = palette.body.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 0.027;
    for (final side in const [-1.0, 1.0]) {
      canvas.drawPath(
        Path()
          ..moveTo(side * 0.055, -0.43)
          ..quadraticBezierTo(side * 0.15, -0.72, side * 0.34, -0.78),
        antenna,
      );
      canvas.drawCircle(
        Offset(side * 0.34, -0.78),
        0.032,
        Paint()..color = cream.withValues(alpha: opacity),
      );
    }
    canvas.restore();
  }
}
