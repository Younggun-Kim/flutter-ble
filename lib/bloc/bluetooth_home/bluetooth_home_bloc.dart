import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../utils/logger.dart';

part 'bluetooth_home_event.dart';

part 'bluetooth_home_state.dart';

part 'bluetooth_home_bloc.freezed.dart';

typedef BluetoothHomeBlocProvider = BlocProvider<BluetoothHomeBloc>;
typedef BluetoothHomeBlocBuilder =
    BlocBuilder<BluetoothHomeBloc, BluetoothHomeState>;

class BluetoothHomeBloc extends Bloc<BluetoothHomeEvent, BluetoothHomeState> {
  BluetoothHomeBloc() : super(const BluetoothHomeState()) {
    on<_DeviceScanned>(_onDeviceScanned);
    on<_DeviceConnected>(_onDeviceConnected);
    on<_DeviceDisconnected>(_onDeviceDisconnected);
    on<_DeviceAutoConnected>(_onDeviceAutoConnected);
  }

  StreamSubscription<BluetoothConnectionState>? _connectionState;

  @override
  close() async {
    _connectionState?.cancel();
    super.close();
  }

  Future<void> _onDeviceScanned(
    _DeviceScanned event,
    Emitter<BluetoothHomeState> emit,
  ) async {
    final device = event.device;

    emit(state.copyWith(scannedDevice: device));

    _subscribeToConnectionState(device);

    await device.connect(mtu: 512);
  }

  Future<void> _onDeviceConnected(
    _DeviceConnected event,
    Emitter<BluetoothHomeState> emit,
  ) async {
    final connectedDevice = event.device;

    logger.i('Connected Device: $connectedDevice');

    emit(state.copyWith(connectedDevice: connectedDevice));

    if (connectedDevice == null) return;

    List<BluetoothService> services = await connectedDevice.discoverServices();

    logger.f('${await services.last.characteristics.last.read()}');
  }

  void _onDeviceDisconnected(
    _DeviceDisconnected event,
    Emitter<BluetoothHomeState> emit,
  ) {
    _connectionState?.cancel();
    state.connectedDevice?.disconnect();
    emit(state.copyWith(connectedDevice: null));
  }

  void _onDeviceAutoConnected(
    _DeviceAutoConnected event,
    Emitter<BluetoothHomeState> emit,
  ) async {
    final careSendRemoteId = DeviceIdentifier('D0:2E:AB:BB:B5:27');
    BluetoothDevice device = BluetoothDevice(remoteId: careSendRemoteId);

    _subscribeToConnectionState(device);

    await device.disconnect();
    await device.connect(autoConnect: true, mtu: null);
  }

  void _subscribeToConnectionState(
    BluetoothDevice device,
  ) {
    _connectionState?.cancel();
    _connectionState = device.connectionState.listen((
      BluetoothConnectionState state,
    ) {
      if (state == BluetoothConnectionState.connected) {
        add(
          BluetoothHomeEvent.deviceConnected(
            FlutterBluePlus.connectedDevices.first,
          ),
        );
      } else {
        add(BluetoothHomeEvent.deviceConnected(null));
      }
    });
  }
}
