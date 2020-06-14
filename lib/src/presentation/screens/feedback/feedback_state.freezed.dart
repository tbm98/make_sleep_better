// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'feedback_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$FeedbackStateTearOff {
  const _$FeedbackStateTearOff();

  _FeedbackState call({List<Data> listDataWakeUp}) {
    return _FeedbackState(
      listDataWakeUp: listDataWakeUp,
    );
  }
}

// ignore: unused_element
const $FeedbackState = _$FeedbackStateTearOff();

mixin _$FeedbackState {
  List<Data> get listDataWakeUp;

  $FeedbackStateCopyWith<FeedbackState> get copyWith;
}

abstract class $FeedbackStateCopyWith<$Res> {
  factory $FeedbackStateCopyWith(
          FeedbackState value, $Res Function(FeedbackState) then) =
      _$FeedbackStateCopyWithImpl<$Res>;
  $Res call({List<Data> listDataWakeUp});
}

class _$FeedbackStateCopyWithImpl<$Res>
    implements $FeedbackStateCopyWith<$Res> {
  _$FeedbackStateCopyWithImpl(this._value, this._then);

  final FeedbackState _value;
  // ignore: unused_field
  final $Res Function(FeedbackState) _then;

  @override
  $Res call({
    Object listDataWakeUp = freezed,
  }) {
    return _then(_value.copyWith(
      listDataWakeUp: listDataWakeUp == freezed
          ? _value.listDataWakeUp
          : listDataWakeUp as List<Data>,
    ));
  }
}

abstract class _$FeedbackStateCopyWith<$Res>
    implements $FeedbackStateCopyWith<$Res> {
  factory _$FeedbackStateCopyWith(
          _FeedbackState value, $Res Function(_FeedbackState) then) =
      __$FeedbackStateCopyWithImpl<$Res>;
  @override
  $Res call({List<Data> listDataWakeUp});
}

class __$FeedbackStateCopyWithImpl<$Res>
    extends _$FeedbackStateCopyWithImpl<$Res>
    implements _$FeedbackStateCopyWith<$Res> {
  __$FeedbackStateCopyWithImpl(
      _FeedbackState _value, $Res Function(_FeedbackState) _then)
      : super(_value, (v) => _then(v as _FeedbackState));

  @override
  _FeedbackState get _value => super._value as _FeedbackState;

  @override
  $Res call({
    Object listDataWakeUp = freezed,
  }) {
    return _then(_FeedbackState(
      listDataWakeUp: listDataWakeUp == freezed
          ? _value.listDataWakeUp
          : listDataWakeUp as List<Data>,
    ));
  }
}

class _$_FeedbackState with DiagnosticableTreeMixin implements _FeedbackState {
  const _$_FeedbackState({this.listDataWakeUp});

  @override
  final List<Data> listDataWakeUp;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FeedbackState(listDataWakeUp: $listDataWakeUp)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'FeedbackState'))
      ..add(DiagnosticsProperty('listDataWakeUp', listDataWakeUp));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _FeedbackState &&
            (identical(other.listDataWakeUp, listDataWakeUp) ||
                const DeepCollectionEquality()
                    .equals(other.listDataWakeUp, listDataWakeUp)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(listDataWakeUp);

  @override
  _$FeedbackStateCopyWith<_FeedbackState> get copyWith =>
      __$FeedbackStateCopyWithImpl<_FeedbackState>(this, _$identity);
}

abstract class _FeedbackState implements FeedbackState {
  const factory _FeedbackState({List<Data> listDataWakeUp}) = _$_FeedbackState;

  @override
  List<Data> get listDataWakeUp;
  @override
  _$FeedbackStateCopyWith<_FeedbackState> get copyWith;
}
