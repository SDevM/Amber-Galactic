import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  PublishingLoop().objectPublishingLoop();
}

class PublishingLoop {
  var activeList = [];
  var publishingList = ["Publish one"];

  build(context) {}

  setIntervalTrigger() {}

  objectPublishingLoop() {
    bool firstRun = true;

    Timer.periodic(const Duration(milliseconds: 30), (timer) {
      debugPrint("Publishing List ${this.publishingList.toString()}");
      debugPrint("Active List ${this.activeList.toString()}");

      if (firstRun) {
        this.activeList = List.from(this.publishingList);
      }

      this.publishingList.clear();
      firstRun = false;

      debugPrint("Active List ${this.activeList.toString()}");
      debugPrint("Active List ${this.activeList.toString()}");
    });
  }
}
