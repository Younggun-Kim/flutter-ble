import 'dart:async';

import 'package:flutter_ble/domain/domain.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../utils/logger.dart';

part 'bluetooth_home_event.dart';

part 'bluetooth_home_state.dart';

part 'bluetooth_home_bloc.freezed.dart';

typedef BluetoothHomeBlocProvider = BlocProvider<BluetoothHomeBloc>;
typedef BluetoothHomeBlocBuilder =
    BlocBuilder<BluetoothHomeBloc, BluetoothHomeState>;

@injectable
class BluetoothHomeBloc extends Bloc<BluetoothHomeEvent, BluetoothHomeState> {
  BluetoothHomeBloc({
    required this.bluetoothUseCase,
  }) : super(const BluetoothHomeState()) {
    on<_Initialized>(_onInitialized);
    on<_TurnOnPressed>(_onTurnOnPressed);
    on<_SetBluetoothPermission>(_onSetBluetoothPermission);
    on<_DeviceScanned>(_onDeviceScanned);
    on<_DeviceConnected>(_onDeviceConnected);
    on<_DeviceDisconnected>(_onDeviceDisconnected);
    on<_DeviceAutoConnected>(_onDeviceAutoConnected);
  }

  final BluetoothUseCase bluetoothUseCase;
  StreamSubscription<bool>? _permissionSubscription;
  StreamSubscription<BluetoothConnectionState>? _connectionState;
  StreamSubscription<BluetoothConnectionState>? _notifySubscription;

  @override
  close() async {
    _permissionSubscription?.cancel();
    _connectionState?.cancel();
    _notifySubscription?.cancel();
    super.close();
  }

  void _onInitialized(
    _Initialized event,
    Emitter<BluetoothHomeState> emit,
  ) async {
    _permissionSubscription ??= bluetoothUseCase.hasPermission().listen(
      (bool permission) => add(_SetBluetoothPermission(permission)),
    );
  }

  void _onTurnOnPressed(
    _TurnOnPressed event,
    Emitter<BluetoothHomeState> emit,
  ) async {
    await bluetoothUseCase.turnOn();
  }

  void _onSetBluetoothPermission(
    _SetBluetoothPermission event,
    Emitter<BluetoothHomeState> emit,
  ) {
    emit(state.copyWith(hasBluetoothPermission: event.hasPermission));
  }

  Future<void> _onDeviceScanned(
    _DeviceScanned event,
    Emitter<BluetoothHomeState> emit,
  ) async {
    final device = event.device;

    emit(state.copyWith(scannedDevice: device));

    // await device.connect(mtu: 512);
  }

  Future<void> _onDeviceConnected(
    _DeviceConnected event,
    Emitter<BluetoothHomeState> emit,
  ) async {
    // final connectedDevice = event.device;
    //
    // emit(state.copyWith(connectedDevice: connectedDevice));
    //
    // if (connectedDevice == null) return;
    //
    // List<BluetoothService> services = await connectedDevice.discoverServices();
    //
    // for (var service in services) {
    //   for (var c in service.characteristics) {
    //     /// notify: true라면 값을 스트림으로 수신받기 가능
    //     /// peripheral기기의 character가 notify를 허용하고 있어야 한다.
    //     if (c.properties.notify) {
    //       c.setNotifyValue(true);
    //       c.lastValueStream.listen((value) {
    //         logger.i(value);
    //       });
    //     }
    //   }
    // }
  }

  void _onDeviceDisconnected(
    _DeviceDisconnected event,
    Emitter<BluetoothHomeState> emit,
  ) {
    _connectionState?.cancel();
    emit(state.copyWith(connectedDevice: null));
  }

  void _onDeviceAutoConnected(
    _DeviceAutoConnected event,
    Emitter<BluetoothHomeState> emit,
  ) async {
    /// 저장된 디바이스 정보를 가져오기
    final careSendRemoteId = DeviceIdentifier('D0:2E:AB:BB:B5:27');
    BluetoothDevice device = BluetoothDevice(remoteId: careSendRemoteId);

    _subscribeToConnectionState(device);

    await device.disconnect();
    await device.connect(autoConnect: true, mtu: null);
  }

  void _subscribeToConnectionState(
    BluetoothDevice device,
  ) {
    // _connectionState?.cancel();
    // _connectionState = device.connectionState.listen((
    //   BluetoothConnectionState state,
    // ) {
    //   if (state == BluetoothConnectionState.connected) {
    //     add(
    //       BluetoothHomeEvent.deviceConnected(
    //         FlutterBluePlus.connectedDevices.first,
    //       ),
    //     );
    //   } else {
    //     add(BluetoothHomeEvent.deviceConnected(null));
    //   }
    // });
  }
}
