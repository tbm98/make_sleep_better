import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'main_state.freezed.dart';

@freezed
abstract class MainState implements _$MainState {
  const factory MainState({@Default(false) bool darkMode}) = _MainState;
  const MainState._();
  MainState toggle() {
    return MainState(darkMode: !darkMode);
  }
}
