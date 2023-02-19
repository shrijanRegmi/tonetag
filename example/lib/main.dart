import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tonetag/tonetag.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final permissionResult = await Permission.microphone.request();
  if (permissionResult.isGranted) {
    await Tonetag.initialize();
  }
  runApp(const TonetagExampleApp());
}
