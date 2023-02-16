import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tonetag/enums/tonetag_player_type.dart';

import 'package:tonetag/tonetag.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final permissionResult = await Permission.microphone.request();
  if (permissionResult.isGranted) {
    await Tonetag.initializeTonetag();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Plugin Example',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin Example App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              minWidth: 200.0,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ReceiverScreen(),
                  ),
                );
              },
              color: Colors.blue,
              textColor: Colors.white,
              child: const Text('Receive Data'),
            ),
            MaterialButton(
              minWidth: 200.0,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SenderScreen(),
                  ),
                );
              },
              color: Colors.blue,
              textColor: Colors.white,
              child: const Text('Send Data'),
            ),
          ],
        ),
      ),
    );
  }
}

class ReceiverScreen extends StatefulWidget {
  const ReceiverScreen({super.key});

  @override
  State<ReceiverScreen> createState() => _ReceiverScreenState();
}

class _ReceiverScreenState extends State<ReceiverScreen> {
  final _tonetagPlugin = Tonetag();

  late Stream<bool> _isReceivingDataStream;
  late Stream<Map<String, dynamic>> _receivedDataStream;

  @override
  void initState() {
    super.initState();
    _isReceivingDataStream = _tonetagPlugin.isReceivingData;
    _receivedDataStream = _tonetagPlugin.onDataReceived;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receiver Screen'),
      ),
      body: Center(
        child: _receivedDataBuilder(),
      ),
      floatingActionButton: _receiveDataBtnBuilder(),
    );
  }

  Widget _receivedDataBuilder() {
    return StreamBuilder<bool>(
      stream: _isReceivingDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final isReceivingData = snapshot.data ?? false;

          return !isReceivingData
              ? const Text(
                  'Press the play icon on the bottom\nright corner to start receiving data',
                  textAlign: TextAlign.center,
                )
              : _showReceivedDataBuilder();
        }
        return const SizedBox();
      },
    );
  }

  Widget _showReceivedDataBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Received data:'),
        const SizedBox(
          width: 10.0,
        ),
        StreamBuilder<Map<String, dynamic>?>(
          stream: _receivedDataStream,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.0,
                  ),
                ),
              );
            } else if (snap.hasData) {
              final data = snap.data ?? <String, dynamic>{};
              if (data['data'] != null) {
                return Text(data['data']);
              }
            } else if (snap.hasError) {
              return Text(snap.error.toString());
            }

            return const Text('NONE');
          },
        ),
      ],
    );
  }

  Widget _receiveDataBtnBuilder() {
    return StreamBuilder<bool>(
      stream: _isReceivingDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final isReceivingData = snapshot.data ?? false;

          return FloatingActionButton(
            child: Icon(
              isReceivingData ? Icons.stop_rounded : Icons.play_arrow_rounded,
            ),
            onPressed: () {
              if (isReceivingData) {
                _tonetagPlugin.stopReceivingData();
              } else {
                _tonetagPlugin.startReceivingData();
              }
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}

class SenderScreen extends StatefulWidget {
  const SenderScreen({super.key});

  @override
  State<SenderScreen> createState() => _SenderScreenState();
}

class _SenderScreenState extends State<SenderScreen> {
  final _tonetagPlugin = Tonetag();
  final _dataController = TextEditingController();
  final _volumeController = TextEditingController();

  var _player = TonetagPlayer.sonic30Byte;

  late Stream<bool> _isSendingDataStream;

  @override
  void initState() {
    super.initState();
    _dataController.text = '12345';
    _volumeController.text = '50';

    _isSendingDataStream = _tonetagPlugin.isSendingData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sender Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _inputsBuilder(),
            const SizedBox(
              height: 30.0,
            ),
            _playerSelectorBuilder(),
          ],
        ),
      ),
      floatingActionButton: _sendDataBtnBuilder(),
    );
  }

  Widget _inputsBuilder() {
    return Column(
      children: [
        TextFormField(
          controller: _dataController,
          decoration: const InputDecoration(
            labelText: 'Data to send',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        TextFormField(
          controller: _volumeController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Volume',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _playerSelectorBuilder() {
    return Row(
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
                  });
                },
              ),
              PopupMenuItem(
                child: Text(
                  ksTonetagPlayerName[TonetagPlayer.ultrasonic10Byte]!,
                ),
                onTap: () {
                  setState(() {
                    _player = TonetagPlayer.ultrasonic10Byte;
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
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sendDataBtnBuilder() {
    return StreamBuilder<bool>(
      stream: _isSendingDataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final isSendingData = snapshot.data ?? false;

          return FloatingActionButton(
            child: Icon(
              isSendingData ? Icons.close_rounded : Icons.music_note_rounded,
            ),
            onPressed: () {
              if (isSendingData) {
                _tonetagPlugin.stopSendingData();
              } else {
                _tonetagPlugin.startSendingData(
                  data: _dataController.text.trim(),
                  player: _player,
                  volume: int.tryParse(_volumeController.text),
                );
              }
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
