abstract interface class BluetoothRepository {
  Stream<bool> hasPermission();

  Future<void> turnOn();
}
