import 'package:injectable/injectable.dart';

import '../../domain/repository/bluetooth_repository.dart';

@LazySingleton(as: BluetoothRepository)
class BluetoothRepositoryImpl implements BluetoothRepository {}
