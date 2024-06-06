import 'package:digital_lcd_number/digital_lcd_number.dart';
import 'package:flutter/material.dart';

class DigitalLcd extends StatefulWidget {
  const DigitalLcd({super.key, required this.hours, required this.minutes});

  final int hours;
  final int minutes;

  @override
  State<StatefulWidget> createState() {
    return _DigitalLcdState();
  }
}

class _DigitalLcdState extends State<DigitalLcd> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height / 2,
      // width: width,
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          children: [
            DigitalLcdNumber(
              number: (widget.hours ~/ 10) % 10, // 1st digit
              // color: Colors.red,
            ),
            DigitalLcdNumber(
              number: widget.hours % 10, // 2nd digit
              // color: Colors.red,
            ),
            const SizedBox(width: 50,),
            DigitalLcdNumber(
              number: (widget.minutes ~/ 10) % 10, // 1st digit
              // color: Colors.red,
            ),
            DigitalLcdNumber(
              number: widget.minutes % 10, // 2nd digit
              // color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}