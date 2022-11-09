import 'package:flutter/material.dart';
import 'package:game_template/src/audio/audio_controller.dart';
import 'package:game_template/src/audio/sounds.dart';

import 'Sprite.dart';

class Ammo1 extends Sprite implements Collidable {
  final double speed = 12;
  final audioController = AudioController();

  Ammo1(double x, double y, double width, double height)
      : super(
          x,
          y,
          width,
          height,
          Image.asset(
            'assets/sprite_images/beams/cyan_beam.png',
            width: double.infinity,
            height: double.infinity,
          ),
        ) {
    audioController.playSfx(SfxType.laser);
  }

  void move() {
    this.y -= speed;
  }

  @override
  void onCollide(collideType source) {
    // TODO: implement onCollide
  }
}
