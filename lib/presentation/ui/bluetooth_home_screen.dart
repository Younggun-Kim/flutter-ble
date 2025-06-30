import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ble/core/core.dart';
import 'package:flutter_ble/presentation/bloc/bloc.dart';

import 'bluetooth_scan_dialog.dart';

class BluetoothHomeScreen extends StatelessWidget {
  const BluetoothHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BluetoothHomeBlocProvider(
          create: (context) => getIt<BluetoothHomeBloc>(),
        ),
        BluetoothScanBlocProvider(
          create: (context) => getIt<BluetoothScanBloc>(),
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
                  child: Text('자동연결'),
                  onPressed: () {
                    context.read<BluetoothHomeBloc>().add(
                      BluetoothHomeEvent.autoConnected(),
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
                Text(
                  '검색된 디바이스: ${state.scannedDevice?.platformName ?? ''} - ${state.scannedDevice?.remoteId}',
                ),
                Text('연결된 디바이스: ${state.connectedDevice?.platformName ?? ''}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
