part of 'bluetooth_communication_bloc.dart';

@freezed
abstract class BluetoothCommunicationState with _$BluetoothCommunicationState {
  const factory BluetoothCommunicationState({
    @Default([]) List<BluetoothCharacteristic> characteristics,
  }) = _BluetoothCommunicationState;
}
