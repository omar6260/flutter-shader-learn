import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';


import 'package:my_shader_app/presentation/widget/Animated_shader_widget.dart';

late FragmentProgram fragmentProgram;
Future<void> main() async {
  fragmentProgram = await FragmentProgram.fromAsset(
    'assets/shader/my_shader.frag',
  );
  runApp(const AnimatedShaderWidget());
}
