import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tonetag_example/enums/tonetag_payment_state.dart';
import 'package:tonetag_example/extensions/widget_extension.dart';
import 'package:tonetag_example/providers/tonetag_provider.dart';
import 'package:tonetag_example/widgets/rounded_wave_button.dart';

class PayOrReceiveScreen extends StatefulHookConsumerWidget {
  const PayOrReceiveScreen({super.key});

  @override
  ConsumerState<PayOrReceiveScreen> createState() => _PayOrReceiveScreenState();
}

class _PayOrReceiveScreenState extends ConsumerState<PayOrReceiveScreen> {
  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(providerOfTonetag.notifier);
    final state = ref.watch(providerOfTonetag);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay or Receive Screen'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(state.data).pad(5.0),
            Expanded(
              child: RoundedWaveButton(
                size: 150.0,
                text: state.paymentState == TonetagPaymentState.receiving
                    ? 'Receive'
                    : 'Pay',
                animate: true,
                bgColor: state.paymentState == TonetagPaymentState.receiving
                    ? Colors.blue
                    : Colors.green,
                onPressed: (_) {
                  if (state.paymentState == TonetagPaymentState.receiving) {
                    notifier.stopReceiveRequest();
                  } else {
                    notifier.startReceiveRequest();
                  }
                },
              ),
            ),
            const Divider(),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Received Datas',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Opacity(
                  opacity: state.receivedData.isEmpty ? 0.0 : 1.0,
                  child: IconButton(
                    onPressed: notifier.clearReceivedData,
                    splashRadius: 24.0,
                    color: Colors.red,
                    icon: const Icon(
                      Icons.delete_rounded,
                    ),
                  ),
                ),
              ],
            ).pL(20.0).pR(10.0),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: state.receivedData.isEmpty
                  ? const Center(
                      child: Text(
                        'This section will automatically listen to\nreceived datas from other devices.\n\n',
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: state.receivedData.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final data = state.receivedData[index];
                        return ListTile(
                          leading: const Icon(
                            Icons.data_thresholding_outlined,
                          ),
                          title: Text(data),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
