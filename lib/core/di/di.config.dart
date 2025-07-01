// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_ble/data/repository/bluetooth_repository_impl.dart'
    as _i492;
import 'package:flutter_ble/data/service/bluetooth/bluetooth_client.dart'
    as _i213;
import 'package:flutter_ble/data/service/service.dart' as _i459;
import 'package:flutter_ble/domain/domain.dart' as _i346;
import 'package:flutter_ble/domain/use_case/bluetooth_use_case.dart' as _i832;
import 'package:flutter_ble/presentation/bloc/bluetooth_communication/bluetooth_communication_bloc.dart'
    as _i441;
import 'package:flutter_ble/presentation/bloc/bluetooth_home/bluetooth_home_bloc.dart'
    as _i859;
import 'package:flutter_ble/presentation/bloc/bluetooth_scan/bluetooth_scan_bloc.dart'
    as _i1012;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i441.BluetoothCommunicationBloc>(
      () => _i441.BluetoothCommunicationBloc(),
    );
    gh.lazySingleton<_i213.BluetoothClient>(() => _i213.BluetoothClientImpl());
    gh.lazySingleton<_i346.BluetoothRepository>(
      () => _i492.BluetoothRepositoryImpl(
        bluetoothClient: gh<_i459.BluetoothClient>(),
      ),
    );
    gh.factory<_i832.BluetoothUseCase>(
      () => _i832.BluetoothUseCaseImpl(
        bluetoothRepository: gh<_i346.BluetoothRepository>(),
      ),
    );
    gh.factory<_i859.BluetoothHomeBloc>(
      () => _i859.BluetoothHomeBloc(
        bluetoothUseCase: gh<_i346.BluetoothUseCase>(),
      ),
    );
    gh.factory<_i1012.BluetoothScanBloc>(
      () => _i1012.BluetoothScanBloc(
        bluetoothUseCase: gh<_i346.BluetoothUseCase>(),
      ),
    );
    return this;
  }
}
