import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:injectable/injectable.dart';

/// Bluetooth 연결 상태 확인 UseCase
abstract interface class GetBluetoothConnectionStatusUseCase {
  Stream<bool> execute();
}

@Injectable(as: GetBluetoothConnectionStatusUseCase)
class GetBluetoothConnectionStatusUseCaseImpl
    implements GetBluetoothConnectionStatusUseCase {
  GetBluetoothConnectionStatusUseCaseImpl();

  @override
  Stream<bool> execute() {
    return FlutterBluePlus.adapterState.map(
      (s) => s == BluetoothAdapterState.on,
    );
  }
}
