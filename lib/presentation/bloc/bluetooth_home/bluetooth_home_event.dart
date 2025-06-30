part of 'bluetooth_home_bloc.dart';

@freezed
sealed class BluetoothHomeEvent with _$BluetoothHomeEvent {
  const factory BluetoothHomeEvent.initialized() = _Initialized;
  const factory BluetoothHomeEvent.turnOnPressed() = _TurnOnPressed;
  const factory BluetoothHomeEvent.setBluetoothPermission(
    bool hasPermission,
  ) = _SetBluetoothPermission;
  const factory BluetoothHomeEvent.deviceScanned(
    DeviceEntity device,
  ) = _DeviceScanned;
  const factory BluetoothHomeEvent.deviceConnected(
    DeviceEntity? device,
  ) = _DeviceConnected;
  const factory BluetoothHomeEvent.disconnected() = _DeviceDisconnected;
  const factory BluetoothHomeEvent.autoConnected() = _DeviceAutoConnected;
}
