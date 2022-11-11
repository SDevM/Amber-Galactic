import 'package:flutter/material.dart';
import 'package:game_template/src/game_objects/Sprite.dart';

class PowerUp extends Sprite {
  final power powerUp;

  PowerUp(double x, double y, double width, double height, this.powerUp)
      : super(x, y, width, height, images[powerUp]!);

  void move(bool left) {
    this.y += 4;
    this.x += left ? -3 : 3;
  }
}

Map<power, Image> images = {
  power.AMMO: Image.asset(
    'assets/sprite_images/blast.png',
    width: double.infinity,
    height: double.infinity,
  ),
  power.SHIELD: Image.asset(
    'assets/sprite_images/shield.png',
    width: double.infinity,
    height: double.infinity,
  ),
};

enum power {
  AMMO,
  SHIELD,
}
