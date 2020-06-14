// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'main_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$MainStateTearOff {
  const _$MainStateTearOff();

  _MainState call({bool darkMode = false}) {
    return _MainState(
      darkMode: darkMode,
    );
  }
}

// ignore: unused_element
const $MainState = _$MainStateTearOff();

mixin _$MainState {
  bool get darkMode;

  $MainStateCopyWith<MainState> get copyWith;
}

abstract class $MainStateCopyWith<$Res> {
  factory $MainStateCopyWith(MainState value, $Res Function(MainState) then) =
      _$MainStateCopyWithImpl<$Res>;
  $Res call({bool darkMode});
}

class _$MainStateCopyWithImpl<$Res> implements $MainStateCopyWith<$Res> {
  _$MainStateCopyWithImpl(this._value, this._then);

  final MainState _value;
  // ignore: unused_field
  final $Res Function(MainState) _then;

  @override
  $Res call({
    Object darkMode = freezed,
  }) {
    return _then(_value.copyWith(
      darkMode: darkMode == freezed ? _value.darkMode : darkMode as bool,
    ));
  }
}

abstract class _$MainStateCopyWith<$Res> implements $MainStateCopyWith<$Res> {
  factory _$MainStateCopyWith(
          _MainState value, $Res Function(_MainState) then) =
      __$MainStateCopyWithImpl<$Res>;
  @override
  $Res call({bool darkMode});
}

class __$MainStateCopyWithImpl<$Res> extends _$MainStateCopyWithImpl<$Res>
    implements _$MainStateCopyWith<$Res> {
  __$MainStateCopyWithImpl(_MainState _value, $Res Function(_MainState) _then)
      : super(_value, (v) => _then(v as _MainState));

  @override
  _MainState get _value => super._value as _MainState;

  @override
  $Res call({
    Object darkMode = freezed,
  }) {
    return _then(_MainState(
      darkMode: darkMode == freezed ? _value.darkMode : darkMode as bool,
    ));
  }
}

class _$_MainState extends _MainState with DiagnosticableTreeMixin {
  const _$_MainState({this.darkMode = false})
      : assert(darkMode != null),
        super._();

  @JsonKey(defaultValue: false)
  @override
  final bool darkMode;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MainState(darkMode: $darkMode)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'MainState'))
      ..add(DiagnosticsProperty('darkMode', darkMode));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _MainState &&
            (identical(other.darkMode, darkMode) ||
                const DeepCollectionEquality()
                    .equals(other.darkMode, darkMode)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(darkMode);

  @override
  _$MainStateCopyWith<_MainState> get copyWith =>
      __$MainStateCopyWithImpl<_MainState>(this, _$identity);
}

abstract class _MainState extends MainState {
  const _MainState._() : super._();
  const factory _MainState({bool darkMode}) = _$_MainState;

  @override
  bool get darkMode;
  @override
  _$MainStateCopyWith<_MainState> get copyWith;
}
