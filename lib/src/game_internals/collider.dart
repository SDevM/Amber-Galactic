import 'dart:collection';

import 'package:game_template/src/game_objects/HitBox.dart';

class Collider extends ListBase<HitBox> {
  final List<HitBox> l = [];

  Collider();

  void set length(int newLength) {
    l.length = newLength;
  }

  int get length => l.length;

  operator [](int index) => l[index];

  void operator []=(int index, HitBox value) {
    l[index] = value;
  }

  bool collisionCheck(HitBox box) {
    bool flag = false;
    for (HitBox listBox in l) {
      if (_collisionCompare(listBox, box)) {
        flag = true;
        break;
      }
    }
    return flag;
  }

  bool _collisionCompare(HitBox box1, HitBox box2) {
    if ((box1.box.top <= box2.box.top + box2.box.height &&
            box1.box.top >= box2.box.top) &&
        (box1.box.left <= box2.box.left + box2.box.width &&
            box1.box.left >= box2.box.left)) {
      return true;
    } else return false;
  }
}
