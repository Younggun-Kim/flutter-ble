part of 'bluetooth_scan_bloc.dart';

@freezed
sealed class BluetoothScanEvent with _$BluetoothScanEvent {
  const factory BluetoothScanEvent.scanStarted() = _ScanStarted;
  const factory BluetoothScanEvent.disposed() = _Disposed;
  const factory BluetoothScanEvent.addDevice(
    List<BluetoothDevice> devices,
  ) = _AddDevice;
  const factory BluetoothScanEvent.clearDevices() = _ClearDevices;
}
