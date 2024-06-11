import 'dart:async';

import 'package:car_flame/game/car_race.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

class BackGround extends ParallaxComponent<CarRace> {
  double backgroundSpeed = 2; // Initial speed value
  @override
  FutureOr<void> onLoad() async {
    parallax = await game.loadParallax(
      [
        ParallaxImageData('game/road1.png'),
        ParallaxImageData('game/road1.png'),
      ],
      fill: LayerFill.width,
      repeat: ImageRepeat.repeat,
      baseVelocity: Vector2(0, -70 * backgroundSpeed.toDouble()),
      velocityMultiplierDelta: Vector2(0, 1.2 * backgroundSpeed),
    );
  }
}
