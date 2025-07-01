import 'dart:async';

import 'package:flutter_ble/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

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
  BluetoothCommunicationBloc() : super(const BluetoothCommunicationState()) {
    on<_Initialized>(_onInitialized);
    on<_Subscribed>(_onSubscribed);
  }

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

    /// Stream으로 받기 위한 설정 - characteristic이 Notify타입을 지원해야 한다.
    await characteristic.setNotifyValue(true);

    /// 기록된 마지막 값 읽어오기
    await characteristic.read();

    /// 메시지 받기
    characterSubscription = characteristic.lastValueStream.listen(
      (List<int>? value) {
        logger.i(value);
      },
    );

    /// 메시지 쓰기
    Future.delayed(const Duration(seconds: 3), () {
      characteristic.write([1, 2, 3, 4]);
    });
  }
}
