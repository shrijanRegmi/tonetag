import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tonetag/enums/tonetag_channel_type.dart';
import 'package:tonetag/enums/tonetag_player_type.dart';
import 'package:tonetag_example/enums/tonetag_payment_state.dart';

import '../../models/transaction_success_model.dart';

part 'tonetag_provider_state.freezed.dart';

@freezed
class TonetagProviderState with _$TonetagProviderState {
  const factory TonetagProviderState({
    required final String data,
    required final TonetagPlayer player,
    required final TonetagChannel channel,
    required final int volume,
    required final TextEditingController amountController,
    @Default(TonetagPaymentState.paying) final TonetagPaymentState paymentState,
    @Default(<String>[]) final List<String> receivedRequests,
    @Default(<TransactionSuccess>[])
        final List<TransactionSuccess> transactionSuccesses,
  }) = _TonetagProviderState;
}
