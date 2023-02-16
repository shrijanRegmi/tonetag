import 'enums/tonetag_player_type.dart';
import 'tonetag_platform_interface.dart';

class Tonetag {
  Future<String?> getPlatformVersion() {
    return TonetagPlatform.instance.getPlatformVersion();
  }

  static Future<void> initializeTonetag() {
    return TonetagPlatform.instance.initializeTonetag();
  }

  Future<void> startSendingData({
    required final String data,
    required final TonetagPlayer player,
    final int? volume = 80,
  }) {
    return TonetagPlatform.instance.startSendingData(
      data: data,
      player: player,
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
