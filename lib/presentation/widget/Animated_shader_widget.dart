
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:my_shader_app/main.dart';

class AnimatedShaderWidget extends StatefulWidget {
  const AnimatedShaderWidget({super.key});

  @override
  State<AnimatedShaderWidget> createState() => _AnimatedShaderWidgetState();
}

class _AnimatedShaderWidgetState extends State<AnimatedShaderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MayPainter(
        Colors.green,
        shader: fragmentProgram.fragmentShader(),
        animation: _controller,
      ),
    );
  }
}

class MayPainter extends CustomPainter {
  MayPainter(this.color, {required this.shader, required this.animation})
      : super(repaint: animation);

  final Color color;
  final FragmentShader shader;
  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final progress = animation.value;
    final center = Offset(size.width / 2, size.height / 2);

    // Animated circle
    final animatedRadius = 100 * (1 + math.sin(progress * 2 * math.pi) * 0.2);
    canvas.drawCircle(center, animatedRadius, Paint()..color = Colors.red);
    canvas.drawCircle(center, animatedRadius, Paint()..shader = shader);

    // Stroke paint
    final paint = Paint()
      ..color = color
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    // Animated path
    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(
      size.width / 2,
      size.height / 2 + math.sin(progress * 2 * math.pi) * 50,
      size.width,
      size.height,
    );
    canvas.drawPath(path, paint);

    // Concentric circles
    for (var i = 0; i < 4; i++) {
      final radius = animatedRadius * math.pow(0.5, i);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(MayPainter oldDelegate) =>
      color != oldDelegate.color || animation != oldDelegate.animation;
}
