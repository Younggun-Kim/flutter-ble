import 'dart:async';

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
  BluetoothScanBloc() : super(const BluetoothScanState()) {
    on<_ScanStarted>(_onScanStarted);
    on<_Disposed>(_onDisposed);
    on<_AddDevice>(_onAddDevice);
    on<_ClearDevices>(_onClearDevices);
  }

  StreamSubscription<List<ScanResult>>? _scanSubscription;

  void _onScanStarted(
    _ScanStarted event,
    Emitter<BluetoothScanState> emit,
  ) async {
    FlutterBluePlus.stopScan();

    _scanSubscription = FlutterBluePlus.onScanResults.listen(
      (List<ScanResult> results) {
        if (results.isNotEmpty) {
          final r = results.last;
          logger.i('Scan: ${r.device.remoteId} - ${r.device.platformName}');
          add(_AddDevice([r.device]));
        }
      },
      onError: (e) => logger.e(e),
      onDone: () => logger.i('Scan Done!'),
    );

    if (_scanSubscription == null) {
      return;
    }

    FlutterBluePlus.cancelWhenScanComplete(_scanSubscription!);

    FlutterBluePlus.startScan(
      withNames: ['Glucose002'],
      // withNames: ['CareSens 1057'],
      timeout: Duration(seconds: 10),
    );
  }

  void _onDisposed(
    _Disposed event,
    Emitter<BluetoothScanState> emit,
  ) {
    _scanSubscription?.cancel();
    FlutterBluePlus.stopScan();
  }

  void _onAddDevice(
    _AddDevice event,
    Emitter<BluetoothScanState> emit,
  ) {
    emit(
      state.copyWith(
        devices: [
          ...state.devices,
          ...event.devices,
        ],
      ),
    );
  }

  void _onClearDevices(
    _ClearDevices event,
    Emitter<BluetoothScanState> emit,
  ) {
    emit(state.copyWith(devices: []));
  }
}
