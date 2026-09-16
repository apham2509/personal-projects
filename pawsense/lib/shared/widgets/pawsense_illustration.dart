import 'package:flutter/material.dart';

/// Small variations of the same original PawSense cat. These are decorative
/// owner-screen illustrations, never targets on the cat-facing play surface.
enum PawSenseIllustrationVariant { welcome, privacy, safety, resting }

/// Original, resolution-independent Canvas artwork; no downloaded assets,
/// image decoding, timers or repeating animations. Wrap in `OwnerEntrance`
/// at the screen level when a short entrance is appropriate.
class PawSenseIllustration extends StatelessWidget {
  const PawSenseIllustration({
    super.key,
    this.size = 180,
    this.variant = PawSenseIllustrationVariant.welcome,
  });

  final double size;
  final PawSenseIllustrationVariant variant;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ExcludeSemantics(
      child: RepaintBoundary(
        child: SizedBox.square(
          dimension: size,
          child: CustomPaint(
            painter: _CatIllustrationPainter(
              variant: variant,
              dark: scheme.brightness == Brightness.dark,
            ),
          ),
        ),
      ),
    );
  }
}

class _CatIllustrationPainter extends CustomPainter {
  const _CatIllustrationPainter({required this.variant, required this.dark});

  final PawSenseIllustrationVariant variant;
  final bool dark;

  static const _ink = Color(0xFF2C4638);
  static const _fur = Color(0xFFE3B895);
  static const _lightFur = Color(0xFFF5DDC4);
  static const _patch = Color(0xFFBE8061);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 200, size.height / 200);
    final backdrop = dark ? const Color(0xFF33493A) : const Color(0xFFE3EADC);
    final leaf = dark ? const Color(0xFF8FAB91) : const Color(0xFF9AB29C);
    final softPeach = dark ? const Color(0xFF73513D) : const Color(0xFFF2D9C4);

    // A quiet, asymmetrical garden shape behind the silhouette.
    canvas.drawPath(
      Path()
        ..moveTo(30, 151)
        ..cubicTo(4, 109, 20, 62, 61, 43)
        ..cubicTo(94, 23, 162, 33, 177, 73)
        ..cubicTo(196, 124, 162, 177, 109, 181)
        ..cubicTo(70, 184, 40, 174, 30, 151)
        ..close(),
      Paint()..color = backdrop,
    );
    canvas.drawCircle(const Offset(159, 41), 14, Paint()..color = softPeach);
    canvas.drawCircle(const Offset(37, 44), 3, Paint()..color = leaf);
    canvas.drawCircle(const Offset(180, 135), 3.5, Paint()..color = leaf);
    _drawSprig(canvas, const Offset(27, 127), leaf);

    // Grounding shadow and a curling tail, behind the sitting cat.
    canvas.drawOval(
      const Rect.fromLTWH(53, 168, 109, 13),
      Paint()..color = _ink.withValues(alpha: dark ? 0.25 : 0.08),
    );
    canvas.drawPath(
      Path()
        ..moveTo(126, 160)
        ..cubicTo(164, 180, 177, 141, 154, 124),
      Paint()
        ..color = _patch
        ..style = PaintingStyle.stroke
        ..strokeWidth = 17
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      Path()
        ..moveTo(150, 164)
        ..quadraticBezierTo(166, 159, 166, 146),
      Paint()
        ..color = _fur
        ..style = PaintingStyle.stroke
        ..strokeWidth = 17
        ..strokeCap = StrokeCap.round,
    );

    // Pear-shaped body, cream bib and two soft paws.
    canvas.drawPath(
      Path()
        ..moveTo(80, 94)
        ..cubicTo(63, 112, 56, 142, 65, 169)
        ..quadraticBezierTo(99, 181, 136, 167)
        ..cubicTo(138, 132, 124, 102, 119, 95)
        ..close(),
      Paint()..color = _fur,
    );
    canvas.drawOval(
      const Rect.fromLTWH(80, 105, 40, 58),
      Paint()..color = _lightFur,
    );
    final line = Paint()
      ..color = _patch
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(
      Path()
        ..moveTo(83, 141)
        ..lineTo(80, 166)
        ..moveTo(116, 141)
        ..lineTo(119, 166),
      line,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(66, 159, 29, 14),
        const Radius.circular(7),
      ),
      Paint()..color = _lightFur,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(106, 159, 29, 14),
        const Radius.circular(7),
      ),
      Paint()..color = _lightFur,
    );

    // Rounded triangular ears and the broad, friendly face.
    canvas.drawPath(
      Path()
        ..moveTo(66, 79)
        ..quadraticBezierTo(59, 47, 65, 43)
        ..quadraticBezierTo(70, 41, 87, 62)
        ..lineTo(118, 63)
        ..quadraticBezierTo(137, 42, 141, 46)
        ..quadraticBezierTo(146, 51, 135, 83)
        ..close(),
      Paint()..color = _fur,
    );
    canvas.drawPath(
      Path()
        ..moveTo(68, 53)
        ..lineTo(69, 72)
        ..lineTo(80, 64)
        ..close()
        ..moveTo(136, 56)
        ..lineTo(124, 66)
        ..lineTo(134, 72)
        ..close(),
      Paint()..color = _patch,
    );
    canvas.drawPath(
      Path()
        ..moveTo(65, 75)
        ..cubicTo(72, 58, 126, 57, 139, 77)
        ..cubicTo(151, 94, 134, 114, 104, 115)
        ..cubicTo(74, 119, 48, 99, 65, 75)
        ..close(),
      Paint()..color = _fur,
    );
    canvas.drawPath(
      Path()
        ..moveTo(100, 65)
        ..quadraticBezierTo(88, 81, 80, 92)
        ..quadraticBezierTo(78, 110, 103, 112)
        ..quadraticBezierTo(128, 109, 126, 94)
        ..quadraticBezierTo(110, 78, 100, 65),
      Paint()..color = _lightFur,
    );
    final faceLine = Paint()
      ..color = _ink
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.3
      ..style = PaintingStyle.stroke;
    final sleepy =
        variant == PawSenseIllustrationVariant.resting ||
        variant == PawSenseIllustrationVariant.safety;
    if (sleepy) {
      canvas.drawPath(
        Path()
          ..moveTo(76, 86)
          ..quadraticBezierTo(82, 92, 88, 86)
          ..moveTo(116, 86)
          ..quadraticBezierTo(122, 92, 128, 86),
        faceLine,
      );
    } else {
      for (final x in [82.0, 122.0]) {
        canvas.drawOval(
          Rect.fromCenter(center: Offset(x, 87), width: 5, height: 8),
          Paint()..color = _ink,
        );
        canvas.drawCircle(Offset(x + 0.6, 85.5), 1, Paint()..color = _lightFur);
      }
    }
    canvas.drawPath(
      Path()
        ..moveTo(98, 94)
        ..quadraticBezierTo(103, 91, 108, 94)
        ..lineTo(103, 99)
        ..close(),
      Paint()..color = _patch,
    );
    canvas.drawPath(
      Path()
        ..moveTo(103, 98)
        ..lineTo(103, 102)
        ..quadraticBezierTo(99, 106, 95, 102)
        ..moveTo(103, 102)
        ..quadraticBezierTo(107, 106, 111, 102),
      faceLine..strokeWidth = 1.7,
    );
    canvas.drawPath(
      Path()
        ..moveTo(71, 95)
        ..lineTo(55, 92)
        ..moveTo(72, 100)
        ..lineTo(58, 104)
        ..moveTo(133, 94)
        ..lineTo(148, 91)
        ..moveTo(132, 100)
        ..lineTo(146, 104),
      faceLine..color = _ink.withValues(alpha: 0.55),
    );

    switch (variant) {
      case PawSenseIllustrationVariant.welcome:
        _drawFish(canvas, const Offset(153, 84));
      case PawSenseIllustrationVariant.privacy:
        _drawBadge(canvas, lock: true);
      case PawSenseIllustrationVariant.safety:
        _drawBadge(canvas, lock: false);
      case PawSenseIllustrationVariant.resting:
        break;
    }
    canvas.restore();
  }

  void _drawSprig(Canvas canvas, Offset offset, Color colour) {
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.drawPath(
      Path()
        ..moveTo(5, 29)
        ..quadraticBezierTo(9, 15, 3, 0),
      Paint()
        ..color = colour
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      Path()
        ..moveTo(6, 17)
        ..quadraticBezierTo(-6, 15, -6, 3)
        ..quadraticBezierTo(7, 4, 6, 17)
        ..close()
        ..moveTo(6, 24)
        ..quadraticBezierTo(21, 18, 20, 9)
        ..quadraticBezierTo(7, 9, 6, 24)
        ..close(),
      Paint()..color = colour,
    );
    canvas.restore();
  }

  void _drawFish(Canvas canvas, Offset offset) {
    canvas.save();
    canvas.translate(offset.dx, offset.dy);
    canvas.rotate(-0.25);
    final colour = dark ? const Color(0xFFABD0C4) : const Color(0xFF70968A);
    canvas.drawPath(
      Path()
        ..moveTo(-13, 0)
        ..quadraticBezierTo(0, -16, 12, 0)
        ..quadraticBezierTo(0, 16, -13, 0)
        ..close()
        ..moveTo(9, 0)
        ..lineTo(21, -9)
        ..lineTo(21, 9)
        ..close(),
      Paint()..color = colour,
    );
    canvas.drawCircle(const Offset(-6, -1), 1.5, Paint()..color = _ink);
    canvas.restore();
  }

  void _drawBadge(Canvas canvas, {required bool lock}) {
    canvas.drawCircle(
      const Offset(154, 134),
      22,
      Paint()..color = dark ? const Color(0xFFDBE9D5) : const Color(0xFFFFFCF5),
    );
    if (lock) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(145, 131, 18, 15),
          const Radius.circular(4),
        ),
        Paint()..color = _ink,
      );
      canvas.drawArc(
        const Rect.fromLTWH(148, 120, 12, 18),
        3.14159,
        3.14159,
        false,
        Paint()
          ..color = _ink
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3,
      );
      canvas.drawCircle(const Offset(154, 137), 2, Paint()..color = _lightFur);
    } else {
      canvas.drawPath(
        Path()
          ..moveTo(154, 144)
          ..cubicTo(134, 133, 143, 118, 154, 129)
          ..cubicTo(165, 118, 174, 133, 154, 144)
          ..close(),
        Paint()..color = _patch,
      );
    }
  }

  @override
  bool shouldRepaint(_CatIllustrationPainter oldDelegate) =>
      variant != oldDelegate.variant || dark != oldDelegate.dark;
}
