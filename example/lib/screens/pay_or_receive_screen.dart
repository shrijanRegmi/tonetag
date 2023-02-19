import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _toneTag = Tonetag();

  final _dataToSendController = TextEditingController(text: '012345');
  var _player = TonetagPlayer.ultrasonic10Byte;
  var _channel = TonetagChannel.channelA;
  late final Stream<bool> _isSendingWaveForReceiving;
  final _receivedDatas = <String>[];

  void _startSendingData() async {
    try {
      final dataToSend = _dataToSendController.text;
      _toneTag.startSendingData(
        data: '$ksCodeP2P$dataToSend',
        player: _player,
        channel: _channel,
        volume: _player == TonetagPlayer.ultrasonic10Byte ? 100 : 50,
      );
    } on PlatformException catch (e) {
      showSnackbar(message: '${e.message}');
    }
  }

  void _stopSendingData() {
    _toneTag.stopSendingData();
  }

  void _startReceivingData() {
    _toneTag.startReceivingData();
  }

  void _stopReceivingData() {
    _toneTag.stopReceivingData();
  }

  void _onDataReceive() {
    _toneTag.onDataReceived.listen((event) {
      final data = event['data'];
      if (data != null && data is String) {
        if (!_receivedDatas.contains(data)) {
          setState(() {
            _receivedDatas.add(data);
          });
        }
      }
    });
  }

  void _showChangeDataBottomsheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.done_rounded,
                  ),
                  splashRadius: 20.0,
                  color: Colors.green,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: _dataToSendController,
                  keyboardType: _player == TonetagPlayer.ultrasonic10Byte
                      ? TextInputType.text
                      : TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Data',
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: PopupMenuButton(
                        icon: Text(ksTonetagPlayerName[_player]!),
                        itemBuilder: (context) => <PopupMenuEntry>[
                          PopupMenuItem(
                            child: Text(
                              ksTonetagPlayerName[TonetagPlayer.sonic30Byte]!,
                            ),
                            onTap: () {
                              setState(() {
                                _player = TonetagPlayer.sonic30Byte;
                                _dataToSendController.clear();
                              });
                            },
                          ),
                          PopupMenuItem(
                            child: Text(
                              ksTonetagPlayerName[
                                  TonetagPlayer.ultrasonic10Byte]!,
                            ),
                            onTap: () {
                              setState(() {
                                _player = TonetagPlayer.ultrasonic10Byte;
                                _dataToSendController.clear();
                              });
                            },
                          ),
                          PopupMenuItem(
                            child: Text(
                              ksTonetagPlayerName[TonetagPlayer.ivr14Byte]!,
                            ),
                            onTap: () {
                              setState(() {
                                _player = TonetagPlayer.ivr14Byte;
                                _dataToSendController.clear();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: PopupMenuButton(
                        icon: Text(ksTonetagChannelName[_channel]!),
                        itemBuilder: (context) => <PopupMenuEntry>[
                          PopupMenuItem(
                            child: Text(
                              ksTonetagChannelName[TonetagChannel.channelA]!,
                            ),
                            onTap: () {
                              setState(() {
                                _channel = TonetagChannel.channelA;
                              });
                            },
                          ),
                          PopupMenuItem(
                            child: Text(
                              ksTonetagChannelName[TonetagChannel.channelB]!,
                            ),
                            onTap: () {
                              setState(() {
                                _channel = TonetagChannel.channelB;
                              });
                            },
                          ),
                          PopupMenuItem(
                            child: Text(
                              ksTonetagChannelName[TonetagChannel.channelC]!,
                            ),
                            onTap: () {
                              setState(() {
                                _channel = TonetagChannel.channelC;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ).pX(20.0).pY(20.0);
          },
        );
      },
    );
  }

  void showSnackbar({
    required final String message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();
    _isSendingWaveForReceiving = _toneTag.isSendingData;
    _startReceivingData();
    _onDataReceive();
  }

  @override
  void dispose() {
    _stopSendingData();
    _stopReceivingData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send or Receive Screen'),
        actions: [
          IconButton(
            splashRadius: 20.0,
            onPressed: _showChangeDataBottomsheet,
            icon: const Icon(
              Icons.more_vert_rounded,
            ),
          ),
        ],
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
                      text: isSending ? 'Cancel' : 'Send',
                      animate: isSending,
                      onPressed: (isAnimating) {
                        if (isSending) {
                          _stopSendingData();
                        } else {
                          _startSendingData();
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
                  opacity: _receivedDatas.isEmpty ? 0.0 : 1.0,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _receivedDatas.clear();
                      });
                    },
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
              child: _receivedDatas.isEmpty
                  ? const Center(
                      child: Text(
                        'This section will automatically listen to\nreceived datas from other devices.\n\n',
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
