import 'dart:async';

import 'package:flutter_ble/domain/domain.dart';
import 'package:flutter_ble/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

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
    on<_SetServices>(_onSetServices);
  }

  final BluetoothUseCase bluetoothUseCase;
  StreamSubscription<bool>? _permissionSubscription;
  StreamSubscription<bool>? _connectionState;
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
    _subscribeToConnectionState(device);

    await bluetoothUseCase.connect(device);
  }

  Future<void> _onDeviceConnected(
    _DeviceConnected event,
    Emitter<BluetoothHomeState> emit,
  ) async {
    final connectedDevice = event.device;

    emit(state.copyWith(connectedDevice: connectedDevice));

    if (connectedDevice == null) return;

    final List<BluetoothService> services = await bluetoothUseCase
        .discoverServices(
          connectedDevice,
        );

    add(_SetServices(services));

    // TODO: 조회한 서비스를 기반으로 stream 기반의 통신 연결하기
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

    final device = state.connectedDevice;
    if (device != null) {
      bluetoothUseCase.disconnected(device);
      emit(state.copyWith(connectedDevice: null));
    }
  }

  void _onDeviceAutoConnected(
    _DeviceAutoConnected event,
    Emitter<BluetoothHomeState> emit,
  ) async {
    /// TODO: 저장된 디바이스 정보를 가져오기
    final device = DeviceEntity(remoteId: 'D0:2E:AB:BB:B5:27');
    _subscribeToConnectionState(device);

    await bluetoothUseCase.autoConnect(device);
  }

  void _subscribeToConnectionState(DeviceEntity device) {
    _connectionState?.cancel();
    _connectionState = bluetoothUseCase.isConnected(device).listen((
      bool isConnected,
    ) {
      if (isConnected) {
        add(BluetoothHomeEvent.deviceConnected(device));
      } else {
        add(BluetoothHomeEvent.deviceConnected(null));
      }
    });
  }

  void _onSetServices(_SetServices event, Emitter<BluetoothHomeState> emit) {
    emit(state.copyWith(services: event.services));
  }
}
