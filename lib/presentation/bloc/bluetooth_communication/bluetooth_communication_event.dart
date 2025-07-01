part of 'bluetooth_communication_bloc.dart';

@freezed
sealed class BluetoothCommunicationEvent with _$BluetoothCommunicationEvent {
  const factory BluetoothCommunicationEvent.initialized(
    List<BluetoothCharacteristic> characteristics,
  ) = _Initialized;

  const factory BluetoothCommunicationEvent.subscribed(
    BluetoothCharacteristic characteristic,
  ) = _Subscribed;

  const factory BluetoothCommunicationEvent.disposed() = _Disposed;

  const factory BluetoothCommunicationEvent.addMessage(
    String message,
  ) = _AddMessage;

  const factory BluetoothCommunicationEvent.clearMessage() = _ClearMessage;

  const factory BluetoothCommunicationEvent.writeMessage({
    required String message,
  }) = _WriteMessage;
}
