import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:process_run/shell.dart';
import 'dart:async';

import 'package:radio_alarm_clock/widgets/digital_lcd.dart';

final formatter = DateFormat('kk:mm');

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
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

  // Methods
  Future _runCommand() async {
    var shell = Shell();
    await shell.run('./assets/scripts/script.sh');
  }

  // Widgets
  Widget clockWidget() {
    return Center(
      child: DigitalLcd(
        hours: DateTime.now().hour,
        minutes: DateTime.now().minute,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.access_alarm),
                  text: "Alarm",
                ),
                Tab(
                  icon: Icon(Icons.access_time),
                  text: "Clock",
                ),
                Tab(
                  icon: Icon(Icons.timer),
                  text: "Timer",
                ),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          body: TabBarView(
            children: [
              TextButton(
                onPressed: _runCommand,
                child: const Text("PLAY MUSIC"),
              ),
              // Center(
              //     child: Text(
              //   formattedTime,
              //   textAlign: TextAlign.center,
              //   style:
              //       new TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
              // )),
              clockWidget(),
              const Icon(Icons.timer),
            ],
          ),
        ),
      ),
    );
  }
}
