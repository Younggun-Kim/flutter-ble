import 'package:flutter_ble/domain/domain.dart';
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
}
