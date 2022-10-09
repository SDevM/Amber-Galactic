import 'package:flutter/cupertino.dart';

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
  final AssetImage image = {} as AssetImage;

  @override
  Widget build(BuildContext context) {
    _speed = 10 / widget.size;
    _sprite = Sprite(widget.initX, widget.initY, widget.width, widget.height,
        widget.id, image!);
    return Positioned(
      top: _sprite.box.top,
      left: _sprite.box.left,
      width: _sprite.box.width,
      height: _sprite.box.height,
      child: Image(image: _sprite.image),
    );
  }

  void move() {
    Rect box = _sprite.box;
    setState(() {
      _sprite.box =
          Rect.fromLTWH(box.left, box.top + _speed, box.width, box.height);
    });
  }

  Sprite get_sprite() {
    return _sprite;
  }
}
