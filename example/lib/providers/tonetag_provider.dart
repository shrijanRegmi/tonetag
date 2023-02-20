import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tonetag/tonetag.dart';
import 'package:tonetag_example/enums/tonetag_payment_state.dart';
import 'package:tonetag_example/extensions/data_to_send_extension.dart';
import 'package:tonetag_example/models/transaction_success_model.dart';
import 'package:tonetag_example/utils/string_contants.dart';
import 'package:tonetag_example/widgets/transaction_dialogs.dart';

import 'states/tonetag_provider_state.dart';

final providerOfTonetag =
    StateNotifierProvider.autoDispose<TonetagProvider, TonetagProviderState>(
  (ref) {
    final prov = TonetagProvider(ref);
    ref.onDispose(() {
      prov
        ..stopReceiveRequest()
        ..stopListeningToReceiveRequests();
    });
    return prov;
  },
);

final providerOfReceivedDataStream =
    StreamProvider<Map<String, dynamic>>((ref) {
  final tonetag = Tonetag();
  return tonetag.onDataReceived;
});

final providerOfIsSendingDataStream = StreamProvider<bool>((ref) {
  final tonetag = Tonetag();
  return tonetag.isSendingData;
});

final providerOfIsReceivingDataStream = StreamProvider<bool>((ref) {
  final tonetag = Tonetag();
  return tonetag.isReceivingData;
});

class TonetagProvider extends StateNotifier<TonetagProviderState> {
  TonetagProvider(final Ref ref)
      : _ref = ref,
        super(
          TonetagProviderState(
            data: getRandomDigits.toString(),
            player: TonetagPlayer.ultrasonic10Byte,
            channel: TonetagChannel.channelA,
            volume: 100,
            amountController: TextEditingController(),
          ),
        ) {
    startListeningToReceiveRequests();
    onDataReceived();
  }

  final Ref _ref;
  final _tonetag = Tonetag();

  static int get getRandomDigits {
    final rand = Random();
    return rand.nextInt(8999999) + 10000000;
  }

  int get getRandomTxnId {
    final rand = Random();
    return rand.nextInt(899999999) + 1000000000;
  }

  void startReceiveRequest() {
    setPaymentState(TonetagPaymentState.receiving);
    _tonetag
      ..stopSendingData()
      ..startSendingData(
        data: state.data.toReceiveRequest,
        player: state.player,
        channel: state.channel,
        volume: state.volume,
      );
  }

  void stopReceiveRequest() {
    setPaymentState(TonetagPaymentState.paying);
    _tonetag.stopSendingData();
  }

  void startListeningToReceiveRequests() {
    _tonetag.startReceivingData();
  }

  void stopListeningToReceiveRequests() {
    _tonetag.stopReceivingData();
  }

  void onDataReceived() {
    _ref.listen(
      providerOfReceivedDataStream,
      (final prevStream, final newStream) {
        newStream.maybeWhen(
          data: (receivedRequests) {
            final data = receivedRequests['data'];
            if (data is String) {
              handleReceivedData(data);
            }
          },
          orElse: () {},
        );
      },
    );
  }

  void handleReceivedData(final String data) {
    final originalData = data.toOriginal;

    if (data.startsWith(ksCodeP2P)) {
      if (!state.receivedRequests.contains(originalData) &&
          state.data != originalData) {
        setReceivedData(originalData);
        acknowledgeReceiveRequest(originalData);
      }
    } else if (data.startsWith(ksCodeP2PAcknowledge)) {
      final reversed = originalData.split('').reversed.join();
      if (reversed.contains(state.data)) {
        stopReceiveRequest();
      }
    } else if (data.startsWith(ksCodeP2PTransactionSuccess)) {
      showTransactionSuccessDialogToReceiver(originalData);
    }
  }

  void acknowledgeReceiveRequest(final String data) {
    final reversedData = data.split('').reversed.join();
    setPaymentState(TonetagPaymentState.acknowledging);

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setPaymentState(TonetagPaymentState.paying);
        _tonetag
          ..stopSendingData()
          ..startSendingData(
            data: reversedData.toAcknowledge,
            player: state.player,
            channel: TonetagChannel.channelC,
            volume: state.volume,
          );

        Future.delayed(const Duration(milliseconds: 2000), () {
          if (mounted) {
            _tonetag.stopSendingData();
          }
        });
      }
    });
  }

  void sendAmount(final String receiverId) {
    if (state.amountController.text.trim().isEmpty) return;
    final transactionSuccess = TransactionSuccess(
      txnId: getRandomTxnId.toString(),
      amount: state.amountController.text.trim(),
    );
    state = state.copyWith(
      amountController: state.amountController..text = '',
    );

    _tonetag
      ..stopSendingData()
      ..startSendingData(
        data: transactionSuccess.txnId.toTxnId(receiverId),
        player: state.player,
        channel: TonetagChannel.channelB,
        volume: state.volume,
      );

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        _tonetag.stopSendingData();
      }
    });

    setTransactionSuccesses(transactionSuccess);
    removeFromReceivedData(receiverId);

    Get.dialog(
      TransactionDiaglog.transactionSuccess(
        transactionSuccess: transactionSuccess,
      ),
    );
  }

  void showTransactionSuccessDialogToReceiver(final String data) {
    final txnIds = state.transactionSuccesses.map((e) => e.txnId).toList();

    var ignoreId = false;
    for (final id in txnIds) {
      if (data.endsWith(id)) {
        ignoreId = true;
        break;
      }
    }

    if (data.startsWith(state.data) && !ignoreId) {
      final transactionSuccess = TransactionSuccess(
        txnId: data.replaceAll(state.data, ''),
        amount: '123',
      );
      stopReceiveRequest();
      setTransactionSuccesses(transactionSuccess);
      Get.dialog(
        TransactionDiaglog.transactionSuccess(
          transactionSuccess: transactionSuccess,
        ),
      );
    }
  }

  void clearReceivedData() {
    state = state.copyWith(receivedRequests: []);
  }

  void setData(final String newVal) => state = state.copyWith(data: newVal);

  void setReceivedData(final String newVal) => state = state.copyWith(
        receivedRequests: [...state.receivedRequests, newVal],
      );

  void removeFromReceivedData(final String newVal) => state = state.copyWith(
        receivedRequests: state.receivedRequests
            .where((element) => element != newVal)
            .toList(),
      );

  void setPaymentState(final TonetagPaymentState newVal) =>
      state = state.copyWith(
        paymentState: newVal,
      );

  void setTransactionSuccesses(final TransactionSuccess newVal) =>
      state = state.copyWith(
        transactionSuccesses: [...state.transactionSuccesses, newVal],
      );
}
