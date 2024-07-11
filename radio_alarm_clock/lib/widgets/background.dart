import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({
    super.key,
    required this.content,
  });

  final Widget content;

  Gradient _background1(BuildContext context) {
    return SweepGradient(
      center: FractionalOffset.center,
      colors: <Color>[
        const Color(0xFF4285F4).withOpacity(0.5), // blue
        const Color(0xFF34A853).withOpacity(0.5), // green
        const Color(0xFFFBBC05).withOpacity(0.5), // yellow
        const Color(0xFFEA4335).withOpacity(0.5), // red
        // blue again to seamlessly transition to the start
        const Color(0xFF4285F4).withOpacity(0.5),
      ],
      stops: const <double>[0.0, 0.25, 0.5, 0.75, 1.0],
    );
  }

  Gradient _background2(BuildContext context) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Theme.of(context).colorScheme.primaryContainer,
        Theme.of(context).colorScheme.tertiaryContainer,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: _background1(context),
      ),
      child: content,
    );
  }
}
