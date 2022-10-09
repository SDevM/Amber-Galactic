import 'package:flutter/material.dart';

import 'Sprite.dart';

class Asteroid extends StatefulWidget {
  final double initX;
  final double initY;
  final double width;
  final double height;
  final int size;
  final int id;

  const Asteroid(
      {Key? key,
      required this.initX,
      required this.initY,
      required this.width,
      required this.height,
      required this.size,
      required this.id})
      : super(key: key);

  @override
  State<Asteroid> createState() => AsteroidState();
}

class AsteroidState extends State<Asteroid> {
  late double _speed;
  late Sprite _sprite;
  final Image image = Image.asset('assets/icon.jpeg');

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _sprite.y,
      left: _sprite.x,
      width: _sprite.width,
      height: _sprite.height,
      child: Center(child: Image(image: _sprite.image.image)),
    );
  }

  @override
  void initState() {
    super.initState();
    _speed = 1 / widget.size;
    _sprite = Sprite(widget.initX, widget.initY, widget.width, widget.height,
        widget.id, image!);
  }

  void move() {
    setState(() {
      _sprite.x++;
    });
  }

  Sprite get_sprite() {
    return _sprite;
  }
}
