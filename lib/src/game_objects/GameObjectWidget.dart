import 'package:flutter/material.dart';

import 'Sprite.dart';

class GOW extends StatelessWidget {
  final Sprite sprite;

  const GOW({Key? key, required this.sprite}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: sprite.y,
      left: sprite.x,
      width: sprite.width,
      height: sprite.height,
      child: Center(
          child: Image(
        image: sprite.image.image,
        width: double.infinity,
        height: double.infinity,
      )),
    );
  }
}
