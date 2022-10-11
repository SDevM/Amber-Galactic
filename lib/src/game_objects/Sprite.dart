import 'package:game_template/src/game_objects/HitBox.dart';
import 'package:flutter/material.dart';

class Sprite extends HitBox {
  Image image;

  Sprite(super.x, super.y, super.width, super.height, this.image);

  change(Image newImage) {
    image = newImage;
  }
}

abstract class Collidable {
  void onCollide(collideType source) {}
}

enum collideType {
  ASTEROID,
  POWER_UP_AMMO,
  POWER_UP_SHIELD,
}