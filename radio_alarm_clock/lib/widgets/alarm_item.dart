import 'package:flutter/material.dart';
import 'package:radio_alarm_clock/constants.dart';
import 'package:radio_alarm_clock/models/alarm.dart';

class AlarmItem extends StatefulWidget {
  const AlarmItem(
    this.alarm, {
    super.key,
    required this.onEditAlarm,
    required this.onRemoveAlarm,
  });

  final Alarm alarm;
  final void Function(Alarm alarm) onEditAlarm;
  final void Function(Alarm alarm) onRemoveAlarm;

  @override
  State<AlarmItem> createState() => _AlarmItem();
}

class _AlarmItem extends State<AlarmItem> {
  late Alarm alarm;

  @override
  void initState() {
    alarm = widget.alarm;
    super.initState();
  }

  // Widgets
  Widget buildSwitch() {
    return Switch(
      value: alarm.active,
      onChanged: (bool value) {
        setState(() {
          alarm = alarm.copyWith(active: value);
        });
      },
    );
  }

  Widget builtDays() {
    final allDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    if (alarm.days.isEmpty) {
      return const Text(
        'No days selected',
        style: TextStyle(fontSize: 20),
      );
    } else if (alarm.days.length == 7) {
      return const Text(
        'Everyday',
        style: TextStyle(fontSize: 20),
      );
    } else {
      alarm.days
          .sort((a, b) => allDays.indexOf(a).compareTo(allDays.indexOf(b)));
      return Row(
        children: [
          for (var day in alarm.days)
            Text(
              '${day} ',
              style: TextStyle(fontSize: 20),
            ),
        ],
      );
    }
  }

  Widget buildTime(BuildContext context) {
    return Text(
      formatter.format(DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        alarm.time.hour,
        alarm.time.minute,
      )),
      style: const TextStyle(
        fontSize: 100,
        fontFamily: "comfortaa",
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget buildEditButton() {
    return IconButton(
      onPressed: () {
        // Change screen to new_alarm.dart
      },
      icon: const Icon(Icons.edit),
    );
  }

  Future<void> onAlarmLongPress(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete alarm?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                setState(() {
                  widget.onRemoveAlarm(alarm);
                });
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
    return GestureDetector(
      onTap: () {
        setState(() {
          // Edit alarm
          widget.onEditAlarm(alarm);
        });
      },
      onLongPress: () => onAlarmLongPress(context), // Remove alarm
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // buildEditButton(),
                  buildTime(context),
                  buildSwitch(),
                ],
              ),
              builtDays(),
            ],
          ),
        ),
      ),
    );
  }
}
