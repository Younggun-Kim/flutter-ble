part of 'bluetooth_home_bloc.dart';

@freezed
sealed class BluetoothHomeEvent with _$BluetoothHomeEvent {
  const factory BluetoothHomeEvent.deviceScanned(
    BluetoothDevice device,
  ) = _DeviceScanned;
  const factory BluetoothHomeEvent.deviceConnected(
    BluetoothDevice? device,
  ) = _DeviceConnected;
  const factory BluetoothHomeEvent.disconnected() = _DeviceDisconnected;
}
