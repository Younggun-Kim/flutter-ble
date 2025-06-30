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
import 'package:flutter_ble/domain/repository/bluetooth_repository.dart'
    as _i606;
import 'package:flutter_ble/domain/use_case/get_bluetooth_connection_status_use_case.dart'
    as _i776;
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
    gh.factory<_i859.BluetoothHomeBloc>(() => _i859.BluetoothHomeBloc());
    gh.factory<_i1012.BluetoothScanBloc>(() => _i1012.BluetoothScanBloc());
    gh.factory<_i776.GetBluetoothConnectionStatusUseCase>(
      () => _i776.GetBluetoothConnectionStatusUseCaseImpl(),
    );
    gh.lazySingleton<_i606.BluetoothRepository>(
      () => _i492.BluetoothRepositoryImpl(),
    );
    return this;
  }
}
