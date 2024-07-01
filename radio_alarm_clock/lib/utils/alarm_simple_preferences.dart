import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmSimplePreferences {
  static SharedPreferences? _preferences;

  static const _keyAlarmTime = 'alarmTime';
  static const _keyRings = 'rings';
  static const _keyAlreadyRang = 'alreadyRang';
  static const _keyAlarmDays = 'alarmDays';
  static const _keyActive = 'active';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static TimeOfDay get alarmTime {
    final storedString = _preferences!.getString(_keyAlarmTime);
    if (storedString == null || storedString.isEmpty) {
      return TimeOfDay.now(); // or some default value
    }
    return TimeOfDay.fromDateTime(DateTime.parse(storedString));
  }

  static set alarmTime(TimeOfDay value) => _preferences!.setString(
        _keyAlarmTime,
        DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          value.hour,
          value.minute,
        ).toIso8601String(),
      );

  static List<String> get alarmDays =>
      _preferences!.getStringList(_keyAlarmDays) ?? [];

  static set alarmDays(List<String> value) => _preferences!.setStringList(
        _keyAlarmDays,
        value,
      );

  static bool get active => _preferences!.getBool(_keyActive) ?? false;

  static set active(bool value) => _preferences!.setBool(_keyActive, value);

  // static bool get rings => _preferences!.getBool(_keyRings) ?? false;

  // static set rings(bool value) => _preferences!.setBool(_keyRings, value);

  // static bool get alreadyRang =>
  //     _preferences!.getBool(_keyAlreadyRang) ?? false;

  // static set alreadyRang(bool value) =>
  //     _preferences!.setBool(_keyAlreadyRang, value);

  static void clear() => _preferences!.clear();

  static void remove(String key) => _preferences!.remove(key);
}
