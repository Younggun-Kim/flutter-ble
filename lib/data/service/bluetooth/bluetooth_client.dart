import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:injectable/injectable.dart';

abstract interface class BluetoothClient {
  Stream<bool> hasPermission();
}

@LazySingleton(as: BluetoothClient)
class BluetoothClientImpl implements BluetoothClient {
  @override
  Stream<bool> hasPermission() {
    return FlutterBluePlus.adapterState.map(
      (BluetoothAdapterState state) => state == BluetoothAdapterState.on,
    );
  }
}
