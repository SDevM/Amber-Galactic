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
      if (box.id != listBox.id) {
        if (_collisionCompare(listBox, box)) {
          flag = true;
          break;
        }
      }
    }
    return flag;
  }

  bool _collisionCompare(HitBox box1, HitBox box2) {
    bool TL = (box1.y <= box2.y + box2.height && box1.y >= box2.y) &&
        (box1.x <= box2.x + box2.width && box1.x >= box2.x);
    bool BL = (box1.y + box2.height <= box2.y + box2.height &&
            box1.y + box2.height >= box2.y) &&
        (box1.x <= box2.x + box2.width && box1.x >= box2.x);
    bool TR = (box1.y <= box2.y + box2.height && box1.y >= box2.y) &&
        (box1.x + box2.width <= box2.x + box2.width &&
            box1.x + box2.width >= box2.x);
    bool BR = (box1.y + box2.height <= box2.y + box2.height &&
            box1.y + box2.height >= box2.y) &&
        (box1.x + box2.width <= box2.x + box2.width &&
            box1.x + box2.width >= box2.x);

    if (TL || BL || TR || BR) {
      return true;
    } else
      return false;
  }
}
