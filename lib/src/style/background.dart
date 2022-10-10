import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Image img;

  Background({Key? key, required this.img}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: img.image,
          fit: BoxFit.cover,
          alignment: Alignment.centerRight,
        ),
      ),
    );
  }
}
