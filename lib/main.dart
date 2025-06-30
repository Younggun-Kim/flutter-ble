import 'package:flutter/material.dart';
import 'package:flutter_ble/presentation/presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';

import 'core/core.dart';

void main() {
  Bloc.observer = TalkerBlocObserver(
    settings: TalkerBlocLoggerSettings(),
  );

  BluetoothManager.init();

  configureDependencies();

  runApp(
    MaterialApp(
      title: '블루투스 데모',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SafeArea(child: BluetoothHomeScreen()),
    ),
  );
}
