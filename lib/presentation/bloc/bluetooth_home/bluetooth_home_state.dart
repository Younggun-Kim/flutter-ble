part of 'bluetooth_home_bloc.dart';

@freezed
abstract class BluetoothHomeState with _$BluetoothHomeState {
  const factory BluetoothHomeState({
    @Default(false) bool hasBluetoothPermission,
    @Default(false) bool isBluetoothConnected,
    DeviceEntity? scannedDevice,
    DeviceEntity? connectedDevice,
    @Default([]) List<BluetoothService> services,
  }) = _BluetoothHomeState;
}
