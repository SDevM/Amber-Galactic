import 'package:flutter/material.dart';

import 'Sprite.dart';

class Shield extends Sprite implements Collidable {
  int lives = 2;
  bool immune = false;

  Shield(double x, double y, double width, double height)
      : super(
          x,
          y,
          width,
          height,
          Image.asset(
            'assets/sprite_images/explosions/2d-special-effects/light_glow_effect/light_glow_07.png',
          ),
        );

  @override
  void onCollide(collideType source) {
    if (source == collideType.ASTEROID) {
      if (!immune) {
        lives--;
        immune = true;
        Future.delayed(Duration(seconds: 2), () {
          immune = false;
        });
      }
    }
    print('Lives reduced: $lives');
  }
}
