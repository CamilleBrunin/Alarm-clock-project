import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:process_run/shell.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:radio_alarm_clock/constants.dart';
import 'package:radio_alarm_clock/settings_screen.dart';

import 'package:radio_alarm_clock/widgets/digital_lcd.dart';

final formatter = DateFormat('kk:mm');

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
    final width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
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
                icon: Icon(Icons.settings),
                text: "Settings",
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
            Center(
              child: Text(
                formattedTime,
                textAlign: TextAlign.center,
                style: GoogleFonts.comfortaa(
                  textStyle: Theme.of(context).textTheme.displayLarge,
                  fontSize: width / 4,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            // clockWidget(),
            Settings(
              useLightMode: widget.useLightMode,
              colorSelected: widget.colorSelected,
              handleBrightnessChange: widget.handleBrightnessChange,
              handleColorSelect: widget.handleColorSelect,
            ),
          ],
        ),
      ),
    );
  }
}
