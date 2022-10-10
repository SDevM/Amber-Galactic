import 'package:flutter/material.dart';
import 'dart:async';

class OverlayPanel extends StatefulWidget {
  const OverlayPanel({super.key});

  @override
  State<OverlayPanel> createState() => _OverlayPanelState();
}

class _OverlayPanelState extends State<OverlayPanel> {
  int score = 0000;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(999)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Row(
                    children: [
                      Icon(
                        Icons.emoji_events,
                        color: Colors.amberAccent,
                        size: 18,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        '000$score',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              GameTime(),
              TextButton(
                  onPressed: () {},
                  child: Icon(
                    Icons.pause,
                    color: Colors.white,
                    size: 40,
                  )),
            ],
          ),
          LifeBar()
        ],
      ),
    );
  }
}

class GameTime extends StatefulWidget {
  const GameTime({Key? key}) : super(key: key);
  @override
  State<GameTime> createState() => _GameTimeState();
}

class _GameTimeState extends State<GameTime> {
  var timer = Timer.run(() => print('done'));


  var gameTime = "";
  var _timer = null;
  @override
  void initState(){
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        gameTime = "${DateTime.now().minute}:${DateTime.now().second}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.access_time_filled,
          color: Colors.white,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          '$gameTime',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ],
    );
  }
}

class LifeBar extends StatefulWidget {
  const LifeBar({Key? key}) : super(key: key);

  @override
  State<LifeBar> createState() => _LifeBarState();
}

class _LifeBarState extends State<LifeBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.rocket_launch,
          color: Colors.amberAccent,
        ),
        Icon(
          Icons.rocket_launch,
          color: Colors.amberAccent,
        ),
        Icon(
          Icons.rocket_launch,
          color: Colors.grey,
        ),
        Icon(
          Icons.close,
          color: Colors.white,
        ),
        Text(
          '2',
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
