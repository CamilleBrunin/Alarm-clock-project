import 'package:flutter/material.dart';
import 'package:flutter_spinner_time_picker/flutter_spinner_time_picker.dart';
import 'package:radio_alarm_clock/constants.dart';
import 'package:radio_alarm_clock/models/alarm.dart';
import 'package:radio_alarm_clock/utils/alarm_preferences.dart';
import 'package:radio_alarm_clock/widgets/background.dart';
import 'package:radio_alarm_clock/widgets/days_buttons.dart';
import 'package:uuid/uuid.dart';

class NewAlarm extends StatefulWidget {
  const NewAlarm({
    super.key,
    required this.onAddAlarm,
    this.editedAlarm,
  });

  final void Function(Alarm alarm) onAddAlarm;
  final Alarm? editedAlarm;

  @override
  State<NewAlarm> createState() => _NewAlarm();
}

class _NewAlarm extends State<NewAlarm> {
  Alarm alarm = Alarm(
    id: const Uuid().v4(),
    time: TimeOfDay.now(),
  );

  @override
  void initState() {
    if (widget.editedAlarm != null) {
      alarm = AlarmPreferences.getAlarm(widget.editedAlarm!.id);
    } else {
      alarm = AlarmPreferences.getAlarm(alarm.id);
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Methods
  void _presentTimePicker() async {
    final maxWidth = MediaQuery.of(context).size.width;
    final maxHeight = MediaQuery.of(context).size.height;
    // 'await' is telling flutter to wait for the Future value before storing it in the variable
    final pickedTime = await showSpinnerTimePicker(
      context,
      initTime: TimeOfDay.now(),
      height: maxHeight / 2,
      width: maxWidth / 2,
      is24HourFormat: true,
      title: '',
      barrierDismissible: false,
      spinnerHeight: maxHeight,
      digitHeight: maxHeight / 5,
      spinnerWidth: maxWidth / 5,
      contentPadding: const EdgeInsets.all(5),
      selectedTextStyle: TextStyle(
        fontSize: 70,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      nonSelectedTextStyle: TextStyle(
        fontSize: 40,
        color: Theme.of(context).colorScheme.primary,
      ),
    );

    setState(() {
      alarm = alarm.copyWith(time: pickedTime);
    });
  }

  // Widgets
  Widget buildButton() {
    return ElevatedButton(
      onPressed: () async {
        final isNewAlarm = widget.editedAlarm == null;

        if (isNewAlarm) {
          await AlarmPreferences.addAlarm(alarm);
          await AlarmPreferences.setAlarm(alarm);
        } else {
          await AlarmPreferences.setAlarm(alarm);
        }

        // Access the variables implemented by the Widget class in the State class by using the widget property
        widget.onAddAlarm(alarm);
        // Close overlay
        Navigator.pop(context);
      },
      child: const Text('Save'),
    );
  }

  Widget buildTimePicker() {
    return TextButton(
      onPressed: _presentTimePicker,
      style: TextButton.styleFrom(
        // shadowColor: Theme.of(context).colorScheme.secondary,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        // foregroundColor: Theme.of(context).colorScheme.tertiary,
      ),
      child: Text(
        formatter.format(DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          alarm.time.hour,
          alarm.time.minute,
        )),
        style: const TextStyle(
          fontSize: 80,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildDays() => DaysButtons(
        days: alarm.days,
        onSelectedDay: (day) => setState(() {
          final days = alarm.days.contains(day)
              ? (List.of(alarm.days)..remove(day))
              : (List.of(alarm.days)..add(day));

          setState(() {
            alarm = alarm.copyWith(days: days);
          });
        }),
      );

  Widget newAlarm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimePicker(),
        buildDays(),
        const SizedBox(
          height: 20,
        ),
        buildButton(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Background(content: newAlarm());
  }
}
