import 'package:flutter/material.dart';

class Data {
  Data(
      {this.timeSleep,
      this.timeWakeUp,
      this.cycleSleep,
      this.feedback,
      this.level});

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      timeSleep: DateTime.tryParse(map['timeSleep'] ?? ''),
      timeWakeUp: DateTime.tryParse(map['timeWakeUp'] ?? ''),
      cycleSleep: map['cycleSleep'] as int,
      feedback: map['feedback'] as bool,
      level: map['level'] as int,
    );
  }

  int get id => timeSleep.millisecondsSinceEpoch;
  DateTime timeSleep;
  DateTime timeWakeUp;
  int cycleSleep;
  bool feedback;

  ///level 0: chưa đánh giá
  ///level 1: không thoải mái
  ///level 2: bình thường
  ///lebel 3: thoải mái, vui vẻ
  int level;

  Map<String, dynamic> toJson() {
    return {
      'timeSleep': timeSleep.toString(),
      'timeWakeUp': timeWakeUp.toString(),
      'cycleSleep': cycleSleep,
      'feedback': feedback,
      'level': level,
    };
  }
}
