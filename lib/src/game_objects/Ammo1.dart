import 'package:flutter/material.dart';

import 'Sprite.dart';

class Ammo1 extends Sprite implements Collidable {
  final double speed = 12;

  Ammo1(double x, double y, double width, double height)
      : super(
          x,
          y,
          width,
          height,
          Image.asset('assets/sprite_images/beams/cyan_beam.png'),
        );

  void move() {
    this.y -= speed;
  }

  @override
  void onCollide(collideType source) {
    // TODO: implement onCollide
  }
}
