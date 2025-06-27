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
                  onPressed: () async {
                    final homeBloc = context.read<BluetoothHomeBloc>();
                    final scannedDevice =
                        await BluetoothScanDialog.showBottomSheet(context);

                    if (scannedDevice == null) return;

                    homeBloc.add(
                      BluetoothHomeEvent.deviceScanned(scannedDevice),
                    );
                  },
                ),
                ElevatedButton(
                  child: Text('연결해제'),
                  onPressed: () {
                    context.read<BluetoothHomeBloc>().add(
                      BluetoothHomeEvent.disconnected(),
                    );
                  },
                ),
                Text('검색된 디바이스: ${state.scannedDevice?.platformName ?? ''}'),
                Text('연결된 디바이스: ${state.connectedDevice?.platformName ?? ''}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
