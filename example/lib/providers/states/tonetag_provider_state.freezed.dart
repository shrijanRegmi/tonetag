// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tonetag_provider_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TonetagProviderState {
  String get data => throw _privateConstructorUsedError;
  TonetagPlayer get player => throw _privateConstructorUsedError;
  TonetagChannel get channel => throw _privateConstructorUsedError;
  int get volume => throw _privateConstructorUsedError;
  List<String> get receivedData => throw _privateConstructorUsedError;
  TonetagPaymentState get paymentState => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TonetagProviderStateCopyWith<TonetagProviderState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TonetagProviderStateCopyWith<$Res> {
  factory $TonetagProviderStateCopyWith(TonetagProviderState value,
          $Res Function(TonetagProviderState) then) =
      _$TonetagProviderStateCopyWithImpl<$Res, TonetagProviderState>;
  @useResult
  $Res call(
      {String data,
      TonetagPlayer player,
      TonetagChannel channel,
      int volume,
      List<String> receivedData,
      TonetagPaymentState paymentState});
}

/// @nodoc
class _$TonetagProviderStateCopyWithImpl<$Res,
        $Val extends TonetagProviderState>
    implements $TonetagProviderStateCopyWith<$Res> {
  _$TonetagProviderStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? player = null,
    Object? channel = null,
    Object? volume = null,
    Object? receivedData = null,
    Object? paymentState = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      player: null == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as TonetagPlayer,
      channel: null == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as TonetagChannel,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as int,
      receivedData: null == receivedData
          ? _value.receivedData
          : receivedData // ignore: cast_nullable_to_non_nullable
              as List<String>,
      paymentState: null == paymentState
          ? _value.paymentState
          : paymentState // ignore: cast_nullable_to_non_nullable
              as TonetagPaymentState,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TonetagProviderStateCopyWith<$Res>
    implements $TonetagProviderStateCopyWith<$Res> {
  factory _$$_TonetagProviderStateCopyWith(_$_TonetagProviderState value,
          $Res Function(_$_TonetagProviderState) then) =
      __$$_TonetagProviderStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String data,
      TonetagPlayer player,
      TonetagChannel channel,
      int volume,
      List<String> receivedData,
      TonetagPaymentState paymentState});
}

/// @nodoc
class __$$_TonetagProviderStateCopyWithImpl<$Res>
    extends _$TonetagProviderStateCopyWithImpl<$Res, _$_TonetagProviderState>
    implements _$$_TonetagProviderStateCopyWith<$Res> {
  __$$_TonetagProviderStateCopyWithImpl(_$_TonetagProviderState _value,
      $Res Function(_$_TonetagProviderState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? player = null,
    Object? channel = null,
    Object? volume = null,
    Object? receivedData = null,
    Object? paymentState = null,
  }) {
    return _then(_$_TonetagProviderState(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      player: null == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as TonetagPlayer,
      channel: null == channel
          ? _value.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as TonetagChannel,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as int,
      receivedData: null == receivedData
          ? _value._receivedData
          : receivedData // ignore: cast_nullable_to_non_nullable
              as List<String>,
      paymentState: null == paymentState
          ? _value.paymentState
          : paymentState // ignore: cast_nullable_to_non_nullable
              as TonetagPaymentState,
    ));
  }
}

/// @nodoc

class _$_TonetagProviderState implements _TonetagProviderState {
  const _$_TonetagProviderState(
      {required this.data,
      required this.player,
      required this.channel,
      required this.volume,
      final List<String> receivedData = const <String>[],
      this.paymentState = TonetagPaymentState.paying})
      : _receivedData = receivedData;

  @override
  final String data;
  @override
  final TonetagPlayer player;
  @override
  final TonetagChannel channel;
  @override
  final int volume;
  final List<String> _receivedData;
  @override
  @JsonKey()
  List<String> get receivedData {
    if (_receivedData is EqualUnmodifiableListView) return _receivedData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_receivedData);
  }

  @override
  @JsonKey()
  final TonetagPaymentState paymentState;

  @override
  String toString() {
    return 'TonetagProviderState(data: $data, player: $player, channel: $channel, volume: $volume, receivedData: $receivedData, paymentState: $paymentState)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TonetagProviderState &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.player, player) || other.player == player) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.volume, volume) || other.volume == volume) &&
            const DeepCollectionEquality()
                .equals(other._receivedData, _receivedData) &&
            (identical(other.paymentState, paymentState) ||
                other.paymentState == paymentState));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data, player, channel, volume,
      const DeepCollectionEquality().hash(_receivedData), paymentState);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TonetagProviderStateCopyWith<_$_TonetagProviderState> get copyWith =>
      __$$_TonetagProviderStateCopyWithImpl<_$_TonetagProviderState>(
          this, _$identity);
}

abstract class _TonetagProviderState implements TonetagProviderState {
  const factory _TonetagProviderState(
      {required final String data,
      required final TonetagPlayer player,
      required final TonetagChannel channel,
      required final int volume,
      final List<String> receivedData,
      final TonetagPaymentState paymentState}) = _$_TonetagProviderState;

  @override
  String get data;
  @override
  TonetagPlayer get player;
  @override
  TonetagChannel get channel;
  @override
  int get volume;
  @override
  List<String> get receivedData;
  @override
  TonetagPaymentState get paymentState;
  @override
  @JsonKey(ignore: true)
  _$$_TonetagProviderStateCopyWith<_$_TonetagProviderState> get copyWith =>
      throw _privateConstructorUsedError;
}
