import 'dart:async';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:injectable/injectable.dart';

abstract interface class BluetoothClient {
  Stream<bool> hasPermission();

  /// Android에서 블루투스 켜기 요청(기기의 블루투스를 키기)
  /// only Android
  Future<void> turnOn();

  Stream<List<ScanResult>> startScan();

  Future<void> stopScan();

  /// 연결 요청
  Future<void> connect({
    required BluetoothDevice device,
    int? mtu,
  });

  /// 자동 연결
  Future<void> autoConnect({required BluetoothDevice device});

  /// 연결 해제
  Future<void> disconnected({
    required BluetoothDevice device,
  });

  /// 연결 상태
  Stream<bool> isConnected({required BluetoothDevice device});

  /// 등록된 서비스 조회 : 연결 후 필수 호출하기
  Future<List<BluetoothService>> discoverServices({
    required BluetoothDevice device,
  });
}

@LazySingleton(as: BluetoothClient)
class BluetoothClientImpl implements BluetoothClient {
  @override
  Stream<bool> hasPermission() {
    return FlutterBluePlus.adapterState.map(
      (BluetoothAdapterState state) => state == BluetoothAdapterState.on,
    );
  }

  @override
  Future<void> turnOn() async {
    if (!Platform.isAndroid) return;

    return await FlutterBluePlus.turnOn();
  }

  @override
  Stream<List<ScanResult>> startScan() {
    final stream = FlutterBluePlus.onScanResults;

    FlutterBluePlus.startScan(
      withNames: ['Glucose002'],
      timeout: Duration(seconds: 10),
    );

    return stream;
  }

  @override
  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  @override
  Future<void> connect({
    required BluetoothDevice device,
    int? mtu = 512,
  }) async {
    await device.connect(
      mtu: mtu,
    );
  }

  @override
  Future<void> autoConnect({required BluetoothDevice device}) async {
    await device.connect(autoConnect: true, mtu: null);
  }

  @override
  Future<void> disconnected({required BluetoothDevice device}) async {
    await device.disconnect();
  }

  /// 연결 상태
  @override
  Stream<bool> isConnected({required BluetoothDevice device}) {
    return device.connectionState.map<bool>(
      (BluetoothConnectionState state) =>
          state == BluetoothConnectionState.connected,
    );
  }

  /// 등록된 서비스 조회 : 연결 후 필수 호출하기
  @override
  Future<List<BluetoothService>> discoverServices({
    required BluetoothDevice device,
  }) async {
    return await device.discoverServices();
  }
}
