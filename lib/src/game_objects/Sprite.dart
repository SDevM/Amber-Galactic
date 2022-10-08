import 'package:game_template/src/game_objects/HitBox.dart';
import 'package:flutter/material.dart';

class Sprite extends HitBox {
  AssetImage image;

  Sprite(super.x, super.y, super.width, super.height, super.id, this.image);

  change(AssetImage newImage) {
    image = newImage;
  }
}
