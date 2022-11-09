import 'package:flutter/material.dart';
import 'package:game_template/src/audio/sounds.dart';

import '../audio/audio_controller.dart';
import 'Sprite.dart';

class Asteroid extends Sprite implements Collidable {
  final double size;
  final double speed = 3;

  final _audioController = AudioController();

  Asteroid(double x, double y, double width, double height, this.size)
      : super(
          x,
          y,
          width * size,
          height * size,
          Image.asset(
            'assets/sprite_images/asteroids/space_rocks/asteroid1.png',
            width: double.infinity,
            height: double.infinity,
          ),
        );

  void move() {
    this.y += speed * size;
  }

  @override
  void onCollide(collideType source) {
    // TODO: implement onCollide
    _audioController.playSfx(SfxType.asteroidExplosion);
  }
}