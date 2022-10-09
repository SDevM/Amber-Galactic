// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
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

class _PlaySessionScreenState extends State<PlaySessionScreen> {
  static final _log = Logger('PlaySessionScreen');

  static const _celebrationDuration = Duration(milliseconds: 2000);

  static const _preCelebrationDuration = Duration(milliseconds: 500);

  bool _duringCelebration = false;

  late DateTime _startOfPlay;

  List<Player> player = [];
  List<GlobalKey<PlayerState>> playerKeys = [];
  List<PowerUp> powerUp = [];
  List<GlobalKey<PowerUpState>> powerUpKeys = [];
  List<Asteroid> asteroids = [];
  List<GlobalKey<AsteroidState>> asteroidKeys = [];
  late BoxConstraints screen;
  int idCounter = 0;
  late Timer ticker;

  bool firstRun = true;

  void changes(Timer timer) {
    if (!mounted) {
      ticker.cancel();
      return;
    }
    setState(() {
      if (firstRun) {
        firstRun = false;
        player.add(
          Player(
              key: playerKeys[0],
              initX: screen.maxWidth / 2,
              initY: screen.maxHeight - 100,
              width: 50,
              height: 50,
              id: idCounter++),
        );
      }
      if (timer.tick % 3600 == 0) {
        powerUp.clear();
        powerUp.add(PowerUp(
            initX: screen.maxWidth / 2,
            initY: screen.maxHeight / 2,
            width: 30,
            height: 30,
            powerUp: 'ammo',
            id: idCounter++));
      }
      if (timer.tick % ((60 - 0) / 1) == 0) {
        asteroids.add(Asteroid(
            initX: screen.maxWidth / 2,
            initY: -50,
            width: 50,
            height: 50,
            size: 1,
            id: idCounter++));
      }
      asteroidKeys.forEach((element) {
        element.currentState?.move();
        if ((element.currentState?.get_sprite().box.top ?? screen.maxHeight) >=
            screen.maxHeight) {
          int idx = asteroidKeys.indexOf(element);
          asteroids.removeAt(idx);
          asteroidKeys.removeAt(idx);
        }
      });
      powerUpKeys.forEach((element) {
        element.currentState?.move();
        if ((element.currentState?.get_sprite().box.top ?? screen.maxHeight) >=
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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LevelState(
            onLose: _playerLost,
          ),
        ),
      ],
      child: IgnorePointer(
        ignoring: _duringCelebration,
        child: LayoutBuilder(builder: (layoutContext, constraints) {
          screen = constraints;
          ticker = Timer.periodic(const Duration(milliseconds: 30), changes);
          return Scaffold(
            backgroundColor: palette.backgroundPlaySession,
            body: Stack(
              children: [
                Background(),
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
          );
        }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _startOfPlay = DateTime.now();

    // Preload ad for the win screen.
    final adsRemoved =
        context.read<InAppPurchaseController?>()?.adRemoval.active ?? false;
    if (!adsRemoved) {
      final adsController = context.read<AdsController?>();
      adsController?.preloadAd();
    }
  }

  Future<void> _playerLost() async {
    // _log.info('Level ${widget.level.number} won');

    final score = Score(
      DateTime.now().difference(_startOfPlay),
    );

    // final playerProgress = context.read<PlayerProgress>();
    // playerProgress.setLevelReached(widget.level.number);

    // Let the player see the game just after winning for a bit.
    await Future<void>.delayed(_preCelebrationDuration);
    if (!mounted) return;

    setState(() {
      _duringCelebration = true;
    });

    final audioController = context.read<AudioController>();
    audioController.playSfx(SfxType.congrats);

    // final gamesServicesController = context.read<GamesServicesController?>();
    // if (gamesServicesController != null) {
    //   // Award achievement.
    //   if (widget.level.awardsAchievement) {
    //     await gamesServicesController.awardAchievement(
    //       android: widget.level.achievementIdAndroid!,
    //       iOS: widget.level.achievementIdIOS!,
    //     );
    //   }
    //
    //   // Send score to leaderboard.
    //   await gamesServicesController.submitLeaderboardScore(score);
    // }

    /// Give the player some time to see the celebration animation.
    await Future<void>.delayed(_celebrationDuration);
    if (!mounted) return;

    GoRouter.of(context).go('/play/won', extra: {'score': score});
  }
}
