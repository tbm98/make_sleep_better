// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FeedbackState _$_$_FeedbackStateFromJson(Map<String, dynamic> json) {
  return _$_FeedbackState(
    listDataWakeUp: (json['listDataWakeUp'] as List)
        ?.map(
            (e) => e == null ? null : Data.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$_$_FeedbackStateToJson(_$_FeedbackState instance) =>
    <String, dynamic>{
      'listDataWakeUp': instance.listDataWakeUp,
    };
