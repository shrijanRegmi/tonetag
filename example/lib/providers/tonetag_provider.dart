import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tonetag/tonetag.dart';
import 'package:tonetag_example/enums/tonetag_connection_state.dart';
import 'package:tonetag_example/enums/transfered_data_type.dart';
import 'package:tonetag_example/extensions/data_to_send_extension.dart';
import 'package:tonetag_example/models/transaction_success_model.dart';
import 'package:tonetag_example/utils/contants.dart';
import 'package:tonetag_example/widgets/transaction_dialogs.dart';

import 'states/tonetag_provider_state.dart';

final providerOfTonetag =
    StateNotifierProvider.autoDispose<TonetagProvider, TonetagProviderState>(
  (ref) {
    final prov = TonetagProvider(ref);
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
            channel: TonetagChannel.values[Random().nextInt(1) + 1],
            volume: 100,
            amountController: TextEditingController(),
          ),
        ) {
    startListeningToReceiveRequests();
    onDataReceived();
  }

  @override
  void dispose() {
    stopReceiveRequest();
    stopListeningToReceiveRequests();
    super.dispose();
  }

  final Ref _ref;
  final _tonetag = Tonetag();

  static int get getRandomDigits {
    final rand = Random();
    return rand.nextInt(899999999) + 1000000000;
  }

  int get getRandomTxnId {
    final rand = Random();
    return rand.nextInt(899999999) + 1000000000;
  }

  void startReceiveRequest() {
    setSentDataType(TransferedDataType.receiveRequest);
    setConnectionState(TonetagConnectionState.busy);
    _tonetag
      ..stopSendingData()
      ..startSendingData(
        data: state.data,
        player: state.player,
        channel: state.channel,
        volume: state.volume,
      );

    Future.delayed(
      const Duration(seconds: kiDurationReceiveRequestWave),
      () {
        if (mounted &&
            state.sentDataType == TransferedDataType.receiveRequest) {
          stopReceiveRequest();
        }
      },
    );
  }

  void stopReceiveRequest() {
    setSentDataType(TransferedDataType.unknown);
    setConnectionState(TonetagConnectionState.idle);
    _tonetag.stopSendingData();
  }

  void startListeningToReceiveRequests() {
    _tonetag.startReceivingData();
  }

  void stopListeningToReceiveRequests() {
    _tonetag.stopReceivingData();
  }

  // <--- main data handling part lies here ---> //
  void onDataReceived() {
    _ref.listen(
      providerOfReceivedDataStream,
      (final prevStream, final newStream) {
        newStream.maybeWhen(
          data: (receivedRequests) {
            final data = receivedRequests['data'];
            if (data is String) {
              handleReceivedData(getReceivedDataType(data), data);
            }
          },
          orElse: () {},
        );
      },
    );
  }

  void handleReceivedData(
    final TransferedDataType type,
    final String data,
  ) {
    switch (type) {
      case TransferedDataType.receiveRequest:
        handleReceiveRequestType(data);
        break;
      case TransferedDataType.acknowledge:
        handleAcknowledgmentType(data);
        break;
      case TransferedDataType.transactionSuccess:
        handleTransactionSuccessType(data);
        break;
      default:
    }
  }

  void handleReceiveRequestType(final String data) {
    if (!state.receivedRequests.contains(data) && state.data != data) {
      setReceivedData(data);
      if (state.data != data) {
        acknowledgeReceiveRequest(data);
      }
    } else {
      setReceiveRequestsCounter(data);
      final thisDataCount = state.receiveRequestsCounter[data] ?? 0;

      if (thisDataCount > 5) {
        if (state.data != data) {
          acknowledgeReceiveRequest(data);
        } else {
          stopReceiveRequest();
        }
      }
    }
  }

  void handleAcknowledgmentType(final String data) {
    stopReceiveRequest();
  }

  void handleTransactionSuccessType(final String data) {
    showTransactionSuccessDialogToReceiver(data);
  }

  void handleUnknownDataType(final String data) {}

  void acknowledgeReceiveRequest(final String data) {
    resetReceiveRequestsCounter(data);

    setSentDataType(TransferedDataType.acknowledge);
    setConnectionState(TonetagConnectionState.busy);
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _tonetag
          ..stopSendingData()
          ..startSendingData(
            data: data.substring(1).toReverse,
            player: state.player,
            channel: TonetagChannel.channelA,
            volume: state.volume,
          );

        Future.delayed(
          const Duration(seconds: kiDurationAcknowlegmentWave),
          () {
            if (mounted &&
                state.sentDataType == TransferedDataType.acknowledge) {
              setSentDataType(TransferedDataType.unknown);
              setConnectionState(TonetagConnectionState.idle);
              _tonetag.stopSendingData();
            }
          },
        );
      }
    });
  }

  void sendAmount(final String receiverId) {
    if (state.amountController.text.trim().isEmpty) return;

    final transactionSuccess = TransactionSuccess(
      txnId: getRandomTxnId.toString(),
      amount: state.amountController.text.trim(),
      receiverId: receiverId,
    );
    state = state.copyWith(
      amountController: state.amountController..text = '',
    );

    setSentDataType(TransferedDataType.transactionSuccess);
    setConnectionState(TonetagConnectionState.busy);
    _tonetag
      ..stopSendingData()
      ..startSendingData(
        data: transactionSuccess.toDataToSend,
        player: state.player,
        channel: TonetagChannel.channelA,
        volume: state.volume,
      );

    Future.delayed(
      const Duration(seconds: kiDurationTrasactionWave),
      () {
        if (mounted &&
            state.sentDataType == TransferedDataType.transactionSuccess) {
          setSentDataType(TransferedDataType.unknown);
          setConnectionState(TonetagConnectionState.idle);
          _tonetag.stopSendingData();
        }
      },
    );

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
    final transactionSuccess = TransactionSuccess.fromReceivedData(data);

    if (!txnIds.contains(transactionSuccess.txnId) &&
        transactionSuccess.receiverId == state.data) {
      stopReceiveRequest();
      setTransactionSuccesses(transactionSuccess);
      Get.dialog(
        TransactionDiaglog.transactionSuccess(
          transactionSuccess: transactionSuccess,
        ),
      );
    }
  }

  TransferedDataType getReceivedDataType(final String data) {
    var receivedDataType = TransferedDataType.unknown;

    if (data.startsWith(ksCodeP2PTransaction) && data.length > kiLengthUid) {
      receivedDataType = TransferedDataType.transactionSuccess;
    } else if (state.data.substring(1) == data.toReverse) {
      receivedDataType = TransferedDataType.acknowledge;
    } else if (!state.receivedRequests.contains(data.toReverse) &&
        data.length == state.data.length) {
      receivedDataType = TransferedDataType.receiveRequest;
    }

    return receivedDataType;
  }

  void clearReceivedData() => state = state.copyWith(receivedRequests: []);

  void setData(final String newVal) => state = state.copyWith(data: newVal);

  void setReceivedData(final String newVal) => state = state.copyWith(
        receivedRequests: [...state.receivedRequests, newVal],
      );

  void setConnectionState(final TonetagConnectionState newVal) =>
      state = state.copyWith(
        connectionState: newVal,
      );

  void removeFromReceivedData(final String newVal) => state = state.copyWith(
        receivedRequests: state.receivedRequests
            .where((element) => element != newVal)
            .toList(),
      );

  void setSentDataType(final TransferedDataType newVal) =>
      state = state.copyWith(
        sentDataType: newVal,
      );

  void setTransactionSuccesses(final TransactionSuccess newVal) =>
      state = state.copyWith(
        transactionSuccesses: [...state.transactionSuccesses, newVal],
      );

  void setReceiveRequestsCounter(final String receiverId) =>
      state = state.copyWith(
        receiveRequestsCounter:
            Map<String, int>.from(state.receiveRequestsCounter)
              ..addAll({
                receiverId: (state.receiveRequestsCounter[receiverId] ?? 0) + 1,
              }),
      );
  void resetReceiveRequestsCounter(final String receiverId) =>
      state = state.copyWith(
        receiveRequestsCounter:
            Map<String, int>.from(state.receiveRequestsCounter)
              ..addAll({receiverId: 0}),
      );
}
