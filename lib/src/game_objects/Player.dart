import 'package:flutter/material.dart';
import 'package:game_template/src/audio/sounds.dart';
import 'package:game_template/src/game_objects/PowerUp.dart';

import '../audio/audio_controller.dart';
import 'Sprite.dart';

class Player extends Sprite implements Collidable {
  int lives = 3;
  Map<power, bool> powerUps = {
    power.AMMO: false,
    power.SHIELD: false,
  };
  int xOff = 0;
  bool immune = false;
  final _audioController = AudioController();

  Player(double x, double y, double width, double height)
      : super(
          x,
          y,
          width,
          height,
          Image.asset('assets/sprite_images/spaceships/ranger1.png'),
        );

  tickTime() {

  }

  void move(BoxConstraints bounds) {
    if (this.x + xOff >= 0 && this.x + xOff <= bounds.maxWidth - this.width)
      this.x += xOff;
    else if (this.x + xOff < 0)
      this.x = 0;
    else if (this.x + xOff > bounds.maxWidth - this.width)
      this.x = bounds.maxWidth - this.width;
  }

  void powerClear(power target) {
    powerUps[target] = false;
  }

  @override
  void onCollide(collideType source) {
    switch (source) {
      case (collideType.ASTEROID):
        if (!immune) {
          _audioController.playSfx(SfxType.shipExplosion);

          lives--;
          immune = true;
          Future.delayed(Duration(seconds: 2), () {
            immune = false;
          });
        }
        break;
      case (collideType.POWER_UP_AMMO):
        powerUps.values.forEach((element) {
          element = false;
        });
        powerUps[power.AMMO] = true;
        Future.delayed(Duration(seconds: 25), () {
          powerUps[power.AMMO] = false;
        });
        break;
      case (collideType.POWER_UP_SHIELD):
        lives++;
        if (lives > 3) lives = 3;
        powerUps.values.forEach((element) {
          element = false;
        });
        powerUps[power.SHIELD] = true;
        Future.delayed(Duration(seconds: 15), () {
          powerUps[power.SHIELD] = false;
        });
        break;
    }
  }
}
