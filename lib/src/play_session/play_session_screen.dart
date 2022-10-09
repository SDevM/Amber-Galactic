// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:game_template/src/game_objects/Asteroid.dart';
import 'package:game_template/src/game_objects/Player.dart';
import 'package:game_template/src/game_objects/PowerUp.dart';
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
  List<Player> player = [];
  List<GlobalKey<PlayerState>> playerKeys = [];
  List<PowerUp> powerUp = [];
  List<GlobalKey<PowerUpState>> powerUpKeys = [];
  List<Asteroid> asteroids = [];
  List<GlobalKey<AsteroidState>> asteroidKeys = [];
  List<inputType> inputPublisher = [];
  late BoxConstraints screen;
  int idCounter = 0;
  late Ticker _ticker;

  bool firstRun = true;

  // void changes(Timer timer) async {
  void changes(Duration duration) async {
    // if (!mounted) {
    //   return;
    // }
    setState(() {
      if (firstRun) {
        firstRun = false;
        playerKeys.add(GlobalKey<PlayerState>());
        player.add(
          Player(
              key: playerKeys[0],
              initX: screen.maxWidth / 2 - 37.5,
              initY: screen.maxHeight - 137.5,
              width: 58,
              height: 75,
              id: idCounter++),
        );
      }
      inputType input = inputPublisher.removeLast();
      switch (input) {
        case (inputType.TOUCH_LEFT):
          playerKeys[0].currentState?.setOffsetX(-3);
          break;
        case (inputType.TOUCH_RIGHT):
          playerKeys[0].currentState?.setOffsetX(3);
          break;
        case (inputType.DOUBLE_TOUCH):
          game.evaluate(true);
          break;
      }
      // if (timer.tick % 3600 == 0) {
      //   powerUpKeys.add(GlobalKey<PowerUpState>());
      //   powerUp.clear();
      //   powerUp.add(PowerUp(
      //       initX: screen.maxWidth / 2,
      //       initY: screen.maxHeight / 2,
      //       width: 30,
      //       height: 30,
      //       powerUp: 'ammo',
      //       id: idCounter++));
      // }
      // if (timer.tick % ((60 - 0) / 1) == 0) {
      //   asteroidKeys.add(GlobalKey<AsteroidState>());
      //   asteroids.add(Asteroid(
      //       initX: screen.maxWidth / 2,
      //       initY: -50,
      //       width: 50,
      //       height: 50,
      //       size: 1,
      //       id: idCounter++));
      // }
      playerKeys.forEach((element) {
        element.currentState?.move(screen);
      });
      asteroidKeys.forEach((element) {
        element.currentState?.move();
        if ((element.currentState?.get_sprite().y ?? screen.maxHeight) >=
            screen.maxHeight) {
          int idx = asteroidKeys.indexOf(element);
          asteroids.removeAt(idx);
          asteroidKeys.removeAt(idx);
        }
      });
      powerUpKeys.forEach((element) {
        element.currentState?.move();
        if ((element.currentState?.get_sprite().y ?? screen.maxHeight) >=
            screen.maxHeight) {
          int idx = powerUpKeys.indexOf(element);
          powerUp.removeAt(idx);
          powerUpKeys.removeAt(idx);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return IgnorePointer(
      ignoring: _duringCelebration,
      child: LayoutBuilder(builder: (layoutContext, constraints) {
        screen = constraints;
        // ticker = Timer.periodic(const Duration(milliseconds: 30), changes);
        return GestureDetector(
          // Player Controls
          onTapDown: (TapDownDetails details) {
            // TODO Make the player x axis movement negative or positive based on the side of the screen
            if (details.globalPosition.dx >= (screen.maxWidth / 2)) {
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
                ...player,
                ...powerUp,
                ...asteroids,
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
    _ticker.dispose();
    super.dispose();
  }
}

enum inputType {
  TOUCH_RIGHT,
  TOUCH_LEFT,
  DOUBLE_TOUCH,
}
