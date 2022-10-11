import 'dart:collection';

import 'package:game_template/src/game_objects/HitBox.dart';

class Collider<T extends HitBox> {
  final List<T> l = <T>[];

  Collider();

  int collisionCheck(box) {
    int idx = -1;
    for (T listBox in l) {
      if (_collisionCompare(listBox, box)) {
        idx = l.indexOf(listBox);
        break;
      }
    }
    return idx;
  }

  bool _collisionCompare(HitBox box1, HitBox box2) {
    return box1.x < box2.x + box2.width &&
        box1.x + box1.width > box2.x &&
        box1.y < box2.y + box2.height &&
        box1.height + box1.y > box2.y;
  }
}

// class Collider<T extends HitBox> extends ListBase<T> {
//   final List<T> l = <T>[];
//
//   Collider();
//
//   void set length(int newLength) {
//     l.length = newLength;
//   }
//
//   int get length => l.length;
//
//   operator [](int index) => l[index];
//
//   void operator []=(int index, T value) {
//     l[index] = value;
//   }
//
//   int collisionCheck(box) {
//     int idx = -1;
//     for (T listBox in l) {
//       if (_collisionCompare(listBox, box)) {
//         idx = l.indexOf(listBox);
//         break;
//       }
//     }
//     return idx;
//   }
//
//   bool _collisionCompare(HitBox box1, HitBox box2) {
//     bool TL = (box1.y <= box2.y + box2.height && box1.y >= box2.y) &&
//         (box1.x <= box2.x + box2.width && box1.x >= box2.x);
//     bool BL = (box1.y + box2.height <= box2.y + box2.height &&
//             box1.y + box2.height >= box2.y) &&
//         (box1.x <= box2.x + box2.width && box1.x >= box2.x);
//     bool TR = (box1.y <= box2.y + box2.height && box1.y >= box2.y) &&
//         (box1.x + box2.width <= box2.x + box2.width &&
//             box1.x + box2.width >= box2.x);
//     bool BR = (box1.y + box2.height <= box2.y + box2.height &&
//             box1.y + box2.height >= box2.y) &&
//         (box1.x + box2.width <= box2.x + box2.width &&
//             box1.x + box2.width >= box2.x);
//
//     return TL || BL || TR || BR;
//   }
// }
