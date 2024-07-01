import 'package:flutter/material.dart';

class Alarm {
  final String id;
  final bool active;
  final List<String> days;
  final TimeOfDay time;

  Alarm({
    required this.id,
    required this.time,
    this.active = true,
    this.days = const [],
  });

  Alarm copyWith({
    String? id,
    TimeOfDay? time,
    bool? active,
    List<String>? days,
  }) {
    return Alarm(
      id: id ?? this.id,
      time: time ?? this.time,
      active: active ?? this.active,
      days: days ?? this.days,
    );
  }

  static Alarm fromJson(Map<String, dynamic> json) {
    return Alarm(
      id: json['id'],
      time: TimeOfDay(
        hour: json['hour'],
        minute: json['minute'],
      ),
      active: json['active'],
      days: List<String>.from(json['days']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hour': time.hour,
      'minute': time.minute,
      'active': active,
      'days': days,
    };
  }
}
