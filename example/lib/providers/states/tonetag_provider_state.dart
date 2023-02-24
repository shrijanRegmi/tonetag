import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tonetag/enums/tonetag_channel_type.dart';
import 'package:tonetag/enums/tonetag_player_type.dart';
import 'package:tonetag_example/enums/transfered_data_type.dart';

import '../../enums/tonetag_connection_state.dart';
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
    @Default(TonetagConnectionState.idle)
        final TonetagConnectionState connectionState,
    @Default(TransferedDataType.unknown) final TransferedDataType sentDataType,
    @Default(<String>[]) final List<String> receivedRequests,
    @Default(<TransactionSuccess>[])
        final List<TransactionSuccess> transactionSuccesses,
    @Default(<String, int>{}) final Map<String, int> receiveRequestsCounter,
  }) = _TonetagProviderState;
}
