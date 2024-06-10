import 'dart:async';

import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreen();
}

class _AlarmScreen extends State<AlarmScreen> {
  TimeOfDay? _alarmTime;
  late Timer timer;
  bool rings = false;
  bool alreadyRang = false;

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      var currentTime = TimeOfDay.now();
      if (_alarmTime == currentTime) {
        setState(() {
          rings = true;
        });
      } else {
        setState(() {
          rings = false;
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

  void _presentTimePicker() async {
    // 'await' is telling flutter to wait for the Future value before storing it in the variable
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    setState(() {
      _alarmTime = pickedTime;
      alreadyRang = false;
    });
  }

  Future<void> onAlarmTrig(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Opening Spotify'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (rings && !alreadyRang) {
      Future.delayed(Duration.zero, () => onAlarmTrig(context));
      Timer.run(_runCommand);
      alreadyRang = true;
    }
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.tertiaryContainer,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _alarmTime != null
              ? Text('Alarm set to: ${_alarmTime!.format(context)}')
              : const Text('No alarm'),
          const Divider(),
          TextButton(
            onPressed: _presentTimePicker,
            child: const Text('CONFIGURE ALARM'),
          ),
          TextButton(
            onPressed: () => onAlarmTrig(context),
            child: const Text('SHOW DIALOG'),
          ),
          TextButton(
            onPressed: _runCommand,
            child: const Text("PLAY MUSIC"),
          ),
        ],
      ),
    );
  }
}
