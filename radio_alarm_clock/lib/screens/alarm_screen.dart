import 'dart:async';

import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';
import 'package:radio_alarm_clock/models/alarm.dart';
import 'package:radio_alarm_clock/screens/new_alarm.dart';
import 'package:radio_alarm_clock/utils/alarm_preferences.dart';
import 'package:radio_alarm_clock/widgets/alarm_list.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreen();
}

class _AlarmScreen extends State<AlarmScreen> {
  late Timer timer;
  bool rings = false;
  bool alreadyRang = false;
  List<Alarm> _registeredAlarms = [];

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      var currentTime = TimeOfDay.now();
      // if (_alarmTime == currentTime) {
      //   setState(() {
      //     rings = true;
      //   });
      // } else {
      //   setState(() {
      //     rings = false;
      //   });
      // }
    });

    _registeredAlarms = AlarmPreferences.getAlarms();
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

  Future<void> onAlarmTrig(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Opening Spotify'),
          content: Image.asset('assets/images/capy.png'),
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

  Future _openAddAlarmOverlay(
      {bool isNewAlarm = true, Alarm? editedAlarm}) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: CircleBorder(eccentricity: 0.8),
        builder: (ctx) => isNewAlarm
            ? NewAlarm(
                onAddAlarm: (alarm) => {
                  _addAlarm(alarm),
                },
              )
            : NewAlarm(
                onAddAlarm: (alarm) => {
                  _replaceAlarm(alarm),
                },
                editedAlarm: editedAlarm!,
              ));
  }

  void _removeAlarm(Alarm alarm) {
    _registeredAlarms.removeWhere((element) => element.id == alarm.id);
    AlarmPreferences.remove(alarm.id);
    setState(() {});
  }

  void _editAlarm(Alarm alarm) async {
    await _openAddAlarmOverlay(isNewAlarm: false, editedAlarm: alarm);
    setState(() {});
  }

  void _addAlarm(Alarm newAlarm) {
    _registeredAlarms.add(newAlarm);
    setState(() {});
  }

  void _replaceAlarm(Alarm newAlarm) {
    final index =
        _registeredAlarms.indexWhere((element) => element.id == newAlarm.id);
    _registeredAlarms[index] = newAlarm;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (rings && !alreadyRang) {
      Future.delayed(Duration.zero, () => onAlarmTrig(context));
      Timer.run(_runCommand);
      alreadyRang = true;
    }

    Widget mainContent = const Text(
      'No alarm set',
      style: const TextStyle(
        fontSize: 40,
        fontFamily: "comfortaa",
        fontWeight: FontWeight.w700,
      ),
    );

    if (_registeredAlarms.isNotEmpty) {
      mainContent = AlarmList(
        alarms: _registeredAlarms,
        onRemoveAlarm: _removeAlarm,
        onEditAlarm: _editAlarm,
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open New Alarm Screen
          _openAddAlarmOverlay();
        },
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onTertiary,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
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
        child: mainContent,
      ),
    );
  }
}
