// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

class LevelState extends ChangeNotifier {
  final VoidCallback onLose;


  LevelState({required this.onLose});

  int _progress = 0;

  int get progress => _progress;

  void setProgress(int value) {
    _progress = value;
    notifyListeners();
  }

  void evaluate(bool lost) {
    if (lost) {
      return onLose();
    }
  }
}
