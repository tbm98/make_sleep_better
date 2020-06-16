import 'package:freezed_annotation/freezed_annotation.dart';

part 'data.g.dart';

@JsonSerializable()
class Data {
  Data(
      {this.timeSleep,
      this.timeWakeUp,
      this.cycleSleep,
      this.feedback,
      this.level});

  int get id => timeWakeUp.millisecondsSinceEpoch;
  @JsonKey(defaultValue: '')
  DateTime timeSleep;
  @JsonKey(defaultValue: '')
  DateTime timeWakeUp;
  int cycleSleep;
  bool feedback;

  ///level 0: chưa đánh giá
  ///level 1: không thoải mái
  ///level 2: bình thường
  ///lebel 3: thoải mái, vui vẻ
  int level;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
