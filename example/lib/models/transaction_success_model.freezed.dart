// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_success_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TransactionSuccess {
  String get txnId => throw _privateConstructorUsedError;
  String get receiverId => throw _privateConstructorUsedError;
  String get amount => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TransactionSuccessCopyWith<TransactionSuccess> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionSuccessCopyWith<$Res> {
  factory $TransactionSuccessCopyWith(
          TransactionSuccess value, $Res Function(TransactionSuccess) then) =
      _$TransactionSuccessCopyWithImpl<$Res, TransactionSuccess>;
  @useResult
  $Res call({String txnId, String receiverId, String amount});
}

/// @nodoc
class _$TransactionSuccessCopyWithImpl<$Res, $Val extends TransactionSuccess>
    implements $TransactionSuccessCopyWith<$Res> {
  _$TransactionSuccessCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? txnId = null,
    Object? receiverId = null,
    Object? amount = null,
  }) {
    return _then(_value.copyWith(
      txnId: null == txnId
          ? _value.txnId
          : txnId // ignore: cast_nullable_to_non_nullable
              as String,
      receiverId: null == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TransactionSuccessCopyWith<$Res>
    implements $TransactionSuccessCopyWith<$Res> {
  factory _$$_TransactionSuccessCopyWith(_$_TransactionSuccess value,
          $Res Function(_$_TransactionSuccess) then) =
      __$$_TransactionSuccessCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String txnId, String receiverId, String amount});
}

/// @nodoc
class __$$_TransactionSuccessCopyWithImpl<$Res>
    extends _$TransactionSuccessCopyWithImpl<$Res, _$_TransactionSuccess>
    implements _$$_TransactionSuccessCopyWith<$Res> {
  __$$_TransactionSuccessCopyWithImpl(
      _$_TransactionSuccess _value, $Res Function(_$_TransactionSuccess) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? txnId = null,
    Object? receiverId = null,
    Object? amount = null,
  }) {
    return _then(_$_TransactionSuccess(
      txnId: null == txnId
          ? _value.txnId
          : txnId // ignore: cast_nullable_to_non_nullable
              as String,
      receiverId: null == receiverId
          ? _value.receiverId
          : receiverId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_TransactionSuccess extends _TransactionSuccess
    with DiagnosticableTreeMixin {
  const _$_TransactionSuccess(
      {required this.txnId, required this.receiverId, required this.amount})
      : super._();

  @override
  final String txnId;
  @override
  final String receiverId;
  @override
  final String amount;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'TransactionSuccess(txnId: $txnId, receiverId: $receiverId, amount: $amount)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'TransactionSuccess'))
      ..add(DiagnosticsProperty('txnId', txnId))
      ..add(DiagnosticsProperty('receiverId', receiverId))
      ..add(DiagnosticsProperty('amount', amount));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TransactionSuccess &&
            (identical(other.txnId, txnId) || other.txnId == txnId) &&
            (identical(other.receiverId, receiverId) ||
                other.receiverId == receiverId) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, txnId, receiverId, amount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TransactionSuccessCopyWith<_$_TransactionSuccess> get copyWith =>
      __$$_TransactionSuccessCopyWithImpl<_$_TransactionSuccess>(
          this, _$identity);
}

abstract class _TransactionSuccess extends TransactionSuccess {
  const factory _TransactionSuccess(
      {required final String txnId,
      required final String receiverId,
      required final String amount}) = _$_TransactionSuccess;
  const _TransactionSuccess._() : super._();

  @override
  String get txnId;
  @override
  String get receiverId;
  @override
  String get amount;
  @override
  @JsonKey(ignore: true)
  _$$_TransactionSuccessCopyWith<_$_TransactionSuccess> get copyWith =>
      throw _privateConstructorUsedError;
}
