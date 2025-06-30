import 'package:flutter_ble/domain/domain.dart';
import 'package:injectable/injectable.dart';

/// Bluetooth 연결 상태 확인 UseCase
abstract interface class BluetoothUseCase {
  /// 블루투스 권한 검사
  Stream<bool> hasPermission();

  Future<void> turnOn();

  Future<Stream<DeviceEntity?>> startScan();

  Future<void> stopScan();

  /// 연결 요청
  Future<void> connect(DeviceEntity device);

  /// 자동 연결 요청
  Future<void> autoConnect(DeviceEntity device);

  /// 연결 해제
  Future<void> disconnected(DeviceEntity device);

  /// 연결 여부
  Stream<bool> isConnected(DeviceEntity device);

  /// 등록된 서비스 조회
  Future<void> discoverServices(DeviceEntity device);
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

  /// 연결 요청
  @override
  Future<void> connect(DeviceEntity device) async {
    await disconnected(device);

    return await bluetoothRepository.connect(device: device);
  }

  /// 자동 연결 요청
  @override
  Future<void> autoConnect(DeviceEntity device) async {
    await disconnected(device);

    return await bluetoothRepository.autoConnect(device: device);
  }

  /// 연결 해제
  @override
  Future<void> disconnected(DeviceEntity device) async {
    return await bluetoothRepository.disconnected(device: device);
  }

  /// 연결 여부
  @override
  Stream<bool> isConnected(DeviceEntity device) {
    return bluetoothRepository.isConnected(device: device);
  }

  /// 등록된 서비스 조회
  @override
  Future<void> discoverServices(DeviceEntity device) async {
    await bluetoothRepository.discoverServices(device: device);
  }
}
