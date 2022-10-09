// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../in_app_purchase/in_app_purchase.dart';
import '../player_progress/player_progress.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';
import 'custom_name_dialog.dart';
import 'settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _gap = SizedBox(height: 60);
  static const _smallGap = SizedBox(height: 30);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();
    final palette = context.watch<Palette>();

    return Scaffold(
      body: Stack(children: [
        Image.asset(
          'assets/images/universe_background.jpg',
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
          color: Color(0xFF060634).withOpacity(.4),
          colorBlendMode: BlendMode.softLight,
        ),
        ResponsiveScreen(
            squarishMainArea: ListView(
              children: [
                _gap,
                const Text(
                  'Settings',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'FastHand',
                    color: Colors.white60,
                    fontSize: 55,
                    height: 1,
                    letterSpacing: 10,
                  ),
                ),
                _gap,
                const _NameChangeLine(
                  'Name',
                ),
                _smallGap,
                ValueListenableBuilder<bool>(
                  valueListenable: settings.soundsOn,
                  builder: (context, soundsOn, child) => _SettingsLine(
                    'Sound FX',
                    Icon(
                      soundsOn ? Icons.graphic_eq : Icons.volume_off,
                      color: Colors.white70,
                    ),
                    onSelected: () => settings.toggleSoundsOn(),
                  ),
                ),
                _smallGap,
                ValueListenableBuilder<bool>(
                  valueListenable: settings.musicOn,
                  builder: (context, musicOn, child) => _SettingsLine(
                    'Music',
                    Icon(
                      musicOn ? Icons.music_note : Icons.music_off,
                      color: Colors.white70,
                    ),
                    onSelected: () => settings.toggleMusicOn(),
                  ),
                ),
                _smallGap,
                _smallGap,
                ValueListenableBuilder<int>(
                  valueListenable: settings.highScore,
                  builder: (context, highScore, child) => _SettingsLine(
                    'Top Score',
                    Text(
                      '${highScore}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    onSelected: () => settings.toggleMusicOn(),
                  ),
                ),
                _smallGap,
                _SettingsLine(
                  'Reset progress',
                  const Icon(
                    Icons.loop,
                    color: Colors.white70,
                  ),
                  onSelected: () {
                    context.read<PlayerProgress>().reset();

                    final messenger = ScaffoldMessenger.of(context);
                    messenger.showSnackBar(
                      const SnackBar(
                          content: Text('Player progress has been reset.')),
                    );
                  },
                ),
                _gap,
              ],
            ),
            rectangularMenuArea: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0XFF630563))),
                onPressed: () {
                  GoRouter.of(context).pop();
                },
                child: const Text(
                  'Back',
                )
                //  630563

                )),
      ]),
    );
  }
}

class _NameChangeLine extends StatelessWidget {
  final String title;

  const _NameChangeLine(this.title);

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsController>();

    return InkResponse(
      highlightShape: BoxShape.rectangle,
      onTap: () => showCustomNameDialog(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: const TextStyle(
                    fontFamily: 'Permanent Marker',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70)),
            const Spacer(),
            ValueListenableBuilder(
              valueListenable: settings.playerName,
              builder: (context, name, child) => Text(
                '‘$name’',
                style: const TextStyle(
                    fontFamily: 'Permanent Marker',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsLine extends StatelessWidget {
  final String title;

  final Widget icon;

  final VoidCallback? onSelected;

  const _SettingsLine(this.title, this.icon, {this.onSelected});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      highlightShape: BoxShape.rectangle,
      onTap: onSelected,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: const TextStyle(
                    fontFamily: 'Permanent Marker',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70)),
            const Spacer(),
            icon,
          ],
        ),
      ),
    );
  }
}
