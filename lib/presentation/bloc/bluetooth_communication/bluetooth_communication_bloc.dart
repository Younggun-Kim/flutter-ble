import 'dart:async';

import 'package:flutter_ble/domain/domain.dart';
import 'package:flutter_ble/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'bluetooth_communication_event.dart';
part 'bluetooth_communication_state.dart';
part 'bluetooth_communication_bloc.freezed.dart';

typedef BluetoothCommunicationBlocProvider =
    BlocProvider<BluetoothCommunicationBloc>;
typedef BluetoothCommunicationBlocBuilder =
    BlocBuilder<BluetoothCommunicationBloc, BluetoothCommunicationState>;

@injectable
class BluetoothCommunicationBloc
    extends Bloc<BluetoothCommunicationEvent, BluetoothCommunicationState> {
  BluetoothCommunicationBloc({required this.bluetoothUseCase})
    : super(const BluetoothCommunicationState()) {
    on<_Initialized>(_onInitialized);
    on<_Subscribed>(_onSubscribed);
    on<_Disposed>(_onDisposed);
    on<_AddMessage>(_onAddMessage);
    on<_ClearMessage>(_onClearMessage);
    on<_WriteMessage>(
      _onWriteMessage,
      transformer: (events, mapper) => events
          .debounceTime(
            const Duration(milliseconds: 300),
          )
          .switchMap(mapper),
    );
  }

  final BluetoothUseCase bluetoothUseCase;
  StreamSubscription<List<int>?>? characterSubscription;

  void _onInitialized(
    _Initialized event,
    Emitter<BluetoothCommunicationState> emit,
  ) {
    emit(state.copyWith(characteristics: event.characteristics));
  }

  void _onSubscribed(
    _Subscribed event,
    Emitter<BluetoothCommunicationState> emit,
  ) async {
    characterSubscription?.cancel();
    characterSubscription = null;

    final characteristic = event.characteristic;

    emit(state.copyWith(subscribedCharacteristic: characteristic));

    final stream = await bluetoothUseCase.getCharacteristicLastValue(
      characteristic,
    );

    add(BluetoothCommunicationEvent.clearMessage());

    /// 메시지 구독
    characterSubscription = stream?.listen(
      (List<int>? value) {
        if (value == null) return;

        add(
          BluetoothCommunicationEvent.addMessage(toHexString(value)),
        );
      },
    );
  }

  void _onDisposed(
    _Disposed event,
    Emitter<BluetoothCommunicationState> emit,
  ) {
    characterSubscription?.cancel();
    characterSubscription = null;
  }

  void _onAddMessage(
    _AddMessage event,
    Emitter<BluetoothCommunicationState> emit,
  ) {
    emit(
      state.copyWith(message: [...state.message, event.message]),
    );
  }

  void _onClearMessage(
    _ClearMessage event,
    Emitter<BluetoothCommunicationState> emit,
  ) {
    emit(
      state.copyWith(message: []),
    );
  }

  String toHexString(List<int> bytes) {
    return bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join(' ');
  }

  void _onWriteMessage(
    _WriteMessage event,
    Emitter<BluetoothCommunicationState> emit,
  ) async {
    final characteristic = state.subscribedCharacteristic;

    if (characteristic == null) return;

    await bluetoothUseCase.writeMessage(
      characteristic: characteristic,
      message: convertToIntList(event.message),
    );
  }

  List<int> convertToIntList(String input) {
    final List<int> result = [];

    for (int i = 0; i < input.length; i += 2) {
      final chunk = (i + 2 <= input.length)
          ? input.substring(i, i + 2)
          : input.substring(i).padLeft(2, '0');
      result.add(int.parse(chunk));
    }

    return result;
  }
}
