import 'package:flutter/material.dart';
import 'package:game_template/src/game_objects/Sprite.dart';

class PowerUp extends Sprite implements Collidable {
  final power powerUp;

  PowerUp(double x, double y, double width, double height, double image,
      this.powerUp)
      : super(x, y, width, height, images[powerUp]!);

  void move() {
    this.x++;
  }

  @override
  void onCollide(collideType source) {
    // TODO: implement onCollide
  }
}

const Map<String, Image> images = {};

// class PowerUp extends StatefulWidget {
//   final double initX;
//   final double initY;
//   final double width;
//   final double height;
//   final power powerUp;
//   final int id;
//
//   const PowerUp(
//       {Key? key,
//       required this.initX,
//       required this.initY,
//       required this.width,
//       required this.height,
//       required this.powerUp,
//       required this.id})
//       : super(key: key);
//
//   @override
//   State<PowerUp> createState() => PowerUpState();
// }
//
// class PowerUpState extends State<PowerUp> {
//   late Sprite _sprite;
//   final Map<String, Image> images = {};
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
//         widget.id, images[widget.powerUp]!);
//   }
//
//   void move() {
//     setState(() {
//       _sprite.x++;
//     });
//   }
//
//   void onCollide() {
//     // TODO Collision stuff
//   }
//
//   Sprite get_sprite() {
//     return _sprite;
//   }
// }

enum power {
  AMMO,
}
