import 'package:flutter/material.dart';
import 'package:radio_alarm_clock/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.useLightMode,
    required this.colorSelected,
    required this.handleBrightnessChange,
    required this.handleColorSelect,
  });

  final void Function(bool) handleBrightnessChange;
  final void Function(int) handleColorSelect;

  final bool useLightMode;
  final ColorSeed colorSelected;

  @override
  State<SettingsScreen> createState() => _Settings();
}

class _Settings extends State<SettingsScreen> {
  // Other
  bool light1 = false;
  bool light2 = true;

  final WidgetStateProperty<Icon?> thumbIcon =
      WidgetStateProperty.resolveWith<Icon?>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );

  Widget switches() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Switch(
          thumbIcon: thumbIcon,
          value: light1,
          onChanged: (bool value) {
            setState(() {
              light1 = value;
            });
          },
        ),
        Switch(
          thumbIcon: thumbIcon,
          value: light2,
          onChanged: (bool value) {
            setState(() {
              light2 = value;
            });
          },
        ),
      ],
    );
  }

  Widget _lightMode() {
    return Row(
      children: [
        const Text('Light mode',
            style: TextStyle(
              fontSize: titleSmall,
            )),
        const SizedBox(width: 10,),
        Switch(
            value: widget.useLightMode,
            onChanged: (value) {
              widget.handleBrightnessChange(value);
            })
      ],
    );
  }

  Widget _colorSeed() {
    return Row(
      children: [
        const Text('Color theme',
            style: TextStyle(
              fontSize: titleSmall,
            )),
        Row(
          children: List.generate(
            ColorSeed.values.length,
            (i) => IconButton(
              icon: const Icon(Icons.radio_button_unchecked),
              color: ColorSeed.values[i].color,
              isSelected:
                  widget.colorSelected.color == ColorSeed.values[i].color,
              selectedIcon: const Icon(Icons.circle),
              onPressed: () {
                widget.handleColorSelect(i);
              },
              tooltip: ColorSeed.values[i].label,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          switches(),
          const Divider(),
          const Text('Appearance',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: headlineSmall,
              )),
          _lightMode(),
          _colorSeed(),
        ],
      ),
    );
  }
}
