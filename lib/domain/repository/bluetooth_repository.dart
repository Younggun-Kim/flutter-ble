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
  Future<void> discoverServices({required DeviceEntity device});
}
