import '../entity/entity.dart';

abstract interface class BluetoothRepository {
  Stream<bool> hasPermission();

  Future<void> turnOn();

  Stream<DeviceEntity?> startScan();

  Future<void> stopScan();
}
