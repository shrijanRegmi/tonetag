import 'enums/tonetag_channel_type.dart';
import 'enums/tonetag_player_type.dart';
import 'tonetag_platform_interface.dart';

export 'enums/tonetag_channel_type.dart';
export 'enums/tonetag_player_type.dart';

class Tonetag {
  static Future<void> initialize() {
    return TonetagPlatform.instance.initializeTonetag();
  }

  Future<void> startSendingData({
    required final String data,
    required final TonetagPlayer player,
    required final TonetagChannel channel,
    final int? volume = 80,
  }) {
    return TonetagPlatform.instance.startSendingData(
      data: data,
      player: player,
      channel: channel,
      volume: volume,
    );
  }

  Future<void> stopSendingData() {
    return TonetagPlatform.instance.stopSendingData();
  }

  Future<void> startReceivingData() {
    return TonetagPlatform.instance.startReceivingData();
  }

  Future<void> stopReceivingData() {
    return TonetagPlatform.instance.stopReceivingData();
  }

  Stream<bool> get isSendingData => TonetagPlatform.instance.isSendingData;

  Stream<bool> get isReceivingData => TonetagPlatform.instance.isReceivingData;

  Stream<Map<String, dynamic>> get onDataReceived =>
      TonetagPlatform.instance.onDataReceived;
}
