import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tonetag/tonetag.dart';
import 'package:tonetag_example/enums/tonetag_payment_state.dart';
import 'package:tonetag_example/utils/string_contants.dart';

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
            data: '$ksCodeP2P$getRandomDigits',
            player: TonetagPlayer.ultrasonic10Byte,
            channel: TonetagChannel.channelA,
            volume: 100,
          ),
        ) {
    startListeningToReceiveRequests();
    onDataReceived();
  }

  final Ref _ref;
  final _tonetag = Tonetag();

  static int get getRandomDigits {
    final rand = Random();
    return rand.nextInt(8999) + 1000;
  }

  void startReceiveRequest() {
    setPaymentState(TonetagPaymentState.receiving);
    _tonetag
      ..stopSendingData()
      ..startSendingData(
        data: state.data,
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
          data: (receivedData) {
            final data = receivedData['data'];
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
    if (data.startsWith(ksCodeP2P)) {
      if (!state.receivedData.contains(data) && state.data != data) {
        setReceivedData(data);
        acknowledgeReceiveRequest(data);
      }
    } else if (data.startsWith(ksCodeP2PAcknowledge)) {
      final reversed = data.split('').reversed.join();
      if (reversed.contains(state.data)) {
        stopReceiveRequest();
      }
    }
  }

  void acknowledgeReceiveRequest(final String data) {
    final reversedData = data.split('').reversed.join();
    setPaymentState(TonetagPaymentState.acknowledging);

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setPaymentState(TonetagPaymentState.paying);
        _tonetag
          ..stopSendingData()
          ..startSendingData(
            data: '$ksCodeP2PAcknowledge$reversedData',
            player: state.player,
            channel: TonetagChannel.channelC,
            volume: state.volume,
          );
      }
    });
  }

  void clearReceivedData() {
    state = state.copyWith(receivedData: []);
  }

  void setData(final String newVal) => state = state.copyWith(data: newVal);

  void setReceivedData(final String newVal) => state = state.copyWith(
        receivedData: [...state.receivedData, newVal],
      );

  void setPaymentState(final TonetagPaymentState newVal) =>
      state = state.copyWith(
        paymentState: newVal,
      );
}
