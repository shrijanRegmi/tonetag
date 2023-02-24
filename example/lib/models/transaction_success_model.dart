import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tonetag_example/extensions/data_to_send_extension.dart';

import '../utils/contants.dart';

part 'transaction_success_model.freezed.dart';

@freezed
class TransactionSuccess with _$TransactionSuccess {
  const TransactionSuccess._();

  const factory TransactionSuccess({
    required final String txnId,
    required final String receiverId,
    required final String amount,
  }) = _TransactionSuccess;

  factory TransactionSuccess.fromReceivedData(final String data) {
    final receiverId = data
        .substring(
          ksCodeP2PTransaction.length,
          ksCodeP2PTransaction.length + kiLengthUid,
        )
        .toReverse;
    final txnId = data.substring(
      ksCodeP2PTransaction.length + receiverId.length,
      ksCodeP2PTransaction.length + receiverId.length + kiLengthTxnId,
    );
    final amount = data.substring(
      ksCodeP2PTransaction.length +
          receiverId.length +
          txnId.length +
          ksCodeP2PTransactionSuccess.length,
    );
    return TransactionSuccess(
      txnId: txnId,
      receiverId: receiverId,
      amount: amount,
    );
  }

  String get toDataToSend =>
      '$ksCodeP2PTransaction${receiverId.toReverse}$txnId$ksCodeP2PTransactionSuccess$amount';
}
