import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tonetag/enums/tonetag_player_type.dart';

import 'tonetag_platform_interface.dart';

/// An implementation of [TonetagPlatform] that uses method channels.
class MethodChannelTonetag extends TonetagPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('tonetag');

  @visibleForTesting
  final onDataReceivedEventChannel = const EventChannel(
    'tonetag_event_channel/onDataReceived',
  );

  @visibleForTesting
  final isSendingEventChannel = const EventChannel(
    'tonetag_event_channel/isSendingData',
  );

  @visibleForTesting
  final isReceivingEventChannel = const EventChannel(
    'tonetag_event_channel/isReceivingData',
  );

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<void> initializeTonetag() {
    return methodChannel.invokeMethod('initializeTonetag');
  }

  @override
  Future<void> startSendingData({
    required String data,
    required TonetagPlayer player,
    int? volume = 50,
  }) {
    final dataToSend = <String, dynamic>{
      'data': data,
      'player': ksTonetagPlayerName[player],
      'volume': volume,
    };

    return methodChannel.invokeMethod<bool>(
      'startSendingData',
      dataToSend,
    );
  }

  @override
  Future<void> stopSendingData() {
    return methodChannel.invokeMethod('stopSendingData');
  }

  @override
  Future<void> startReceivingData() {
    return methodChannel.invokeMethod('startReceivingData');
  }

  @override
  Future<void> stopReceivingData() {
    return methodChannel.invokeMethod<bool>('stopReceivingData');
  }

  @override
  Stream<bool> get isReceivingData =>
      isReceivingEventChannel.receiveBroadcastStream().cast<bool>();

  @override
  Stream<bool> get isSendingData =>
      isSendingEventChannel.receiveBroadcastStream().cast<bool>();

  @override
  Stream<Map<String, dynamic>> get onDataReceived =>
      onDataReceivedEventChannel.receiveBroadcastStream().map(
            (event) => Map<String, dynamic>.from(event),
          );
}
