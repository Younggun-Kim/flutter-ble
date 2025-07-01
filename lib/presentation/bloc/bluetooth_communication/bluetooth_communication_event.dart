part of 'bluetooth_communication_bloc.dart';

@freezed
sealed class BluetoothCommunicationEvent with _$BluetoothCommunicationEvent {
  const factory BluetoothCommunicationEvent.initialized(
    List<BluetoothCharacteristic> characteristics,
  ) = _Initialized;

  const factory BluetoothCommunicationEvent.subscribed(
    BluetoothCharacteristic characteristic,
  ) = _Subscribed;
}
