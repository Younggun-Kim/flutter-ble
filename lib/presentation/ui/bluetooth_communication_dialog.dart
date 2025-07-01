import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../utils/logger.dart';
import '../bloc/bluetooth_communication/bluetooth_communication_bloc.dart';

class BluetoothCommunicationDialog extends StatelessWidget {
  const BluetoothCommunicationDialog({
    super.key,
    required this.characteristics,
  });

  final List<BluetoothCharacteristic> characteristics;

  static Future<void> showBottomSheet(
    BuildContext context,
    List<BluetoothCharacteristic> characteristics,
  ) {
    final bloc = context.read<BluetoothCommunicationBloc>();

    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) =>
          BluetoothCommunicationBlocProvider.value(
            value: bloc
              ..add(
                BluetoothCommunicationEvent.initialized(characteristics),
              ),
            child: BluetoothCommunicationDialog(
              characteristics: characteristics,
            ),
          ),
    ).whenComplete(() {
      logger.i('BluetoothCommunicationDialog popped');
    });
  }

  @override
  Widget build(BuildContext context) {
    return BluetoothCommunicationBlocBuilder(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          height: 700,
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('연결된 기기와 대화하기'),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: state.characteristics.length,
                itemBuilder: (context, index) {
                  final characteristic = state.characteristics[index];

                  return ListTile(
                    title: Text(characteristic.characteristicUuid.str),
                    trailing: ActionChip.elevated(
                      label: Text('구독'),
                      onPressed: () {
                        context.read<BluetoothCommunicationBloc>().add(
                          BluetoothCommunicationEvent.subscribed(
                            characteristic,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
