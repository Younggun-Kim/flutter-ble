part of 'bluetooth_home_bloc.dart';

@freezed
abstract class BluetoothHomeState with _$BluetoothHomeState {
  const factory BluetoothHomeState({
    @Default(false) bool isBluetoothConnected,
    BluetoothDevice? scannedDevice,
    BluetoothDevice? connectedDevice,
  }) = _BluetoothHomeState;
}
