import 'package:flutter/material.dart';
import 'package:game_template/src/game_objects/Sprite.dart';

class PowerUp extends Sprite implements Collidable {
  final power powerUp;

  PowerUp(double x, double y, double width, double height, this.powerUp)
      : super(x, y, width, height, images[powerUp]!);

  void move(bool left) {
    this.y += 5;
    this.x += left ? -2 : 2;
  }

  @override
  void onCollide(collideType source) {
    // TODO: implement onCollide
  }
}

Map<power, Image> images = {
  power.AMMO : Image.asset('assets/sprite_images/blast.png'),
  power.SHIELD : Image.asset('assets/sprite_images/shield.png'),
};

enum power {
  AMMO,
  SHIELD,
}
