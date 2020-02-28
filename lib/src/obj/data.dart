import 'package:flutter/material.dart';

class Data {
  Data(
      {@required this.id,
      this.timeSleep,
      this.timeWakeUp,
      this.totalSleepTime,
      this.feedback,
      this.level});

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      id: map['id'] as int,
      timeSleep: DateTime.tryParse(map['timeSleep'] ?? ''),
      timeWakeUp: DateTime.tryParse(map['timeWakeUp'] ?? ''),
      totalSleepTime: map['totalSleepTime'] as int,
      feedback: map['feedback'] as bool,
      level: map['level'] as int,
    );
  }

  int id;
  DateTime timeSleep;
  DateTime timeWakeUp;
  int totalSleepTime;
  bool feedback;

  ///level 0: chưa đánh giá
  ///level 1: không thoải mái
  ///level 2: bình thường
  ///lebel 3: thoải mái, vui vẻ
  int level;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timeSleep': timeSleep.toString(),
      'timeWakeUp': timeWakeUp.toString(),
      'totalSleepTime': totalSleepTime,
      'feedback': feedback,
      'level': level,
    };
  }
}
