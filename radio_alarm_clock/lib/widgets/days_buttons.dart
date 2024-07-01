import 'package:flutter/material.dart';

class DaysButtons extends StatelessWidget {
  final List<String> days;
  final ValueChanged<String> onSelectedDay;

  const DaysButtons({
    super.key,
    required this.days,
    required this.onSelectedDay,
  });

  @override
  Widget build(BuildContext context) {
    final background = Theme.of(context).colorScheme.primary.withOpacity(0.4);
    final allDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: background,
        ),
        child: ToggleButtons(
          isSelected: allDays.map((pet) => days.contains(pet)).toList(),
          selectedColor: Theme.of(context).colorScheme.onPrimary,
          color: Theme.of(context).colorScheme.onPrimary,
          fillColor: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
          renderBorder: false,
          children: allDays.map(buildDay).toList(),
          onPressed: (index) => onSelectedDay(allDays[index]),
        ),
      ),
    );
  }

  Widget buildDay(String text) => Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Text(text),
      );
}
