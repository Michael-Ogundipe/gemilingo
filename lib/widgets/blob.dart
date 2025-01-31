import 'package:flutter/material.dart';

class Blob extends StatelessWidget {
  final double rotation;
  final Color color;
  final double scale;

  const Blob({
    super.key,
    required this.color,
    this.rotation = 0,
    this.scale = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(150),
              topRight: Radius.circular(240),
              bottomLeft: Radius.circular(220),
              bottomRight: Radius.circular(180),
            ),
          ),
        ),
      ),
    );
  }
}
