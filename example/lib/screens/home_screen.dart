import 'package:flutter/material.dart';

import 'pay_or_receive_screen.dart';

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
        child: MaterialButton(
          minWidth: 200.0,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PayOrReceiveScreen(),
              ),
            );
          },
          color: Colors.blue,
          textColor: Colors.white,
          child: const Text('Start'),
        ),
      ),
    );
  }
}
