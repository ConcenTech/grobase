// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'gateway.freezed.dart';
part 'gateway.g.dart';

@freezed
abstract class Gateway with _$Gateway {
  const factory Gateway({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'hardware_id') required String hardwareId,
    @JsonKey(name: 'inverter_id') required String inverterId,
    @JsonKey(name: 'status') required GatewayStatus status,
    @JsonKey(name: 'provisioned_by') required String provisionedBy,
    @JsonKey(name: 'last_seen_at') required DateTime lastSeenAt,
    @JsonKey(name: 'firmware_version') required String firmwareVersion,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'retired_at') required DateTime retiredAt,
  }) = _Gateway;

  factory Gateway.fromJson(Map<String, dynamic> json) =>
      _$GatewayFromJson(json);
}

enum GatewayStatus { pending, active, retired }
