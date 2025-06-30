part of 'bluetooth_scan_bloc.dart';

@freezed
abstract class BluetoothScanState with _$BluetoothScanState {
  const factory BluetoothScanState({
    @Default([]) List<DeviceEntity> devices,
  }) = _BluetoothScanState;
}
