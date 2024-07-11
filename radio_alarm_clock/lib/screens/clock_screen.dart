import 'package:flutter/material.dart';
import 'dart:async';

import 'package:radio_alarm_clock/constants.dart';
import 'package:radio_alarm_clock/widgets/background.dart';

class ClockScreen extends StatefulWidget {
  const ClockScreen({super.key});

  @override
  State<ClockScreen> createState() => _ClockScreen();
}

class _ClockScreen extends State<ClockScreen> {
  var formattedTime = formatter.format(DateTime.now());
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      var perviousMinute = DateTime.now().add(Duration(seconds: -1)).minute;
      var currentMinute = DateTime.now().minute;
      if (perviousMinute != currentMinute) {
        setState(() {
          formattedTime = formatter.format(DateTime.now());
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Widget timeWidget() {
    final width = MediaQuery.of(context).size.width;
    return Text(
      formattedTime,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: width / 4,
          fontWeight: FontWeight.w700,
          fontFamily: "comfortaa",
          color: Theme.of(context).colorScheme.onPrimaryContainer),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      content: timeWidget(),
    );
  }
}
