import 'package:flutter/material.dart';
import 'package:flutter_ble/core/di/di.dart';
import 'package:flutter_ble/presentation/presentation.dart';

import 'core/core.dart';

void main() {
  BluetoothManager.init();

  configureDependencies();

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
