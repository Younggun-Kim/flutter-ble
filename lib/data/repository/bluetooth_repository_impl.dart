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

  /// 연결 요청
  @override
  Future<void> connect({
    required DeviceEntity device,
  }) async {
    final bluetoothDevice = BluetoothDevice(
      remoteId: DeviceIdentifier(device.remoteId),
    );

    return await bluetoothClient.connect(device: bluetoothDevice);
  }

  /// 자동 연결
  @override
  Future<void> autoConnect({
    required DeviceEntity device,
  }) async {
    final bluetoothDevice = BluetoothDevice(
      remoteId: DeviceIdentifier(device.remoteId),
    );

    return await bluetoothClient.autoConnect(device: bluetoothDevice);
  }

  /// 연결 해제
  @override
  Future<void> disconnected({
    required DeviceEntity device,
  }) async {
    final bluetoothDevice = BluetoothDevice(
      remoteId: DeviceIdentifier(device.remoteId),
    );

    return await bluetoothClient.disconnected(device: bluetoothDevice);
  }

  /// 연결 여부
  @override
  Stream<bool> isConnected({required DeviceEntity device}) {
    final bluetoothDevice = BluetoothDevice(
      remoteId: DeviceIdentifier(device.remoteId),
    );

    return bluetoothClient.isConnected(device: bluetoothDevice);
  }

  /// 등록된 서비스 조회
  @override
  Future<List<BluetoothService>> discoverServices({
    required DeviceEntity device,
  }) async {
    final bluetoothDevice = BluetoothDevice(
      remoteId: DeviceIdentifier(device.remoteId),
    );

    return await bluetoothClient.discoverServices(device: bluetoothDevice);
  }

  /// Characteristic 메시지 스트림 설정
  @override
  Future<Stream<List<int>>?> getCharacteristicLastValue(
    BluetoothCharacteristic characteristic,
  ) async {
    return await bluetoothClient.getCharacteristicLastValue(characteristic);
  }

  /// Characteristic에 메시지 보내기
  @override
  Future<void> writeMessage({
    required BluetoothCharacteristic characteristic,
    required List<int> message,
  }) async {
    await bluetoothClient.writeMessage(
      characteristic: characteristic,
      message: message,
    );
  }
}
