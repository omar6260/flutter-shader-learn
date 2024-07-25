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

/// Custom painter
/// The painter draws a circle, a path, and concentric circles
/// The circle is animated with a sinusoidal function to create a pulsating effect
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

    /// Animated circle radius with a sinusoidal function to create a pulsating effect
    /// The radius is animated from 80 to 120
    /// The sinusoidal function is defined as: 100 * (1 + sin(progress * 2 * pi) * 0.2)
    /// The progress value is between 0 and 1
    final animatedRadius = 100 * (1 + math.sin(progress * 2 * math.pi) * 0.2);
    canvas.drawCircle(center, animatedRadius, Paint()..color = Colors.red);
    canvas.drawCircle(center, animatedRadius, Paint()..shader = shader);

    /// Stroke paint
    /// The paint object is created with a color, stroke width, and style
    /// The color is set to the color passed to the painter
    /// The stroke width is set to 5
    /// ?The style is set to [PaintingStyle.stroke]
    final paint = Paint()
      ..color = color
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    /// Animated path
    /// The path is created with a quadratic bezier curve
    /// The curve is defined by the center of the screen, the center of the screen plus a sinusoidal function, and the bottom right corner of the screen
    /// The sinusoidal function creates a wave-like effect
    /// The progress value is used to animate the curve
    /// The curve is drawn with the paint object
    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(
      size.width / 2,
      size.height / 2 + math.sin(progress * 2 * math.pi) * 50,
      size.width,
      size.height,
    );
    canvas.drawPath(path, paint);

    /// Concentric circles
    /// The circles are drawn with decreasing radii
    /// The radii are calculated using a geometric progression
    /// The paint object is used to draw the circles
    /// The circles are drawn with a decreasing alpha value
    for (var i = 0; i < 4; i++) {
      final radius = animatedRadius * math.pow(0.5, i);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(MayPainter oldDelegate) =>
      color != oldDelegate.color || animation != oldDelegate.animation;
}
