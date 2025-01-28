import 'dart:math' show pi;

import 'package:flutter/material.dart';

import 'blob.dart';

class Microphone extends StatefulWidget {
  const Microphone({
    super.key,
    required this.isRecording,
    required this.icon,
    required this.onPressed,
  });

  final bool isRecording;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  State<Microphone> createState() => _MicrophoneState();
}

class _MicrophoneState extends State<Microphone>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation =
        Tween<double>(begin: 0.0, end: 2 * pi).animate(_rotationController);

    _rotationController.repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _rotationController,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              if (widget.isRecording) ...[
                Blob(
                    color: const Color(0xff0092ff), rotation: _animation.value),
                Blob(
                    color: const Color(0xff4ac7b7),
                    rotation: _animation.value * 2 - 30),
                Blob(
                    color: const Color(0xffa4a6f6),
                    rotation: _animation.value * 3 - 45),
              ],
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Color(0XFF5CABC0)),
                child: InkWell(
                  onTap: widget.onPressed,
                  child: Icon(
                    widget.icon,
                    size: 36,
                  ),
                ),
              )
              //   ],
            ],
          );
        });
  }
}
