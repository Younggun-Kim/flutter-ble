import 'package:flutter_ble/domain/domain.dart';
import 'package:injectable/injectable.dart';

/// Bluetooth 연결 상태 확인 UseCase
abstract interface class BluetoothUseCase {
  /// 블루투스 권한 검사
  Stream<bool> hasPermission();

  Future<void> turnOn();

  Future<Stream<DeviceEntity?>> startScan();

  Future<void> stopScan();
}

@Injectable(as: BluetoothUseCase)
class BluetoothUseCaseImpl implements BluetoothUseCase {
  BluetoothUseCaseImpl({
    required this.bluetoothRepository,
  });

  final BluetoothRepository bluetoothRepository;

  @override
  Stream<bool> hasPermission() {
    return bluetoothRepository.hasPermission();
  }

  @override
  Future<void> turnOn() async {
    return await bluetoothRepository.turnOn();
  }

  @override
  Future<Stream<DeviceEntity?>> startScan() async {
    await stopScan();

    return bluetoothRepository.startScan();
  }

  @override
  Future<void> stopScan() {
    return bluetoothRepository.stopScan();
  }
}
