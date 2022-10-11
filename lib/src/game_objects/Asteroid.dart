import 'package:flutter/material.dart';

import 'Sprite.dart';

class Asteroid extends Sprite implements Collidable {
  final double size;
  final double speed = 2;

  Asteroid(double x, double y, double width, double height, this.size)
      : super(
          x,
          y,
          width * size,
          height * size,
          Image.asset(
              'assets/sprite_images/asteroids/space_rocks/asteroid1.png'),
        );

  void move() {
    this.y += speed * size;
  }

  @override
  void onCollide(collideType source) {
    // TODO: implement onCollide
  }
}

// class Asteroid extends StatefulWidget {
//   final double initX;
//   final double initY;
//   final double width;
//   final double height;
//   final int size;
//   final int id;
//
//   const Asteroid(
//       {Key? key,
//       required this.initX,
//       required this.initY,
//       required this.width,
//       required this.height,
//       required this.size,
//       required this.id})
//       : super(key: key);
//
//   @override
//   State<Asteroid> createState() => AsteroidState();
// }
//
// class AsteroidState extends State<Asteroid> {
//   final double _speed = 2;
//   late Sprite _sprite;
//   final Image image = Image.asset('assets/sprite_images/asteroids/space_rocks/asteroid1.png');
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
//   void move() {
//     print('Moved from y = ${_sprite.y}');
//     setState(() {
//       _sprite.y+= _speed / widget.size;
//     });
//   }
//
//   Sprite get_sprite() {
//     return _sprite;
//   }
// }
