import 'dart:math' as math;
import 'dart:ui';

import 'prey_component.dart';

/// A small jade-blue fish with a pearly flank, flowing forked tail and
/// delicate fin rays. All animation stays inside its circular art envelope.
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
    body: Color(0xFF91C9C9),
    accent: Color(0xFF4C929A),
    detail: Color(0xFF163B40),
  );

  static const highContrastPalette = PreyPalette(
    body: Color(0xFFBDEBF5),
    accent: Color(0xFF8FD2E2),
    detail: Color(0xFF06181D),
  );

  @override
  void renderPrey(Canvas canvas, double radius, double opacity) {
    canvas.save();
    canvas.scale(radius);
    final swim = math.sin(elapsed * 7.2 + animationPhase);
    final follow = math.sin(elapsed * 7.2 + animationPhase - 0.7);
    final tailSway = swim * 0.055;
    canvas.rotate(follow * 0.028);

    final pearl = Color.lerp(palette.body, const Color(0xFFFFF6D8), 0.65)!;
    final dark = Color.lerp(palette.accent, palette.detail, 0.28)!;
    final fin = Paint()
      ..shader =
          Gradient.linear(const Offset(-0.42, 0), const Offset(-0.92, 0), [
            palette.accent.withValues(alpha: opacity),
            palette.body.withValues(alpha: opacity),
          ]);
    final ray = Paint()
      ..color = pearl.withValues(alpha: opacity * 0.48)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 0.016;

    // Rounded forked tail: its furthest tip is under 1.03 radii even at
    // maximum sway. Fin rays follow the same phase as the outline.
    final tail = Path()
      ..moveTo(-0.4, 0)
      ..cubicTo(-0.64, -0.03, -0.71, -0.31 + tailSway, -0.92, -0.4 + tailSway)
      ..quadraticBezierTo(-0.93, -0.17 + tailSway, -0.74, tailSway)
      ..quadraticBezierTo(-0.93, 0.17 + tailSway, -0.92, 0.4 + tailSway)
      ..cubicTo(-0.7, 0.31 + tailSway, -0.62, 0.05, -0.4, 0)
      ..close();
    canvas.drawPath(tail, fin);
    for (final side in const [-1.0, 1.0]) {
      canvas.drawPath(
        Path()
          ..moveTo(-0.49, 0)
          ..quadraticBezierTo(
            -0.71,
            side * 0.15 + tailSway,
            -0.87,
            side * 0.31 + tailSway,
          ),
        ray,
      );
    }

    // Dorsal and ventral fins emerge behind the main body.
    canvas.drawPath(
      Path()
        ..moveTo(-0.29, -0.27)
        ..quadraticBezierTo(-0.26, -0.64 + follow * 0.025, 0.1, -0.68)
        ..quadraticBezierTo(0.03, -0.5, 0.34, -0.35)
        ..close(),
      fin,
    );
    canvas.drawPath(
      Path()
        ..moveTo(-0.21, 0.28)
        ..quadraticBezierTo(-0.15, 0.58, 0.14, 0.58)
        ..lineTo(0.25, 0.31)
        ..close(),
      fin,
    );
    canvas.drawLine(
      const Offset(-0.16, -0.37),
      const Offset(0.025, -0.58),
      ray,
    );
    canvas.drawLine(const Offset(-0.05, 0.35), const Offset(0.1, 0.51), ray);

    final bodyPath = Path()
      ..moveTo(0.91, 0)
      ..cubicTo(0.71, -0.38, 0.21, -0.58, -0.22, -0.36)
      ..quadraticBezierTo(-0.44, -0.25, -0.56, 0)
      ..quadraticBezierTo(-0.44, 0.26, -0.19, 0.37)
      ..cubicTo(0.24, 0.56, 0.75, 0.3, 0.91, 0)
      ..close();
    canvas.drawPath(
      bodyPath,
      Paint()
        ..shader = Gradient.linear(
          const Offset(0, -0.48),
          const Offset(0.1, 0.46),
          [
            dark.withValues(alpha: opacity),
            palette.body.withValues(alpha: opacity),
            pearl.withValues(alpha: opacity),
            palette.accent.withValues(alpha: opacity),
          ],
          const [0, 0.38, 0.68, 1],
        ),
    );

    // A curved lateral stripe and a few crescent scales are deliberately
    // quiet: the fish remains a clear shape at the smallest target size.
    canvas.drawPath(
      Path()
        ..moveTo(-0.36, -0.07)
        ..quadraticBezierTo(0.02, -0.26, 0.43, -0.17),
      Paint()
        ..color = pearl.withValues(alpha: opacity * 0.55)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 0.024,
    );
    final scaleLine = Paint()
      ..color = dark.withValues(alpha: opacity * 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.014;
    for (var i = 0; i < 3; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(-0.13 + i * 0.16, 0.035), radius: 0.085),
        -math.pi * 0.36,
        math.pi * 0.72,
        false,
        scaleLine,
      );
    }

    final sideFin = Path()
      ..moveTo(0.16, 0.06)
      ..quadraticBezierTo(-0.13, 0.19 + follow * 0.03, -0.05, 0.36)
      ..quadraticBezierTo(0.19, 0.37, 0.3, 0.16)
      ..close();
    canvas.drawPath(
      sideFin,
      Paint()..color = palette.accent.withValues(alpha: opacity * 0.85),
    );
    canvas.drawLine(const Offset(0.17, 0.12), const Offset(0.035, 0.29), ray);

    canvas.drawPath(
      Path()
        ..moveTo(0.39, -0.26)
        ..quadraticBezierTo(0.25, -0.04, 0.42, 0.23),
      Paint()
        ..color = dark.withValues(alpha: opacity * 0.7)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 0.029,
    );
    canvas.drawCircle(
      const Offset(0.6, -0.115),
      0.111,
      Paint()..color = pearl.withValues(alpha: opacity),
    );
    canvas.drawCircle(
      const Offset(0.615, -0.115),
      0.074,
      Paint()..color = palette.detail.withValues(alpha: opacity),
    );
    canvas.drawCircle(
      const Offset(0.637, -0.142),
      0.024,
      Paint()..color = const Color(0xFFFFFFFF).withValues(alpha: opacity),
    );
    canvas.drawLine(
      const Offset(0.819, 0.054),
      const Offset(0.864, 0.03),
      Paint()
        ..color = dark.withValues(alpha: opacity * 0.75)
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 0.021,
    );
    canvas.restore();
  }
}
