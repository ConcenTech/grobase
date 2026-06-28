// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'location.dart';

part 'gateway_registration.freezed.dart';
part 'gateway_registration.g.dart';

@freezed
/// The data contained in the response from the `register_gateway` endpoint.
abstract class GatewayRegistrationResponse with _$GatewayRegistrationResponse {
  const factory GatewayRegistrationResponse({
    @JsonKey(name: 'gateway_id') required String gatewayId,
    @JsonKey(name: 'inverter_id') required String inverterId,
    @JsonKey(name: 'device_secret') required String deviceSecret,
    @JsonKey(name: 'inverter_sn') required String inverterSerialNumber,
  }) = _GatewayRegistrationResponse;

  factory GatewayRegistrationResponse.fromJson(Map<String, dynamic> json) =>
      _$GatewayRegistrationResponseFromJson(json);
}

@freezed
abstract class GatewayRegistrationRequest with _$GatewayRegistrationRequest {
  const factory GatewayRegistrationRequest({
    @JsonKey(name: 'mode') required GatewayRegistrationMode mode,
    @JsonKey(name: 'hardware_id') required String hardwareId,
    @JsonKey(name: 'inverter_sn') required String inverterSerialNumber,
    @JsonKey(name: 'profile') String? profile,
    @JsonKey(name: 'inverter_id') String? inverterId,
    @JsonKey(name: 'display_name') required String displayName,
    @JsonKey(name: 'location') required Location location,
  }) = _GatewayRegistrationRequest;

  factory GatewayRegistrationRequest.fromJson(Map<String, dynamic> json) =>
      _$GatewayRegistrationRequestFromJson(json);
}

enum GatewayRegistrationMode {
  @JsonValue('new')
  create,
  @JsonValue('replace')
  replace,
}
