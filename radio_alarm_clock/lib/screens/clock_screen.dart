import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

final formatter = DateFormat('kk:mm');

class Clockcreen extends StatefulWidget {
  const Clockcreen({super.key});

  @override
  State<Clockcreen> createState() => _Clockcreen();
}

class _Clockcreen extends State<Clockcreen> {
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
      child: Text(
        formattedTime,
        textAlign: TextAlign.center,
        style: GoogleFonts.comfortaa(
          textStyle: Theme.of(context).textTheme.displayLarge,
          fontSize: width / 4,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
