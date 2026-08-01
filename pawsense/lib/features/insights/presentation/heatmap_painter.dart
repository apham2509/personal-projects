import 'package:flutter/material.dart';

import '../domain/insight_models.dart';

/// Paw-touch heatmap: catching touches build the warm primary layer;
/// misses and edge touches shade a neutral layer underneath, so hunting
/// hot-spots and fruitless hammering are visually distinct.
class HeatmapPainter extends CustomPainter {
  HeatmapPainter({
    required this.heatmap,
    required this.hitColour,
    required this.otherColour,
    required this.gridColour,
  });

  final TouchHeatmap heatmap;
  final Color hitColour;
  final Color otherColour;
  final Color gridColour;

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / heatmap.columns;
    final cellHeight = size.height / heatmap.rows;
    final maxCount = heatmap.maxCellCount();
    if (maxCount == 0) return;

    for (var row = 0; row < heatmap.rows; row++) {
      for (var column = 0; column < heatmap.columns; column++) {
        final rect = Rect.fromLTWH(
          column * cellWidth,
          row * cellHeight,
          cellWidth,
          cellHeight,
        ).deflate(1);
        final other = heatmap.otherCounts[row][column];
        if (other > 0) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(rect, const Radius.circular(3)),
            Paint()
              ..color = otherColour.withValues(
                alpha: 0.15 + 0.5 * (other / maxCount),
              ),
          );
        }
        final hits = heatmap.hitCounts[row][column];
        if (hits > 0) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(rect, const Radius.circular(3)),
            Paint()
              ..color = hitColour.withValues(
                alpha: 0.25 + 0.65 * (hits / maxCount),
              ),
          );
        }
      }
    }

    final gridPaint = Paint()
      ..color = gridColour.withValues(alpha: 0.25)
      ..strokeWidth = 0.5;
    for (var column = 1; column < heatmap.columns; column++) {
      canvas.drawLine(
        Offset(column * cellWidth, 0),
        Offset(column * cellWidth, size.height),
        gridPaint,
      );
    }
    for (var row = 1; row < heatmap.rows; row++) {
      canvas.drawLine(
        Offset(0, row * cellHeight),
        Offset(size.width, row * cellHeight),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant HeatmapPainter oldDelegate) =>
      oldDelegate.heatmap != heatmap;
}
