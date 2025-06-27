import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bluetooth_home_event.dart';

part 'bluetooth_home_state.dart';

part 'bluetooth_home_bloc.freezed.dart';

typedef BluetoothHomeBlocProvider = BlocProvider<BluetoothHomeBloc>;
typedef BluetoothHomeBlocBuilder =
    BlocBuilder<BluetoothHomeBloc, BluetoothHomeState>;

class BluetoothHomeBloc extends Bloc<BluetoothHomeEvent, BluetoothHomeState> {
  BluetoothHomeBloc() : super(const BluetoothHomeState()) {
    on<_ScanStarted>(_onScanStarted);
  }

  Future<void> _onScanStarted(
    _ScanStarted event,
    Emitter<BluetoothHomeState> emit,
  ) async {
    emit(state.copyWith(isBluetoothConnected: true));
  }
}
