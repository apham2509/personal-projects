import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/core_providers.dart';

/// A local photo or a tiny, cat-eared monogram. The rune-based palette choice
/// is stable across launches and Dart runtimes; initials use forest ink with
/// strong contrast on every background.
class CatAvatar extends ConsumerWidget {
  const CatAvatar({
    super.key,
    required this.name,
    required this.photoPath,
    this.radius = 44,
  });

  final String name;
  final String? photoPath;
  final double radius;

  static const _palette = [
    Color(0xFFD9E6CD),
    Color(0xFFD1E2DF),
    Color(0xFFF0DFC8),
    Color(0xFFE4DBE9),
    Color(0xFFF3D7C6),
    Color(0xFFD0E5DA),
  ];
  static const _ink = Color(0xFF2C4638);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = photoPath;
    if (path != null) {
      final file = ref.watch(fileServiceProvider).resolve(path);
      if (file.existsSync()) {
        return CircleAvatar(radius: radius, backgroundImage: FileImage(file));
      }
    }
    final cleanName = name.trim();
    final colourIndex = cleanName.runes.fold<int>(
      0,
      (hash, rune) => (hash * 31 + rune) % _palette.length,
    );
    return CircleAvatar(
      radius: radius,
      backgroundColor: _palette[colourIndex],
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(child: CustomPaint(painter: _MonogramEarsPainter())),
          Padding(
            padding: EdgeInsets.only(top: radius * 0.22),
            child: cleanName.isEmpty
                ? Icon(Icons.pets_outlined, size: radius * 0.7, color: _ink)
                : Text(
                    cleanName.characters.first.toUpperCase(),
                    // Decorative initials retain their proportions at large
                    // text sizes; the full name beside the avatar still scales.
                    textScaler: TextScaler.noScaling,
                    style: TextStyle(
                      fontSize: radius * 0.82,
                      fontWeight: FontWeight.w600,
                      height: 1,
                      color: _ink,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _MonogramEarsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width, size.height);
    canvas.drawPath(
      Path()
        ..moveTo(0.26, 0.36)
        ..lineTo(0.25, 0.18)
        ..quadraticBezierTo(0.26, 0.15, 0.29, 0.18)
        ..lineTo(0.4, 0.29)
        ..moveTo(0.62, 0.29)
        ..lineTo(0.74, 0.18)
        ..quadraticBezierTo(0.77, 0.15, 0.77, 0.19)
        ..lineTo(0.75, 0.36),
      Paint()
        ..color = CatAvatar._ink.withValues(alpha: 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.025
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_MonogramEarsPainter oldDelegate) => false;
}
