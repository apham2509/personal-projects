import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/core_providers.dart';

/// Circular avatar: profile photo when present, otherwise the cat's initial
/// on a colour derived from the name (stable across launches).
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
    Color(0xFF7A9E7E),
    Color(0xFF6B8CAE),
    Color(0xFFB08968),
    Color(0xFF9C7BA8),
    Color(0xFFC98A6B),
    Color(0xFF5E9387),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = photoPath;
    if (path != null) {
      final file = ref.watch(fileServiceProvider).resolve(path);
      if (file.existsSync()) {
        return CircleAvatar(radius: radius, backgroundImage: FileImage(file));
      }
    }
    final colour = _palette[name.hashCode.abs() % _palette.length];
    final initial = name.isEmpty ? '?' : name.characters.first.toUpperCase();
    return CircleAvatar(
      radius: radius,
      backgroundColor: colour,
      child: Text(
        initial,
        style: TextStyle(
          fontSize: radius * 0.9,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
