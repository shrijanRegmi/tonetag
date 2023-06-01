import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tonetag/tonetag.dart';

import 'pay_or_receive_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isInitializing = false;

  @override
  void initState() {
    initializeTonetag();
    super.initState();
  }

  void initializeTonetag() async {
    setState(() {
      isInitializing = true;
    });
    final permissionResult = await Permission.microphone.request();
    if (permissionResult.isGranted) {
      await Tonetag.initialize();
    }
    setState(() {
      isInitializing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin Example App'),
      ),
      body: Center(
        child: MaterialButton(
          minWidth: 200.0,
          onPressed: () {
            if (isInitializing) return;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PayOrReceiveScreen(),
              ),
            );
          },
          color: Colors.blue,
          textColor: Colors.white,
          child: isInitializing
              ? const SizedBox(
                  width: 25.0,
                  height: 25.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.0,
                  ),
                )
              : const Text('Start'),
        ),
      ),
    );
  }
}
