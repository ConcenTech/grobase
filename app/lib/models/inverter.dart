import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'location.dart';

part 'inverter.freezed.dart';
part 'inverter.g.dart';

@freezed
abstract class Inverter with _$Inverter {
  const factory Inverter({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'serial_number') required String serialNumber,
    @JsonKey(name: 'display_name') required String displayName,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'last_seen_at') required DateTime lastSeenAt,
    @JsonKey(name: 'location') required Location location,
  }) = _Inverter;

  const Inverter._(); // Added constructor for custom getters

  factory Inverter.fromJson(Map<String, dynamic> json) =>
      _$InverterFromJson(json);

  bool get isOnline => DateTime.now().difference(lastSeenAt).inHours < 5;
}
