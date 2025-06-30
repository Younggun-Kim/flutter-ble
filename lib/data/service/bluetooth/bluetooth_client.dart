import 'dart:async';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:injectable/injectable.dart';

import '../../../utils/logger.dart';

abstract interface class BluetoothClient {
  Stream<bool> hasPermission();

  /// Android에서 블루투스 켜기 요청
  ///
  /// 기기의 블루투스가 꺼져 있는 경우,
  /// 사용자에게 블루투스를 켜도록 요청합니다.
  /// (iOS에서는 동작하지 않음)
  Future<void> turnOn();
}

@LazySingleton(as: BluetoothClient)
class BluetoothClientImpl implements BluetoothClient {
  @override
  Stream<bool> hasPermission() {
    logger.i(FlutterBluePlus.adapterStateNow);
    return FlutterBluePlus.adapterState.map(
      (BluetoothAdapterState state) => state == BluetoothAdapterState.on,
    );
  }

  @override
  Future<void> turnOn() async {
    if (!Platform.isAndroid) return;

    return await FlutterBluePlus.turnOn();
  }
}
