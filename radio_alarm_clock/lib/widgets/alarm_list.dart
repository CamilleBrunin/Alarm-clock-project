import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:radio_alarm_clock/models/alarm.dart';
import 'package:radio_alarm_clock/widgets/alarm_item.dart';

class AlarmList extends StatelessWidget {
  const AlarmList({
    super.key,
    required this.alarms,
    required this.onRemoveAlarm,
    required this.onEditAlarm,
  });

  final List<Alarm> alarms;
  final void Function(Alarm alarm) onRemoveAlarm;
  final void Function(Alarm alarm) onEditAlarm;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: alarms.length,
      // Slidable widget is a widget allowing to execute actions on the wrapped widget by swiping it
      // Here the Slidable widget is used to update the builder of the ListView once an alarm has been removed or edited
      itemBuilder: (ctx, index) => Slidable(
        // Create a key object that can be used for this parameter, to make sure that the correct data will be deleted
        key: ValueKey(alarms[index]),
        // Disable the slide action
        enabled: false,
        child: AlarmItem(
          alarms[index],
          onEditAlarm: onEditAlarm,
          onRemoveAlarm: onRemoveAlarm,
        ),
      ),
    );
  }
}
