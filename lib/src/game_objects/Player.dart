import 'dart:ffi';

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
  final Image image = Image.asset('assets/icon.jpeg');
  Map<String, Bool> powerUps = {};
  int lives = 3;

  @override
  Widget build(BuildContext context) {
    _sprite = Sprite(widget.initX, widget.initY, widget.width, widget.height,
        widget.id, image!);
    return Positioned(
      top: _sprite.box.top,
      left: _sprite.box.left,
      width: _sprite.box.width,
      height: _sprite.box.height,
      child: Image(image: _sprite.image.image),
    );
  }

  void move(double xOffset, double yOffset) {
    Rect box = _sprite.box;
    setState(() {
      _sprite.box = Rect.fromLTWH(
          box.left + xOffset, box.top + yOffset, box.width, box.height);
    });
  }

  void onCollide() {
    // TODO Collision stuff
  }

  Sprite get_sprite() {
    return _sprite;
  }
}