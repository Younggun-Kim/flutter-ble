import 'dart:async';

import 'package:flutter_ble/domain/domain.dart';
import 'package:flutter_ble/utils/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'bluetooth_scan_bloc.freezed.dart';
part 'bluetooth_scan_event.dart';
part 'bluetooth_scan_state.dart';

typedef BluetoothScanBlocProvider = BlocProvider<BluetoothScanBloc>;
typedef BluetoothScanBlocBuilder =
    BlocBuilder<BluetoothScanBloc, BluetoothScanState>;

@injectable
class BluetoothScanBloc extends Bloc<BluetoothScanEvent, BluetoothScanState> {
  BluetoothScanBloc({
    required this.bluetoothUseCase,
  }) : super(const BluetoothScanState()) {
    on<_ScanStarted>(_onScanStarted);
    on<_Disposed>(_onDisposed);
    on<_AddDevice>(_onAddDevice);
    on<_ClearDevices>(_onClearDevices);
  }

  final BluetoothUseCase bluetoothUseCase;
  StreamSubscription<DeviceEntity?>? _scanSubscription;

  void _onScanStarted(
    _ScanStarted event,
    Emitter<BluetoothScanState> emit,
  ) async {
    Stream<DeviceEntity?> scanStream = await bluetoothUseCase.startScan();

    _scanSubscription = scanStream.listen((DeviceEntity? device) {
      if (device == null) return;

      add(_AddDevice(device));
    });

    /// TODO: BluetoothClient로 분리
    FlutterBluePlus.cancelWhenScanComplete(_scanSubscription!);
  }

  void _onDisposed(
    _Disposed event,
    Emitter<BluetoothScanState> emit,
  ) async {
    _scanSubscription?.cancel();
    await bluetoothUseCase.stopScan();
  }

  void _onAddDevice(
    _AddDevice event,
    Emitter<BluetoothScanState> emit,
  ) {
    emit(
      state.copyWith(devices: [...state.devices, event.device]),
    );
  }

  void _onClearDevices(
    _ClearDevices event,
    Emitter<BluetoothScanState> emit,
  ) {
    emit(state.copyWith(devices: []));
  }
}
