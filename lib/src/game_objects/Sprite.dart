import 'package:game_template/src/game_objects/HitBox.dart';
import 'package:flutter/material.dart';

class Sprite extends HitBox {
  Image image;

  Sprite(super.x, super.y, super.width, super.height, super.id, this.image);

  change(Image newImage) {
    image = newImage;
  }
}
