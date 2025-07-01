import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../entity/entity.dart';

abstract interface class BluetoothRepository {
  Stream<bool> hasPermission();

  Future<void> turnOn();

  Stream<DeviceEntity?> startScan();

  Future<void> stopScan();

  /// 연결 요청
  Future<void> connect({
    required DeviceEntity device,
  });

  /// 자동 연결
  Future<void> autoConnect({
    required DeviceEntity device,
  });

  /// 연결 해제
  Future<void> disconnected({
    required DeviceEntity device,
  });

  /// 연결 여부
  Stream<bool> isConnected({required DeviceEntity device});

  /// 등록된 서비스 조회
  Future<List<BluetoothService>> discoverServices({
    required DeviceEntity device,
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
