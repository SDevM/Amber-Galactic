// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../ads/ads_controller.dart';
import '../ads/banner_ad_widget.dart';
import '../games_services/score.dart';
import '../in_app_purchase/in_app_purchase.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';

class LoseGameScreen extends StatelessWidget {
  final Score score;

  const LoseGameScreen({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final adsControllerAvailable = context.watch<AdsController?>() != null;
    final adsRemoved =
        context.watch<InAppPurchaseController?>()?.adRemoval.active ?? false;
    final palette = context.watch<Palette>();

    const gap = SizedBox(height: 10);

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          "assets/images/universe_background.jpg",
          fit: BoxFit.cover,
        ),
        Container(color: Color.fromARGB(132, 0, 0, 0)),
        Listener(
          onPointerUp: (event) {
            // TODO implement proper action after game lost.
            GoRouter.of(context).go("/");
            // GoRouter.of(context).pop();
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (adsControllerAvailable && !adsRemoved) ...[
                  const Expanded(
                    child: Center(
                      child: BannerAdWidget(),
                    ),
                  ),
                ],
                gap,
                const Center(
                  child: Text(
                    'Ship Destroyed!',
                    style: TextStyle(
                      fontFamily: 'FastHand',
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                gap,
                Center(
                  child: Text(
                    'Score: ${score.score}\n'
                    'Time: ${score.formattedTime}',
                    style: const TextStyle(
                      fontFamily: 'Permanent Marker',
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                gap,
                gap,
                Center(
                  child: TapToContinue(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TapToContinue extends StatefulWidget {
  const TapToContinue({super.key});

  @override
  State<TapToContinue> createState() => _TapToContinueState();
}

class _TapToContinueState extends State<TapToContinue>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = Tween(begin: 1, end: 0.8).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.ease,
      ),
    );

    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, snapshot) {
        return Transform.scale(
          scale: _animation.value,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            child: Text(
              'Tap to continue',
              style: const TextStyle(
                fontFamily: 'Permanent Marker',
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        );
      },
    );
  }
}
