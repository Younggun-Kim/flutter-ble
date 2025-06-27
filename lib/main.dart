import 'package:flutter/material.dart';
import 'package:flutter_ble/ui/ui.dart';

import 'bluetooth/bluetooth_manager.dart';

void main() {
  BluetoothManager.init();

  runApp(
    MaterialApp(
      title: '블루투스 데모',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SafeArea(child: BluetoothHomeScreen()),
    ),
  );
}
