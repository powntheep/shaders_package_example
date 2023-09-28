library shaders_test;

import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class FlutterSpace extends FlameGame with PanDetector, KeyboardEvents {
  final FragmentProgram program;
  Vector2 lastTapPoint = Vector2.zero();
  FlutterSpace(
    this.program,
  );

  late final SpaceComponent space;

  @override
  Future<void>? onLoad() async {
    space = SpaceComponent();
    await add(space);
  }
}

class SpaceComponent extends PositionComponent with HasGameRef<FlutterSpace> {
  double time = 0;

  SpaceComponent()
      : super(
          position: Vector2.zero(),
        );

  @override
  void update(double dt) {
    time += dt / 6;
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    final resolution = Vector2(gameRef.size.x, gameRef.size.y);
    final shader = gameRef.program.fragmentShader();
    shader.setFloat(0, resolution.x);
    shader.setFloat(1, resolution.y);
    shader.setFloat(2, time);
    shader.setFloat(3, gameRef.lastTapPoint.x);
    shader.setFloat(4, gameRef.lastTapPoint.y);

    final paint = Paint()..shader = shader;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, gameRef.size.x, gameRef.size.y),
      paint,
    );
  }
}

class SpaceShader extends StatelessWidget {
  const SpaceShader({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FragmentProgram.fromAsset('assets/shaders/space.frag'),
        builder: (context, snapshot) {
          final program = snapshot.data;

          if (program != null) {
            return GameWidget(
              game: FlutterSpace(program),
            );
          }

          return const SizedBox();
        });
  }
}

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}
