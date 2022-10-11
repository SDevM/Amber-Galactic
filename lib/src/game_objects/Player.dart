import 'package:flutter/material.dart';
import 'package:game_template/src/game_objects/PowerUp.dart';

import 'Sprite.dart';

class Player extends Sprite implements Collidable {
  int lives = 3;
  Map<power, bool> powerUps = {
    power.AMMO: true,
  };
  int xOff = 0;
  bool immune = false;

  Player(double x, double y, double width, double height)
      : super(
          x,
          y,
          width,
          height,
          Image.asset('assets/sprite_images/spaceships/ranger1.png'),
        );

  void move(BoxConstraints bounds) {
    if (this.x + xOff >= 0 && this.x + xOff <= bounds.maxWidth - this.width)
      this.x += xOff;
    else if (this.x + xOff < 0)
      this.x = 0;
    else if (this.x + xOff > bounds.maxWidth - this.width)
      this.x = bounds.maxWidth - this.width;
  }

  @override
  void onCollide(collideType source) {
    // TODO: implement onCollide
    switch (source) {
      case (collideType.ASTEROID):
        if (!immune) {
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
        Future.delayed(Duration(seconds: 20), () {
          powerUps[power.AMMO] = false;
        });
        break;
    }
  }
}

// class Player extends StatefulWidget {
//   final double initX;
//   final double initY;
//   final double width;
//   final double height;
//   final int id;
//
//   const Player(
//       {Key? key,
//       required this.initX,
//       required this.initY,
//       required this.width,
//       required this.height,
//       required this.id})
//       : super(key: key);
//
//   @override
//   State<Player> createState() => PlayerState();
// }
//
// class PlayerState extends State<Player> {
//   late Sprite _sprite;
//   final Image image =
//       Image.asset('assets/sprite_images/spaceships/ranger1.png');
//   Map<String, bool> powerUps = {};
//   int lives = 3;
//   double _xOff = 0;
//
//   setOffsetX(double value) {
//     _xOff = value;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: _sprite.y,
//       left: _sprite.x,
//       width: _sprite.width,
//       height: _sprite.height,
//       child: Center(child: Image(image: _sprite.image.image)),
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _sprite = Sprite(widget.initX, widget.initY, widget.width, widget.height,
//         widget.id, image!);
//   }
//
//   void move(BoxConstraints bounds) {
//     setState(() {
//       if (_sprite.x + _xOff >= 0 &&
//           _sprite.x + _xOff <= bounds.maxWidth - _sprite.width)
//         _sprite.x += _xOff;
//       else if (_sprite.x + _xOff < 0)
//         _sprite.x = 0;
//       else if (_sprite.x + _xOff > bounds.maxWidth - _sprite.width)
//         _sprite.x = bounds.maxWidth - _sprite.width;
//     });
//   }
//
//   void onCollide(String type) {
//     // TODO Collision stuff
//   }
//
//   Sprite get_sprite() {
//     return _sprite;
//   }
// }
