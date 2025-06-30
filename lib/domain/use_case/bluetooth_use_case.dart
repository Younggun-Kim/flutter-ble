import 'package:injectable/injectable.dart';

import 'package:flutter_ble/domain/repository/repository.dart';

/// Bluetooth 연결 상태 확인 UseCase
abstract interface class BluetoothUseCase {
  /// 블루투스 권한 검사
  Stream<bool> hasPermission();
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
}
