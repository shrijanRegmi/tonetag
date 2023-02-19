import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tonetag/enums/tonetag_channel_type.dart';
import 'package:tonetag/enums/tonetag_player_type.dart';

import 'tonetag_method_channel.dart';

abstract class TonetagPlatform extends PlatformInterface {
  TonetagPlatform() : super(token: _token);

  static final Object _token = Object();

  static TonetagPlatform _instance = MethodChannelTonetag();

  /// The default instance of [TonetagPlatform] to use.
  ///
  /// Defaults to [MethodChannelTonetag].
  static TonetagPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TonetagPlatform] when
  /// they register themselves.
  static set instance(TonetagPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> initializeTonetag();

  Future<void> startSendingData({
    required final String data,
    required final TonetagPlayer player,
    required final TonetagChannel channel,
    final int? volume = 80,
  });

  Future<void> stopSendingData();

  Future<void> startReceivingData();

  Future<void> stopReceivingData();

  Stream<bool> get isSendingData;

  Stream<bool> get isReceivingData;

  Stream<Map<String, dynamic>> get onDataReceived;
}
