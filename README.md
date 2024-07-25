# Flutter Animated Shader Demo

Ce projet démontre l'utilisation de shaders personnalisés avec des animations dans Flutter. Il combine l'utilisation de `FragmentShader` avec des animations personnalisées pour créer des effets visuels dynamiques.

## Fonctionnalités

- Utilisation de shaders GLSL personnalisés
- Animations fluides basées sur `CustomPainter`
- Dessin de formes géométriques animées (cercles, courbes de Bézier)
- Intégration de `FragmentShader` avec des animations Flutter

## Comment ça marche

### Shader GLSL

Le shader GLSL (`my_shader.frag`) définit l'apparence de base :

```glsl
#version 460 core
#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform vec4 uColor;
out vec4 FragColor;

void main() {
    FragColor = uColor;
}

```

## Classe MayPainter

La classe `MayPainter` étend `CustomPainter` et gère le rendu des animations :

```dart
 MayPainter extends CustomPainter {
  MayPainter(this.color, {required this.shader, required this.animation})
      : super(repaint: animation);

  final Color color;
  final FragmentShader shader;
  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    // ... (code de peinture)
  }

  @override
  bool shouldRepaint(MayPainter oldDelegate) =>
      color != oldDelegate.color || animation != oldDelegate.animation;
}
```

## Widget AnimatedShaderWidget

Ce widget StatefulWidget gère l'animation :

```dart
class AnimatedShaderWidget extends StatefulWidget {
  const AnimatedShaderWidget({Key? key}) : super(key: key);

  @override
  _AnimatedShaderWidgetState createState() => _AnimatedShaderWidgetState();
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
```

## Installation

1. Assurez-vous d'avoir Flutter installé sur votre machine.

2. Clonez ce dépôt :

```bash
git clone https://github.com/votre-nom-utilisateur/flutter-animated-shader-demo.git
```

3. Naviguez dans le répertoire du projet :

```bash
cd flutter-animated-shader-demo
```

4. Obtenez les dépendances :

```dart
flutter pub get
```

5. Exécutez l'application :

```dart
flutter run
```

## Personnalisation

- Modifiez le dossier ```assets/shader/my_shader.frag``` pour changer l'apparence du shader.
- Ajustez les animations dans la méthode ```paint``` de ```MayPainter```.
- Expérimentez avec différentes durées d'animation dans ```AnimatedShaderWidget```.

## Contribution

Les contributions sont les bienvenues ! N'hésitez pas à ouvrir une issue ou à soumettre une pull request.

## Demo

