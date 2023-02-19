// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:tonetag/enums/tonetag_player_type.dart';
import 'package:tonetag/tonetag.dart';
import 'package:tonetag_example/extensions/widget_extension.dart';
import 'package:tonetag_example/utils/string_contants.dart';
import 'package:tonetag_example/widgets/rounded_wave_button.dart';

class PayOrReceiveScreen extends StatefulWidget {
  const PayOrReceiveScreen({super.key});

  @override
  State<PayOrReceiveScreen> createState() => _PayOrReceiveScreenState();
}

class _PayOrReceiveScreenState extends State<PayOrReceiveScreen> {
  final _myNumber = "9808";
  final _toneTag = Tonetag();

  late final Stream<bool> _isSendingWaveForReceiving;
  final _receivedDatas = <String>[
    // '9808950454',
    // '9841080946',
    // '9851065542',
    // '9843059313',
  ];

  // receiver beams to sender to request for receiving amount
  void _startWaveForReceiving() {
    _toneTag.startSendingData(
      data: '$ksCodeP2P$_myNumber',
      player: TonetagPlayer.ultrasonic10Byte,
      volume: 100,
    );
  }

  // stop the beam from receiver to sender to request for receiving amount
  void _stopWaveForReceiving() {
    _toneTag.stopSendingData();
  }

  // sender starts listening to the beams from receiver
  void _startReceivingWaves() {
    _toneTag.startReceivingData();
  }

  // sender stops listening to the beams from receiver
  void _stopReceivingWaves() {
    _toneTag.stopReceivingData();
  }

  // handle received data
  void _onDataReceive() {
    const includeMyNumber = false;

    _toneTag.onDataReceived.listen((event) {
      final data = event['data'];
      if (data != null && data is String) {
        // request to receive amount
        if (data.startsWith(ksCodeP2P)) {
          if (includeMyNumber) {
            if (!_receivedDatas.contains(data)) {
              setState(() {
                _receivedDatas.add(data);
              });
            }
          } else if (!data.contains(_myNumber)) {
            if (!_receivedDatas.contains(data)) {
              setState(() {
                _receivedDatas.add(data);
              });
            }
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _isSendingWaveForReceiving = _toneTag.isSendingData;

    // sender starts listening to the beams from receiver as soon as they land
    // on the screen
    _startReceivingWaves();

    // start listening to the received data as soon as you land on the screen
    _onDataReceive();
  }

  @override
  void dispose() {
    // receiver stops sending beams to sender as soon as they leave the screen
    _stopWaveForReceiving();

    // sender stops listening to the beams from receiver as soon as they leave
    // the screen
    _stopReceivingWaves();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pay or Receive Screen'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder<bool>(
                stream: _isSendingWaveForReceiving,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    final isSending = snapshot.data ?? false;

                    return RoundedWaveButton(
                      size: 150.0,
                      text: isSending ? 'Cancel' : 'Receive',
                      animate: isSending,
                      onPressed: (isAnimating) {
                        if (isSending) {
                          _stopWaveForReceiving();
                        } else {
                          _startWaveForReceiving();
                        }
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
            const Divider(),
            const SizedBox(
              height: 20.0,
            ),
            const Text(
              'Receive Requests',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ).pL(20),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: _receivedDatas.isEmpty
                  ? const Center(
                      child: Text(
                        'This section will automatically listen to\nreceive requests from other devices.\n\n',
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _receivedDatas.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final data = _receivedDatas[index];
                        return ListTile(
                          leading: const Icon(
                            Icons.phone_android_rounded,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
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
