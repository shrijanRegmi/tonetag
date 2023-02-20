import 'package:tonetag_example/utils/string_contants.dart';

extension DataToSendExt on String {
  String get toReceiveRequest => '$ksCodeP2P$this';
  String get toAcknowledge => '$ksCodeP2PAcknowledge$this';
  String toTxnId(final String receiverId) =>
      '$ksCodeP2PTransactionSuccess$receiverId$this';

  String get toOriginal {
    var str = this;
    if (startsWith(ksCodeP2P)) {
      str = str.replaceFirst(ksCodeP2P, '');
    }
    if (startsWith(ksCodeP2PAcknowledge)) {
      str = str.replaceAll(ksCodeP2PAcknowledge, '');
    }
    if (startsWith(ksCodeP2PTransactionSuccess)) {
      str = str.replaceAll(ksCodeP2PTransactionSuccess, '');
    }
    if (startsWith(ksCodeP2PTransactionFailed)) {
      str = str.replaceAll(ksCodeP2PTransactionFailed, '');
    }
    return str;
  }
}
