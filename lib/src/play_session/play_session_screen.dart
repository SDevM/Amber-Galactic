// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:game_template/src/game_internals/collider.dart';
import 'package:game_template/src/game_objects/Asteroid.dart';
import 'package:game_template/src/game_objects/GameObjectWidget.dart';
import 'package:game_template/src/game_objects/Player.dart';
import 'package:game_template/src/game_objects/PowerUp.dart';
import 'package:game_template/src/game_objects/Sprite.dart';
import 'package:game_template/src/style/background.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart' hide Level;
import 'package:provider/provider.dart';

import '../ads/ads_controller.dart';
import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../game_internals/level_state.dart';
import '../games_services/games_services.dart';
import '../games_services/score.dart';
import '../in_app_purchase/in_app_purchase.dart';
import '../level_selection/levels.dart';
import '../player_progress/player_progress.dart';
import '../style/confetti.dart';
import '../style/palette.dart';

class PlaySessionScreen extends StatefulWidget {
  const PlaySessionScreen({super.key});

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen>
    with SingleTickerProviderStateMixin<PlaySessionScreen> {
  static final _log = Logger('PlaySessionScreen');

  static const _celebrationDuration = Duration(milliseconds: 2000);

  static const _preCelebrationDuration = Duration(milliseconds: 500);

  bool _duringCelebration = false;

  late DateTime _startOfPlay;

  late LevelState game = LevelState(onLose: _playerLost);
  Player? player;
  PowerUp? powerUp;
  List<Asteroid> asteroids = <Asteroid>[];
  Collider<Asteroid> asterColl = Collider();
  List<inputType> inputPublisher = <inputType>[];
  late BoxConstraints screen;
  int idCounter = 0;
  late Ticker _ticker;

  bool firstRun = true;

  int changesCounter = 0;
  int nextAst = rand.nextInt(10) + 50;

  void changes(Duration duration) {
    changesCounter++;
    setState(() {
      if (firstRun) {
        firstRun = false;
        player = Player(
          screen.maxWidth / 2 - 37.5,
          screen.maxHeight - 137.5,
          58,
          75,
        );
      }
      if (inputPublisher.isNotEmpty) {
        inputType input = inputPublisher.removeLast();
        switch (input) {
          case (inputType.TOUCH_LEFT):
            player?.xOff = -4;
            break;
          case (inputType.TOUCH_RIGHT):
            player?.xOff = 4;
            break;
          case (inputType.DOUBLE_TOUCH):
            break;
        }
      }
      // if (timer.tick % 3600 == 0) {
      //   powerUpKeys.add(GlobalKey<PowerUpState>());
      //   powerUp.clear();
      //   powerUp.add(PowerUp(
      //       initX: screen.maxWidth / 2,
      //       initY: screen.maxHeight / 2,
      //       width: 30,
      //       height: 30,
      //       powerUp: power.AMMO,
      //       id: idCounter++));
      // }
      if (changesCounter % nextAst == 0.0) {
        nextAst = rand.nextInt(10) + 50;
        changesCounter = 0;
        print('New Asteroid');
        double randX = (rand.nextDouble() * screen.maxWidth);
        asteroids.add(
          Asteroid(
            randX > (screen.maxWidth - 50) ? screen.maxWidth - 50 : randX,
            -150,
            50,
            50,
            1,
          ),
        );
        asterColl.l.add(asteroids.last);
      }
      player?.move(screen);

      List<int> remIdxAst = [];
      asteroids.forEach((element) async {
        element.move();
        double Y = element.y;
        if (Y >= screen.maxHeight) {
          int idx = asteroids.indexOf(element);
          remIdxAst.add(idx);
        }
      });
      remIdxAst.forEach((element) {
        print(
            'Object:${asteroids[element].hashCode} Removed! Because object is out of bounds.');
        asteroids.removeAt(element);
        asterColl.l.removeAt(element);
      });

      if (powerUp != null && powerUp!.y >= screen.maxHeight) {
        powerUp = null;
      }

      if (player != null) {
        bool asterCollide = asterColl.collisionCheck(player!) != -1;
        if (asterCollide) {
          print('Collision!');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return IgnorePointer(
      ignoring: _duringCelebration,
      child: LayoutBuilder(builder: (layoutContext, constraints) {
        screen = constraints;
        return GestureDetector(
          // Player Controls
          onHorizontalDragEnd: (DragEndDetails details) {
            // TODO Make the player x axis movement negative or positive based on the side of the screen
            if (details.velocity.pixelsPerSecond.dx >= (screen.maxWidth / 2)) {
              inputPublisher.add(inputType.TOUCH_RIGHT);
            } else {
              inputPublisher.add(inputType.TOUCH_LEFT);
            }
          },
          onDoubleTap: () {
            // TODO Teleport!
            inputPublisher.add(inputType.DOUBLE_TOUCH);
          },
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Background(
                  img: Image.asset('assets/images/universe_background.jpg'),
                ),
                player != null ? GOW(sprite: player!) : Container(),
                powerUp != null ? GOW(sprite: powerUp!) : Container(),
                ...(asteroids.map((e) => GOW(sprite: e))),
                // SizedBox.expand(
                //   child: Visibility(
                //     visible: _duringCelebration,
                //     child: IgnorePointer(
                //       child: Confetti(
                //         isStopped: !_duringCelebration,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  void initState() {
    super.initState();

    _startOfPlay = DateTime.now();
    _ticker = this.createTicker(changes);
    _ticker.start();

    // Preload ad for the win screen.
    final adsRemoved =
        context.read<InAppPurchaseController?>()?.adRemoval.active ?? false;
    if (!adsRemoved) {
      final adsController = context.read<AdsController?>();
      adsController?.preloadAd();
    }
  }

  _playerLost() {
    // _log.info('Level ${widget.level.number} won');

    final score = Score(
      DateTime.now().difference(_startOfPlay),
    );

    GoRouter.of(context).go('/play/lost', extra: {'score': score});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print('DISPOSE!');
    _ticker.dispose();
    super.dispose();
  }
}

final rand = Random();

enum inputType {
  TOUCH_RIGHT,
  TOUCH_LEFT,
  DOUBLE_TOUCH,
}
