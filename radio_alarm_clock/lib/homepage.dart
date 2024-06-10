import 'package:flutter/material.dart';
import 'package:radio_alarm_clock/constants.dart';
import 'package:radio_alarm_clock/screens/alarm_screen.dart';
import 'package:radio_alarm_clock/screens/clock_screen.dart';
import 'package:radio_alarm_clock/screens/settings_screen.dart';

import 'package:radio_alarm_clock/widgets/digital_lcd.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.useLightMode,
    required this.colorSelected,
    required this.handleBrightnessChange,
    required this.handleColorSelect,
  });

  final bool useLightMode;
  final ColorSeed colorSelected;

  final void Function(bool useLightMode) handleBrightnessChange;
  final void Function(int value) handleColorSelect;

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
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
    return Scaffold(
      body: PageView(
        children: [
          Clockcreen(),
          AlarmScreen(),
          // clockWidget(),
          SettingsScreen(
            useLightMode: widget.useLightMode,
            colorSelected: widget.colorSelected,
            handleBrightnessChange: widget.handleBrightnessChange,
            handleColorSelect: widget.handleColorSelect,
          ),
        ],
      ),
    );
  }
}
