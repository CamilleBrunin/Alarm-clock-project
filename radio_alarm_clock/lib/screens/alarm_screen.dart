import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreen();
}

class _AlarmScreen extends State<AlarmScreen> {
  // Methods
  Future _runCommand() async {
    var shell = Shell();
    await shell.run('./assets/scripts/script.sh');
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _runCommand,
      child: const Text("PLAY MUSIC"),
    );
  }
}
