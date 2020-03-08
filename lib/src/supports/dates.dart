import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../obj/time_wake_up.dart';

class DateSupport {
  DateSupport() {
    time = DateTime.now();
  }

  DateTime time;

  String formatHHmm([DateTime time]) {
    time ??= this.time;
    return DateFormat('HH:mm').format(time);
  }

  String formatHHmmWithDay(DateTime time) {
    return DateFormat('HH:mm, E').format(time);
//    return DateFormat..format(time);
  }

  String formatWithDayDMY(DateTime time) {
    return DateFormat('HH:mm, dd-MM-yyyy').format(time);
  }

  String formatDMY(DateTime time) {
    return DateFormat('dd-MM-yyyy').format(time);
  }

  List<TimeWakeUp> getTimesWakeUp(
      DateTime sleep, int delayMinutes, double minCycle, double maxCyle) {
    final List<TimeWakeUp> times = [];
    for (int i = minCycle.toInt(); i <= maxCyle.toInt(); i++) {
      times.add(
          TimeWakeUp(sleep.add(Duration(minutes: i * 90 + delayMinutes)), i));
    }
    return times;
  }

  String formatTime(TimeOfDay timeOfDay) {
    final DateTime tmp = DateTime(
        time.year, time.month, time.day, timeOfDay.hour, timeOfDay.minute);
    return DateFormat('HH:mm').format(tmp);
  }
}
