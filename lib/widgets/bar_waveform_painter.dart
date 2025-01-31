import 'dart:math';

import 'package:flutter/material.dart';

class BarWaveformPainter extends CustomPainter {
  final double animation;
  final bool isPlaying;
  final Color waveColor;

  BarWaveformPainter({
    required this.animation,
    required this.isPlaying,
    this.waveColor = Colors.red,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor.withOpacity(isPlaying ? 0.8 : 0.5)
      ..style = PaintingStyle.fill;

    final centerY = size.height / 2;
    final barWidth = 4.0;
    final spacing = 3.0;
    final totalBars = (size.width / (barWidth + spacing)).floor();

    for (var i = 0; i < totalBars; i++) {
      // Generate heights using sine waves with different frequencies
      final progress = (i / totalBars) + animation;
      final heightMultiplier = 0.8 - (0.4 * (i / totalBars - 0.5).abs() * 2);

      // Combine multiple sine waves for more natural movement
      final height = isPlaying
          ? size.height * 0.4 * heightMultiplier * (
          0.6 * sin(progress * 2 * pi) +
              0.3 * sin(progress * 4 * pi + 0.4) +
              0.1 * sin(progress * 8 * pi + 0.8)
      ).abs()
          : size.height * 0.15 * heightMultiplier;

      // Draw the bar
      final x = i * (barWidth + spacing);
      final rect = Rect.fromLTRB(
        x,
        centerY - height / 2,
        x + barWidth,
        centerY + height / 2,
      );

      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(BarWaveformPainter oldDelegate) {
    return oldDelegate.animation != animation ||
        oldDelegate.isPlaying != isPlaying ||
        oldDelegate.waveColor != waveColor;
  }
}