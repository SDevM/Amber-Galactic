import 'dart:ui';

class HitBox {
  late Rect box;
  final int id;

  HitBox(double x, double y, double width, double height, this.id) {
    box = Rect.fromLTWH(x, y, width, height);
  }
}
