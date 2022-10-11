import 'package:flutter/material.dart';
import 'dart:async';

import 'package:game_template/src/games_services/score.dart';

class OverlayPanel extends StatefulWidget {
  final Duration time;
  final int lives;
  final Function onPause;

  const OverlayPanel({super.key, required this.time, required this.lives, required this.onPause});

  @override
  State<OverlayPanel> createState() => _OverlayPanelState();
}

class _OverlayPanelState extends State<OverlayPanel> {
  bool toggle = true;
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
                        '${Score(widget.time).score}',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              GameTime(
                dur: widget.time,
              ),
              TextButton(
                  onPressed: () {
                    widget.onPause(toggle);
                    toggle =! toggle;
                  },
                  child: Icon(
                    Icons.pause,
                    color: Colors.white,
                    size: 40,
                  )),
            ],
          ),
          LifeBar(
            lives: widget.lives,
          ),
        ],
      ),
    );
  }
}

class GameTime extends StatelessWidget {
  final Duration dur;

  const GameTime({Key? key, required this.dur}) : super(key: key);

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
          '$formattedTime',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ],
    );
  }

  String get formattedTime {
    final buf = StringBuffer();
    if (dur.inHours > 0) {
      buf.write('${dur.inHours}');
      buf.write(':');
    }
    final minutes = dur.inMinutes % Duration.minutesPerHour;
    if (minutes > 9) {
      buf.write('$minutes');
    } else {
      buf.write('0');
      buf.write('$minutes');
    }
    buf.write(':');
    buf.write(
        (dur.inSeconds % Duration.secondsPerMinute).toString().padLeft(2, '0'));
    buf.write(':');
    buf.write((dur.inMilliseconds % Duration.millisecondsPerSecond)
        .toString()
        .padLeft(2, '0'));
    return buf.toString();
  }
}

class LifeBar extends StatelessWidget {
  final int lives;

  const LifeBar({Key? key, required this.lives}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List<int>.generate(lives, (i) => i + 1).map((e) => Icon(
              Icons.rocket_launch,
              color: Colors.amberAccent,
            )),
        ...List<int>.generate(3 - lives, (i) => i + 1).map((e) => Icon(
              Icons.rocket_launch,
              color: Colors.amberAccent.withOpacity(0.3),
            )),
        Icon(Icons.close, color: Colors.white, size: 20,),
        Text(
          '$lives',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
