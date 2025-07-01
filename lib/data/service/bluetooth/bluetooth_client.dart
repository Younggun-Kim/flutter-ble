import 'dart:async';
import 'dart:io';

import 'package:flutter_ble/utils/logger.dart';
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

  /// Characteristic 메시지 스트림 설정
  Future<Stream<List<int>>?> getCharacteristicLastValue(
    BluetoothCharacteristic characteristic,
  );

  /// Characteristic에 메시지 보내기
  Future<void> writeMessage({
    required BluetoothCharacteristic characteristic,
    required List<int> message,
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
      withNames: ['Glucose'],
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

  /// Characteristic 메시지 스트림 설정
  @override
  Future<Stream<List<int>>?> getCharacteristicLastValue(
    BluetoothCharacteristic characteristic,
  ) async {
    try {
      /// Stream으로 받기 위한 설정 - characteristic이 Notify타입을 지원해야 한다.
      await characteristic.setNotifyValue(true);

      /// 기록된 마지막 값 읽어오기
      await characteristic.read();

      return characteristic.lastValueStream;
    } catch (e) {
      logger.e(e);
      return null;
    }
  }

  /// Characteristic에 메시지 보내기
  @override
  Future<void> writeMessage({
    required BluetoothCharacteristic characteristic,
    required List<int> message,
  }) async {
    await characteristic.write(message);
  }
}
