import 'package:flutter/material.dart';
import 'package:flutter_ble/bloc/bloc.dart';
import 'package:flutter_ble/bluetooth/bluetooth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bluetooth_scan_dialog.dart';

class BluetoothHomeScreen extends StatelessWidget {
  const BluetoothHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BluetoothHomeBlocProvider(
          create: (context) => BluetoothHomeBloc(),
        ),
        BluetoothScanBlocProvider(
          create: (context) => BluetoothScanBloc(),
        ),
      ],
      child: BluetoothHomeBlocBuilder(
        builder: (context, state) => Scaffold(
          body: SizedBox.expand(
            child: Column(
              children: [
                EndDrawerButton(
                  onPressed: () {
                    BluetoothManager.turnOn();
                  },
                ),
                ElevatedButton(
                  child: Text('스캔하기'),
                  onPressed: () {
                    BluetoothScanDialog.showBottomSheet(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
