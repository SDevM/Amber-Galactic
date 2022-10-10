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
  double _xOff = 0;

  setOffsetX(double value) {
    _xOff = value;
  }

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
    _sprite = Sprite(widget.initX, widget.initY, widget.width, widget.height,
        widget.id, image!);
  }

  void move(BoxConstraints bounds) {
    setState(() {
      if (_sprite.x + _xOff >= 0 &&
          _sprite.x + _xOff <= bounds.maxWidth - _sprite.width)
        _sprite.x += _xOff;
      else if (_sprite.x + _xOff < 0)
        _sprite.x = 0;
      else if (_sprite.x + _xOff > bounds.maxWidth - _sprite.width)
        _sprite.x = bounds.maxWidth - _sprite.width;
    });
  }

  void onCollide(String type) {
    // TODO Collision stuff
  }

  Sprite get_sprite() {
    return _sprite;
  }
}

enum collideType {
  ASTEROID,
  POWER_UP_AMMO,
}