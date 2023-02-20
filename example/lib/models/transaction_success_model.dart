import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_success_model.freezed.dart';

@freezed
class TransactionSuccess with _$TransactionSuccess {
  const factory TransactionSuccess({
    required final String txnId,
    required final String amount,
  }) = _TransactionSuccess;
}
