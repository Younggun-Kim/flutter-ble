import 'dart:async';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../utils/logger.dart';

class BluetoothManager {
  static StreamSubscription? scanSubscription;

  static void init() {
    FlutterBluePlus.setLogLevel(LogLevel.info, color: true);
  }

  static void turnOn() async {
    final bool isSupported = await FlutterBluePlus.isSupported;

    if (!isSupported) {
      logger.e('기기가 블루투스를 지원하지 않습니다.');
      return;
    }

    FlutterBluePlus.adapterState.listen((
      BluetoothAdapterState state,
    ) {
      logger.i(state);
      if (state == BluetoothAdapterState.on) {}
    });

    if (Platform.isAndroid) {
      FlutterBluePlus.turnOn();
    }
  }

  static void scan() async {
    await FlutterBluePlus.startScan(
      timeout: const Duration(
        seconds: 10,
      ),
    );
  }

  static void connect() async {}
}
