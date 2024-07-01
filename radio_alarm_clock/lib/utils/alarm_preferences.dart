import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:radio_alarm_clock/models/alarm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmPreferences {
  static SharedPreferences? _preferences;

  static const _keyAlarms = 'alarms';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setAlarm(Alarm alarm) async {
    await _preferences!.setString(alarm.id, jsonEncode(alarm.toJson()));
  }

  static Alarm getAlarm(String id) {
    final storedString = _preferences!.getString(id);
    if (storedString == null || storedString.isEmpty) {
      return Alarm(id: id, time: TimeOfDay.now()); // or some default value
    }
    return Alarm.fromJson(jsonDecode(storedString));
  }

  static void remove(String id) {
    final idAlarms = _preferences!.getStringList(_keyAlarms) ?? [];
    idAlarms.remove(id);
    _preferences!.setStringList(_keyAlarms, idAlarms);
    _preferences!.remove(id);
  }

  static Future addAlarm(Alarm alarm) async {
    final idAlarms = _preferences!.getStringList(_keyAlarms) ?? [];
    // final newIdAlarms = List.of(idAlarms)..add(alarm.id);

    idAlarms.add(alarm.id);
    await _preferences!.setStringList(_keyAlarms, idAlarms);
    await setAlarm(alarm);
  }

  static List<Alarm> getAlarms() {
    final idAlarms = _preferences!.getStringList(_keyAlarms) ?? [];

    if (idAlarms.isEmpty) {
      return [];
    }
    // return idAlarms.map<Alarm>((id) => getAlarm(id)).toList();
    return idAlarms.map((id) => getAlarm(id)).toList();
  }
}
