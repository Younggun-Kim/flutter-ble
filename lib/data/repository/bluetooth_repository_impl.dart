import 'package:flutter_ble/domain/domain.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:injectable/injectable.dart';

import '../service/service.dart';

@LazySingleton(as: BluetoothRepository)
class BluetoothRepositoryImpl implements BluetoothRepository {
  final BluetoothClient bluetoothClient;

  BluetoothRepositoryImpl({required this.bluetoothClient});

  @override
  Stream<bool> hasPermission() {
    return bluetoothClient.hasPermission();
  }

  @override
  Future<void> turnOn() async {
    return await bluetoothClient.turnOn();
  }

  @override
  Stream<DeviceEntity?> startScan() {
    return bluetoothClient.startScan().map<DeviceEntity?>(
      (List<ScanResult> results) => results.isNotEmpty
          ? DeviceEntity(
              remoteId: results.last.device.remoteId.str,
              deviceName: results.last.device.platformName,
            )
          : null,
    );
  }

  @override
  Future<void> stopScan() async {
    return await bluetoothClient.stopScan();
  }
}
