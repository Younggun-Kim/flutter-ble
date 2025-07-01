import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: Text('연결된 기기와 대화하기')),
              SliverList.builder(
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
              SliverToBoxAdapter(child: Text('메시지 목록')),
              SliverList.builder(
                itemCount: state.message.length,
                itemBuilder: (context, index) {
                  final message = state.message[index];

                  return ListTile(
                    title: Text(message),
                  );
                },
              ),
              SliverToBoxAdapter(
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (String text) {
                    context.read<BluetoothCommunicationBloc>().add(
                      BluetoothCommunicationEvent.writeMessage(message: text),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
