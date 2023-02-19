import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tonetag/enums/tonetag_channel_type.dart';
import 'package:tonetag/enums/tonetag_player_type.dart';
import 'package:tonetag_example/enums/tonetag_payment_state.dart';

part 'tonetag_provider_state.freezed.dart';

@freezed
class TonetagProviderState with _$TonetagProviderState {
  const factory TonetagProviderState({
    required final String data,
    required final TonetagPlayer player,
    required final TonetagChannel channel,
    required final int volume,
    @Default(<String>[]) final List<String> receivedData,
    @Default(TonetagPaymentState.paying) final TonetagPaymentState paymentState,
  }) = _TonetagProviderState;
}
