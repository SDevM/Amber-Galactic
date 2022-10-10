// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../audio/sounds.dart';
import '../games_services/games_services.dart';
import '../settings/settings.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final gamesServicesController = context.watch<GamesServicesController?>();
    final settingsController = context.watch<SettingsController>();
    final audioController = context.watch<AudioController>();

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/images/universe_background.jpg",
          fit: BoxFit.fitHeight,
        ),
        Container(
          color: Color.fromARGB(30, 6, 6, 52),
        ),
        Scaffold(
          backgroundColor: palette.backgroundMain,
          body: ResponsiveScreen(
            mainAreaProminence: 0.45,
            squarishMainArea: Center(
              child: const Text(
                'Amber\nGalactic',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'FastHand',
                  fontSize: 60,
                  height: 1,
                  color: Colors.white,
                  letterSpacing: 10,
                ),
              ),
            ),
            rectangularMenuArea: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF630563),
                    elevation: 10,
                    padding: EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    audioController.playSfx(SfxType.buttonTap);
                    GoRouter.of(context).go('/play');
                  },
                  child: const Text('Play'),
                ),
                _gap,
                if (gamesServicesController != null) ...[
                  _hideUntilReady(
                    ready: gamesServicesController.signedIn,
                    child: ElevatedButton(
                      onPressed: () =>
                          gamesServicesController.showAchievements(),
                      child: const Text('Achievements'),
                    ),
                  ),
                  _gap,
                  _hideUntilReady(
                    ready: gamesServicesController.signedIn,
                    child: ElevatedButton(
                      onPressed: () =>
                          gamesServicesController.showLeaderboard(),
                      child: const Text('Leaderboard'),
                    ),
                  ),
                  _gap,
                ],
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF630563),
                    elevation: 4.0,
                    padding: EdgeInsets.symmetric(
                      horizontal: 35,
                      vertical: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => GoRouter.of(context).go('/settings'),
                  child: const Text('Settings'),
                ),
                _gap,
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: ValueListenableBuilder<bool>(
                    valueListenable: settingsController.muted,
                    builder: (context, muted, child) {
                      return IconButton(
                        onPressed: () => settingsController.toggleMuted(),
                        icon: Icon(
                          muted ? Icons.volume_off : Icons.volume_up,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
                _gap,
              ],
            ),
          ),
        )
      ],
    );
  }

  /// Prevents the game from showing game-services-related menu items
  /// until we're sure the player is signed in.
  ///
  /// This normally happens immediately after game start, so players will not
  /// see any flash. The exception is folks who decline to use Game Center
  /// or Google Play Game Services, or who haven't yet set it up.
  Widget _hideUntilReady({required Widget child, required Future<bool> ready}) {
    return FutureBuilder<bool>(
      future: ready,
      builder: (context, snapshot) {
        // Use Visibility here so that we have the space for the buttons
        // ready.
        return Visibility(
          visible: snapshot.data ?? false,
          maintainState: true,
          maintainSize: true,
          maintainAnimation: true,
          child: child,
        );
      },
    );
  }

  static const _gap = SizedBox(height: 10);
}

class GameLogo extends StatefulWidget {
  const GameLogo({Key? key}) : super(key: key);

  @override
  State<GameLogo> createState() => _GameLogoState();
}

class _GameLogoState extends State<GameLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;
  late Animation _animation2;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _animation = Tween(begin: 1, end: 0.8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.ease,
      ),
    );

    _animation2 = Tween(begin: 0.1, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.ease,
      ),
    );

    _animationController.repeat(reverse: true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, snapshot) {
          return Transform.rotate(
            angle: _animation2.value,
            child: Transform.scale(
              scale: _animation.value,
              child: Text(
                'Amber\nGalactic',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'FastHand',
                  fontSize: 60,
                  height: 1,
                  color: Colors.white,
                ),
              ),
            ),
          );
        });
  }
}
