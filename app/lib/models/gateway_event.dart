import 'package:freezed_annotation/freezed_annotation.dart';

part 'gateway_event.freezed.dart';
part 'gateway_event.g.dart';

@freezed
abstract class GatewayEvent with _$GatewayEvent {
  const factory GatewayEvent({
    required int id,
    @JsonKey(name: 'gateway_id') required String gatewayId,
    @JsonKey(name: 'inverter_id') required String inverterId,
    @JsonKey(name: 'level') required GatewayEventLevel level,
    @JsonKey(name: 'code') required String code,
    @JsonKey(name: 'message') required String message,
    @JsonKey(name: 'metadata') required Map<String, dynamic> metadata,
    @JsonKey(name: 'recorded_at') required DateTime recordedAt,
    @JsonKey(name: 'ingested_at') required DateTime ingestedAt,
  }) = _GatewayEvent;

  factory GatewayEvent.fromJson(Map<String, dynamic> json) =>
      _$GatewayEventFromJson(json);
}

enum GatewayEventLevel { info, warn, error }
