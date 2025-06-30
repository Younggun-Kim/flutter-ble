import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_entity.freezed.dart';

@freezed
abstract class DeviceEntity with _$DeviceEntity {
  const factory DeviceEntity({
    @Default('') String remoteId,
    @Default('') String deviceName,
  }) = _DeviceEntity;
}

extension DeviceEntityEx on DeviceEntity {
  String get logStr => '$deviceName - $remoteId';
}
