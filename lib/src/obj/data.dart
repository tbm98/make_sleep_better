class Data {
  Data({this.timeWakeUp, this.feedback, this.level});

  factory Data.fromMap(Map<String, dynamic> map) {
    return Data(
      timeWakeUp: DateTime.parse(map['timeWakeUp']),
      feedback: map['feedback'] as bool,
      level: map['level'] as int,
    );
  }

  DateTime timeWakeUp;
  bool feedback;

  ///level 0: chưa đánh giá
  ///level 1: không thoải mái
  ///level 2: bình thường
  ///lebel 3: thoải mái, vui vẻ
  int level;

  Map<String, dynamic> toJson() {
    return {
      'timeWakeUp': timeWakeUp.toString(),
      'feedback': feedback,
      'level': level,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'timeWakeUp': timeWakeUp,
      'feedback': feedback,
      'level': level,
    };
  }
}
