import 'package:flutter/material.dart';

import 'Sprite.dart';

class Player extends StatefulWidget {
  final double initX;
  final double initY;
  final double width;
  final double height;
  final int id;

  const Player(
      {Key? key,
      required this.initX,
      required this.initY,
      required this.width,
      required this.height,
      required this.id})
      : super(key: key);

  @override
  State<Player> createState() => PlayerState();
}

class PlayerState extends State<Player> {
  late Sprite _sprite;
  final Image image =
      Image.asset('assets/sprite_images/spaceships/ranger1.png');
  Map<String, bool> powerUps = {};
  int lives = 3;
  int xOff = 0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _sprite.y,
      left: _sprite.x,
      width: _sprite.width,
      height: _sprite.height,
      child: Image(image: _sprite.image.image),
    );
  }

  @override
  void initState() {
    super.initState();
    _sprite = Sprite(widget.initX, widget.initY, widget.width, widget.height,
        widget.id, image!);
  }

  void move(BoxConstraints bounds) {
    setState(() {
      if (_sprite.x + xOff >= 0 &&
          _sprite.x + xOff <= bounds.maxWidth - _sprite.width)
        _sprite.x += xOff;
    });
  }

  void onCollide() {
    // TODO Collision stuff
  }

  Sprite get_sprite() {
    return _sprite;
  }
}
