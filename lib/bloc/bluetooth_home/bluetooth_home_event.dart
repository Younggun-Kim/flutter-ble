part of 'bluetooth_home_bloc.dart';

@freezed
class BluetoothHomeEvent with _$BluetoothHomeEvent {
  const factory BluetoothHomeEvent.scanStarted() = _ScanStarted;
}
