import 'dart:ui';

class HitBox {
  late Rect box;
  HitBox(double x, double y, double width, double height) {
    box = Rect.fromLTWH(x, y, width, height);
  }
}