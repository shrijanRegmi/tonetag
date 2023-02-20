import 'package:tonetag_example/utils/string_contants.dart';

extension DataToSendExt on String {
  String get toReceiveRequest => '$ksCodeP2P$this';
  String get toAcknowledge => '$ksCodeP2PAcknowledge$this';
  String toTxnId(final String receiverId) =>
      '$ksCodeP2PTransactionSuccess$receiverId$this';

  String get toOriginal {
    var str = this;
    if (str.length <= 2) return str;

    if (startsWith(ksCodeP2P)) {
      str = str.substring(2);
    }
    if (startsWith(ksCodeP2PAcknowledge)) {
      str = str.substring(2);
    }
    if (startsWith(ksCodeP2PTransactionSuccess)) {
      str = str.substring(2);
    }
    if (startsWith(ksCodeP2PTransactionFailed)) {
      str = str.substring(2);
    }
    return str;
  }
}
