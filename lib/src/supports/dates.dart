import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:make_sleep_better/src/obj/time_wake_up.dart';

class DateSupport {
  DateSupport() {
    time = DateTime.now();
  }

  DateTime time;

  String formatWithoutDay() {
    return DateFormat('HH:mm').format(time);
  }

  String formatWithDay(DateTime time) {
    return DateFormat('HH:mm, E').format(time);
//    return DateFormat..format(time);
  }

  List<TimeWakeUp> getTimesWakeUp(
      DateTime sleep, int delayMinutes, double minCycle, double maxCyle) {
    List<TimeWakeUp> times = [];
    for (int i = minCycle.toInt(); i <= maxCyle.toInt(); i++) {
      times.add(
          TimeWakeUp(sleep.add(Duration(minutes: i * 90 + delayMinutes)), i));
    }
    return times;
  }

  String formatTime(TimeOfDay timeOfDay) {
    DateTime tmp = DateTime(
        time.year, time.month, time.day, timeOfDay.hour, timeOfDay.minute);
    return DateFormat('HH:mm').format(tmp);
  }
}
