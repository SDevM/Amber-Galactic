import 'package:flutter/cupertino.dart';

import 'Sprite.dart';

class Asteroid extends StatefulWidget {
  final double initX;
  final double initY;
  final double width;
  final double height;
  final int size;
  final double speed;
  const Asteroid({Key? key,required this.initX, required this.initY,required this.width, required this.height, required this.size, required this.speed}) : super(key: key);

  @override
  State<Asteroid> createState() => _AsteroidState();
}

class _AsteroidState extends State<Asteroid> {
  late Sprite _sprite;
  final AssetImage image ={} as AssetImage;
  @override
  Widget build(BuildContext context) {
    _sprite = Sprite(widget.initX, widget.initY, widget.width, widget.height, image!);
    return Positioned(
      top: _sprite.box.top,
      left: _sprite.box.left,
      width: _sprite.box.width,
      height: _sprite.box.height,
      child: Image(image: _sprite.image),
    );
  }
  void move(double xOffset, double yOffset) {
    Rect box = _sprite.box;
    setState(() {
      _sprite.box = Rect.fromLTWH(box.left + xOffset, box.top + yOffset, box.width, box.height);
    });
  }
}
