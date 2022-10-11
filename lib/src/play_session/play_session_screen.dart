// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:game_template/src/game_internals/collider.dart';
import 'package:game_template/src/game_objects/Ammo1.dart';
import 'package:game_template/src/game_objects/Asteroid.dart';
import 'package:game_template/src/game_objects/GameObjectWidget.dart';
import 'package:game_template/src/game_objects/Player.dart';
import 'package:game_template/src/game_objects/PowerUp.dart';
import 'package:game_template/src/game_objects/Sprite.dart';
import 'package:game_template/src/play_session/overlay.dart';
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
  Collider<PowerUp> powColl = Collider();
  List<Asteroid> asteroids = <Asteroid>[];
  Collider<Asteroid> asterColl = Collider();
  List<Ammo1> munitions = <Ammo1>[];
  List<inputType> inputPublisher = <inputType>[];
  late BoxConstraints screen;
  int idCounter = 0;
  late Ticker _ticker;
  bool paused = false;

  bool firstRun = true;

  int changesCounter = 0;
  int lastCounter = 0;
  int nextAst = rand.nextInt(10) + 50;

  void changes(Duration duration) {
    if (paused) return;
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
      if (changesCounter >= lastCounter + nextAst) {
        nextAst = rand.nextInt(25) + 30;
        lastCounter = changesCounter;
        print('New Asteroid');
        double randX = (rand.nextDouble() * screen.maxWidth);
        double size = (rand.nextDouble() * 2) + 1;
        asteroids.add(
          Asteroid(
            randX > (screen.maxWidth - 50 * size)
                ? screen.maxWidth - 50 * size
                : randX,
            -150,
            50,
            45,
            size,
          ),
        );
        asterColl.l.add(asteroids.last);
      }
      player?.move(screen);
      if (changesCounter % 30 == 0 &&
          player != null &&
          player!.powerUps[power.AMMO]!) {
        print('New Munitions');
        munitions.add(Ammo1(player!.x + player!.width / 2 - 7.5, player!.y - 15,
            51 / 3, 111 / 3));
      }

      List<int> remIdxMun = [];
      munitions.forEach((element) {
        element.move();
        double Y = element.y;
        if (Y <= screen.maxHeight * 1 / 4) {
          int idx = munitions.indexOf(element);
          remIdxMun.add(idx);
        }
      });
      remIdxMun.forEach((element) {
        print(
            'Object:${munitions[element].hashCode} Removed! Because object is out of bounds.');
        munitions.removeAt(element);
      });

      List<int> remIdxAst = [];
      asteroids.forEach((element) {
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
        int asterCollide = asterColl.collisionCheck(player!);
        if (asterCollide != -1) {
          asteroids.removeAt(asterCollide);
          asterColl.l.removeAt(asterCollide);
          player!.onCollide(collideType.ASTEROID);
          if (player!.lives <= 0) game.evaluate(true);
        }
        int powCollide = powColl.collisionCheck(player!);
        if (powCollide != -1) {
          powerUp = null;
          powColl.l.removeAt(powCollide);
          player!.onCollide(collideType.POWER_UP_AMMO);
        }
      }

      if (munitions.isNotEmpty) {
        List<int> remIdxMun = [];
        munitions.forEach((element) {
          int asterCollide = asterColl.collisionCheck(element!);
          if (asterCollide != -1) {
            asteroids.removeAt(asterCollide);
            asterColl.l.removeAt(asterCollide);
            remIdxMun.add(munitions.indexOf(element));
          }
        });
        remIdxMun.forEach((element) {
          print(
              'Object:${munitions[element].hashCode} Removed! Because object has collided.');
          munitions.removeAt(element);
        });
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
                ...(munitions.map((e) => GOW(sprite: e))),
                ...(asteroids.map((e) => GOW(sprite: e))),
                OverlayPanel(
                  lives: player!.lives,
                  time: DateTime.now().difference(_startOfPlay),
                  onPause: (bool status) {
                    paused = status;
                    print(status);
                  },
                ),
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
