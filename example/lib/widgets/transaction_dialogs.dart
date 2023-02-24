import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tonetag_example/models/transaction_success_model.dart';

enum _Type {
  sendAmount,
  transactionSuccess,
}

class TransactionDiaglog extends HookConsumerWidget {
  final TextEditingController? controller;
  final Function()? onPressedDone;
  final TransactionSuccess transactionSuccess;

  final _Type _type;

  const TransactionDiaglog.sendAmount({
    super.key,
    required this.controller,
    this.onPressedDone,
  })  : _type = _Type.sendAmount,
        transactionSuccess = const TransactionSuccess(
          txnId: '',
          amount: '',
          receiverId: '',
        );

  const TransactionDiaglog.transactionSuccess({
    super.key,
    required this.transactionSuccess,
  })  : _type = _Type.transactionSuccess,
        onPressedDone = null,
        controller = null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (_type) {
      case _Type.sendAmount:
        return _sendAmountBuilder(context);
      case _Type.transactionSuccess:
        return _transactionSuccessBuilder(context);
      default:
    }
    return Container();
  }

  Widget _sendAmountBuilder(final BuildContext context) {
    return AlertDialog(
      title: const Text('Send Amount'),
      content: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Amount',
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            onPressedDone?.call();
          },
          icon: const Icon(
            Icons.done_rounded,
          ),
          color: Colors.green,
        )
      ],
    );
  }

  Widget _transactionSuccessBuilder(final BuildContext context) {
    return AlertDialog(
      title: const Text('Transaction Success'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Your transaction was made successfully!',
          ),
          const SizedBox(
            height: 40.0,
          ),
          Text(
            'TXN ID: ${transactionSuccess.txnId}',
            style: const TextStyle(
              fontSize: 12.0,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            'RECEIVER: ${transactionSuccess.receiverId}',
            style: const TextStyle(
              fontSize: 12.0,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            'AMOUNT: ${transactionSuccess.amount}',
            style: const TextStyle(
              fontSize: 12.0,
            ),
          )
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
            onPressedDone?.call();
          },
          icon: const Icon(
            Icons.done_rounded,
          ),
          color: Colors.green,
        )
      ],
    );
  }
}
