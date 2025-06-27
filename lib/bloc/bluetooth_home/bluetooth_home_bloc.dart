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
    emit(state.copyWith(scannedDevice: event.device));

    _connectionState?.cancel();
    _connectionState = event.device.connectionState.listen((
      BluetoothConnectionState state,
    ) {
      if (state == BluetoothConnectionState.connected) {
        add(BluetoothHomeEvent.deviceConnected(event.device));
      } else {
        add(BluetoothHomeEvent.deviceConnected(null));
      }
    });

    await event.device.connect(mtu: 512);
  }

  Future<void> _onDeviceConnected(
    _DeviceConnected event,
    Emitter<BluetoothHomeState> emit,
  ) async {
    final connectedDevice = event.device;

    emit(state.copyWith(connectedDevice: connectedDevice));

    if (connectedDevice == null) return;

    List<BluetoothService> services = await connectedDevice.discoverServices();

    logger.i(services.map((service) => service.serviceUuid).join(', '));

    var characteristics = services.last.characteristics;
    for (BluetoothCharacteristic c in characteristics) {
      if (c.properties.read) {
        List<int> value = await c.read();
        logger.f(c.uuid.toString() + ' : ' + value.toString());
      }
    }
  }

  void _onDeviceDisconnected(
    _DeviceDisconnected event,
    Emitter<BluetoothHomeState> emit,
  ) {
    _connectionState?.cancel();
    state.connectedDevice?.disconnect();
    emit(state.copyWith(connectedDevice: null));
  }
}
