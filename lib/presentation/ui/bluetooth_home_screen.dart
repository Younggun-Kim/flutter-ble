import 'package:flutter/material.dart';
import 'package:flutter_ble/domain/domain.dart';
import 'package:flutter_ble/presentation/ui/ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ble/core/core.dart';
import 'package:flutter_ble/presentation/bloc/bloc.dart';

class BluetoothHomeScreen extends StatelessWidget {
  const BluetoothHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BluetoothHomeBlocProvider(
          create: (context) => getIt<BluetoothHomeBloc>()
            ..add(
              BluetoothHomeEvent.initialized(),
            ),
        ),
        BluetoothScanBlocProvider(
          create: (context) => getIt<BluetoothScanBloc>(),
        ),
        BluetoothCommunicationBlocProvider(
          create: (context) => getIt<BluetoothCommunicationBloc>(),
        ),
      ],
      child: BluetoothHomeBlocBuilder(
        builder: (context, state) => Scaffold(
          body: SizedBox.expand(
            child: Column(
              spacing: 8,
              children: [
                const SizedBox(height: 24),
                Text('블루투스  현재 권한 권한 : ${state.hasBluetoothPermission}'),
                ElevatedButton(
                  child: Text('Turn On'),
                  onPressed: () async {
                    context.read<BluetoothHomeBloc>().add(
                      BluetoothHomeEvent.turnOnPressed(),
                    );
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
                  '검색된 디바이스: ${state.scannedDevice?.logStr}',
                ),
                Text('연결된 디바이스: ${state.connectedDevice?.logStr}'),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.services.length,
                    itemBuilder: (context, index) {
                      final service = state.services[index];
                      return ListTile(
                        title: Text('ServiceUUID - ${service.serviceUuid}'),
                        subtitle: Text(
                          'characterCount: ${service.characteristics.length}',
                        ),
                        trailing: ElevatedButton(
                          child: Text('통신하기'),
                          onPressed: () {
                            BluetoothCommunicationDialog.showBottomSheet(
                              context,
                              service.characteristics,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
