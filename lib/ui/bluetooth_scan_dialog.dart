import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../bloc/bluetooth_scan/bluetooth_scan_bloc.dart';
import '../utils/logger.dart';

const double _displayedItemCount = 5;

class BluetoothScanDialog extends StatelessWidget {
  const BluetoothScanDialog({super.key});

  static Future<BluetoothDevice?> showBottomSheet(BuildContext context) {
    final bluetoothScanBloc = context.read<BluetoothScanBloc>();

    return showModalBottomSheet<BluetoothDevice>(
      context: context,
      builder: (BuildContext context) => BluetoothScanBlocProvider.value(
        value: bluetoothScanBloc
          ..add(const BluetoothScanEvent.clearDevices())
          ..add(const BluetoothScanEvent.scanStarted()),
        child: const BluetoothScanDialog(),
      ),
    ).whenComplete(() {
      logger.i('Bluetooth scan dialog dismissed');
      bluetoothScanBloc.add(BluetoothScanEvent.disposed());
    });
  }

  @override
  Widget build(BuildContext context) => BluetoothScanBlocBuilder(
    builder: (context, state) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '블루투스 스캔',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            height: 1.6,
          ),
        ),
        SizedBox(
          height: 48 * _displayedItemCount,
          child: ListView.builder(
            itemCount: state.devices.length,
            itemBuilder: (BuildContext context, int index) {
              /// isDense == true, 48, 64,  76
              final device = state.devices[index];

              return ListTile(
                title: Text('${device.remoteId} - ${device.platformName}'),
                dense: true,
                onTap: () {
                  Navigator.maybePop(context, device);
                },
              );
            },
          ),
        ),
      ],
    ),
  );
}
