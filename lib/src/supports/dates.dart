import 'package:flutter/material.dart';
import 'package:make_sleep_better/src/obj/time_wake_up.dart';

class DateSupport {
  DateTime time;

  DateSupport() {
    time = DateTime.now();
  }

  String format(DateTime time) {
    return '${time.hour}:${time.minute}';
  }

  Future<List<TimeWakeUp>> getTimesWakeUp(
      DateTime sleep, int delayMinutes, double minCycle, double maxCyle) async {
    List<TimeWakeUp> times = [];
    for (int i = minCycle.toInt(); i <= maxCyle.toInt(); i++) {
      times.add(TimeWakeUp(sleep.add(Duration(minutes: i * 90 + delayMinutes)),i));
    }
    return times;
  }
}
