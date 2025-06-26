import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothManager {
  static void init() {
    FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  }
}
