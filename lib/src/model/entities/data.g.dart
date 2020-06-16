// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
    timeSleep: json['timeSleep'] == null
        ? null
        : DateTime.parse(json['timeSleep'] as String) ?? '',
    timeWakeUp: json['timeWakeUp'] == null
        ? null
        : DateTime.parse(json['timeWakeUp'] as String) ?? '',
    cycleSleep: json['cycleSleep'] as int,
    feedback: json['feedback'] as bool,
    level: json['level'] as int,
  );
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'timeSleep': instance.timeSleep?.toIso8601String(),
      'timeWakeUp': instance.timeWakeUp?.toIso8601String(),
      'cycleSleep': instance.cycleSleep,
      'feedback': instance.feedback,
      'level': instance.level,
    };
