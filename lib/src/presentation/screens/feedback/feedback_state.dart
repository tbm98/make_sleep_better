import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:make_sleep_better/src/model/entities/data.dart';

part 'feedback_state.freezed.dart';
part 'feedback_state.g.dart';

@freezed
abstract class FeedbackState with _$FeedbackState {
  const factory FeedbackState({List<Data> listDataWakeUp}) = _FeedbackState;

  factory FeedbackState.fromJson(Map<String, dynamic> json) =>
      _$FeedbackStateFromJson(json);
}
