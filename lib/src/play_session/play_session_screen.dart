// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:game_template/src/game_internals/collider.dart';
import 'package:game_template/src/game_objects/Ammo1.dart';
import 'package:game_template/src/game_objects/Asteroid.dart';
import 'package:game_template/src/game_objects/GameObjectWidget.dart';
import 'package:game_template/src/game_objects/Player.dart';
import 'package:game_template/src/game_objects/PowerUp.dart';
import 'package:game_template/src/game_objects/Shield.dart';
import 'package:game_template/src/game_objects/Sprite.dart';
import 'package:game_template/src/play_session/overlay.dart';
import 'package:game_template/src/style/background.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../ads/ads_controller.dart';
import '../game_internals/level_state.dart';
import '../games_services/score.dart';
import '../in_app_purchase/in_app_purchase.dart';

class PlaySessionScreen extends StatefulWidget {
  const PlaySessionScreen({super.key});

  @override
  State<PlaySessionScreen> createState() => _PlaySessionScreenState();
}

class _PlaySessionScreenState extends State<PlaySessionScreen>
    with SingleTickerProviderStateMixin<PlaySessionScreen> {
  bool _duringCelebration = false;

  Stopwatch _gameTime = Stopwatch();

  late LevelState game = LevelState(onLose: _playerLost);
  Player? player;
  PowerUp? powerUp;
  Shield? shield;
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

  int changesCounter = 500;
  int lastCounter = 0;
  int nextAst = rand.nextInt(10) + 50;
  bool tickToggle1 = true;
  bool powerProcess = false;

  void changes(Duration duration) {
    if (paused) {
      if (_gameTime.isRunning) _gameTime.stop();
      return;
    }
    if (!_gameTime.isRunning) _gameTime.start();
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
            player?.xOff = -3;
            break;
          case (inputType.TOUCH_RIGHT):
            player?.xOff = 3;
            break;
          case (inputType.DOUBLE_TOUCH):
            break;
        }
      }
      if (!powerProcess) {
        powerProcess = true;
        Future.delayed(Duration(seconds: 20), () {
          print('New PowerUp');
          double randX = (rand.nextDouble() * screen.maxWidth);
          powerUp = PowerUp(
            randX > (screen.maxWidth - 42) ? screen.maxWidth - 45 : randX,
            screen.maxHeight / 3,
            42,
            45,
            power.values[rand.nextInt(power.values.length)],
          );
          powColl.l.add(powerUp!);
          powerProcess = false;
        });
      }
      if (changesCounter >= lastCounter + nextAst) {
        nextAst = rand.nextInt(20) + 80;
        lastCounter = changesCounter;
        print('New Asteroid');
        double randX = (rand.nextDouble() * screen.maxWidth);
        double size = (rand.nextDouble() * 2) + 1;
        asteroids.add(
          Asteroid(
            randX > (screen.maxWidth - (108 / 2) * size)
                ? screen.maxWidth - (108 / 2) * size
                : randX,
            -150,
            108 / 2,
            99 / 2,
            size,
          ),
        );
        asterColl.l.add(asteroids.last);
      }
      if (player != null && shield == null && player!.powerUps[power.SHIELD]!) {
        print('New Shield');
        shield = Shield(
          player!.x - 10,
          player!.y - 10,
          player!.width + 20,
          player!.height + 20,
        );
      }
      if ( player != null && !player!.powerUps[power.SHIELD]!) {
        shield = null;
        player!.powerClear(power.SHIELD);
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

      if (changesCounter % 40 == 0) {
        tickToggle1 = !tickToggle1;
      }
      powerUp?.move(tickToggle1);

      if (powerUp != null && powerUp!.y >= screen.maxHeight) {
        powerUp = null;
      }

      if (shield != null) {
        int asterCollide = asterColl.collisionCheck(shield!);
        if (asterCollide != -1) {
          asteroids.removeAt(asterCollide);
          asterColl.l.removeAt(asterCollide);
          shield!.onCollide(collideType.ASTEROID);
          if (shield!.lives <= 0) {
            shield = null;
            player!.powerClear(power.SHIELD);
          }
        }
      }

      if (player != null) {
        if (shield != null) {
          shield!.x = player!.x - 10;
          shield!.y = player!.y - 10;
          shield!.width = player!.width + 20;
          shield!.height = player!.height + 20;
        }
        int asterCollide = asterColl.collisionDeep(player!);
        if (asterCollide != -1) {
          asteroids.removeAt(asterCollide);
          asterColl.l.removeAt(asterCollide);
          player!.onCollide(collideType.ASTEROID);
          if (player!.lives <= 0) {
            paused = true;
            game.evaluate(true);
          }
        }
        int powCollide = powColl.collisionCheck(player!);
        if (powCollide != -1) {
          switch (powerUp!.powerUp) {
            case (power.AMMO):
              player!.onCollide(collideType.POWER_UP_AMMO);
              break;
            case (power.SHIELD):
              player!.onCollide(collideType.POWER_UP_SHIELD);
              break;
          }
          powColl.l.removeAt(powCollide);
          powerUp = null;
        }
      }

      if (munitions.isNotEmpty) {
        List<int> remIdxMun = [];
        munitions.forEach((element) {
          int asterCollide = asterColl.collisionDeep(element);
          if (asterCollide != -1) {
            asteroids.removeAt(asterCollide);
            asterColl.l.removeAt(asterCollide);
            int idx = munitions.indexOf(element);
            remIdxMun.add(idx);
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
    return IgnorePointer(
      ignoring: _duringCelebration,
      child: LayoutBuilder(builder: (layoutContext, constraints) {
        screen = constraints;
        return GestureDetector(
          // Player Controls
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.velocity.pixelsPerSecond.dx >= (screen.maxWidth / 2)) {
              inputPublisher.add(inputType.TOUCH_RIGHT);
            } else {
              inputPublisher.add(inputType.TOUCH_LEFT);
            }
          },
          onDoubleTap: () {
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
                shield != null ? GOW(sprite: shield!) : Container(),
                player != null
                    ? OverlayPanel(
                        lives: player!.lives,
                        time: _gameTime.elapsed,
                        onPause: (bool status) {
                          paused = status;
                          print(status);
                        },
                      )
                    : Container(),
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

    _gameTime.start();
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
    _gameTime.stop();
    final score = Score(
      _gameTime.elapsed,
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
