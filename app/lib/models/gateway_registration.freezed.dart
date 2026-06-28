// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gateway_registration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GatewayRegistrationResponse implements DiagnosticableTreeMixin {

@JsonKey(name: 'gateway_id') String get gatewayId;@JsonKey(name: 'inverter_id') String get inverterId;@JsonKey(name: 'device_secret') String get deviceSecret;@JsonKey(name: 'inverter_sn') String get inverterSerialNumber;
/// Create a copy of GatewayRegistrationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GatewayRegistrationResponseCopyWith<GatewayRegistrationResponse> get copyWith => _$GatewayRegistrationResponseCopyWithImpl<GatewayRegistrationResponse>(this as GatewayRegistrationResponse, _$identity);

  /// Serializes this GatewayRegistrationResponse to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'GatewayRegistrationResponse'))
    ..add(DiagnosticsProperty('gatewayId', gatewayId))..add(DiagnosticsProperty('inverterId', inverterId))..add(DiagnosticsProperty('deviceSecret', deviceSecret))..add(DiagnosticsProperty('inverterSerialNumber', inverterSerialNumber));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GatewayRegistrationResponse&&(identical(other.gatewayId, gatewayId) || other.gatewayId == gatewayId)&&(identical(other.inverterId, inverterId) || other.inverterId == inverterId)&&(identical(other.deviceSecret, deviceSecret) || other.deviceSecret == deviceSecret)&&(identical(other.inverterSerialNumber, inverterSerialNumber) || other.inverterSerialNumber == inverterSerialNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gatewayId,inverterId,deviceSecret,inverterSerialNumber);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'GatewayRegistrationResponse(gatewayId: $gatewayId, inverterId: $inverterId, deviceSecret: $deviceSecret, inverterSerialNumber: $inverterSerialNumber)';
}


}

/// @nodoc
abstract mixin class $GatewayRegistrationResponseCopyWith<$Res>  {
  factory $GatewayRegistrationResponseCopyWith(GatewayRegistrationResponse value, $Res Function(GatewayRegistrationResponse) _then) = _$GatewayRegistrationResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'gateway_id') String gatewayId,@JsonKey(name: 'inverter_id') String inverterId,@JsonKey(name: 'device_secret') String deviceSecret,@JsonKey(name: 'inverter_sn') String inverterSerialNumber
});




}
/// @nodoc
class _$GatewayRegistrationResponseCopyWithImpl<$Res>
    implements $GatewayRegistrationResponseCopyWith<$Res> {
  _$GatewayRegistrationResponseCopyWithImpl(this._self, this._then);

  final GatewayRegistrationResponse _self;
  final $Res Function(GatewayRegistrationResponse) _then;

/// Create a copy of GatewayRegistrationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gatewayId = null,Object? inverterId = null,Object? deviceSecret = null,Object? inverterSerialNumber = null,}) {
  return _then(_self.copyWith(
gatewayId: null == gatewayId ? _self.gatewayId : gatewayId // ignore: cast_nullable_to_non_nullable
as String,inverterId: null == inverterId ? _self.inverterId : inverterId // ignore: cast_nullable_to_non_nullable
as String,deviceSecret: null == deviceSecret ? _self.deviceSecret : deviceSecret // ignore: cast_nullable_to_non_nullable
as String,inverterSerialNumber: null == inverterSerialNumber ? _self.inverterSerialNumber : inverterSerialNumber // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GatewayRegistrationResponse].
extension GatewayRegistrationResponsePatterns on GatewayRegistrationResponse {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GatewayRegistrationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GatewayRegistrationResponse() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GatewayRegistrationResponse value)  $default,){
final _that = this;
switch (_that) {
case _GatewayRegistrationResponse():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GatewayRegistrationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GatewayRegistrationResponse() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'gateway_id')  String gatewayId, @JsonKey(name: 'inverter_id')  String inverterId, @JsonKey(name: 'device_secret')  String deviceSecret, @JsonKey(name: 'inverter_sn')  String inverterSerialNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GatewayRegistrationResponse() when $default != null:
return $default(_that.gatewayId,_that.inverterId,_that.deviceSecret,_that.inverterSerialNumber);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'gateway_id')  String gatewayId, @JsonKey(name: 'inverter_id')  String inverterId, @JsonKey(name: 'device_secret')  String deviceSecret, @JsonKey(name: 'inverter_sn')  String inverterSerialNumber)  $default,) {final _that = this;
switch (_that) {
case _GatewayRegistrationResponse():
return $default(_that.gatewayId,_that.inverterId,_that.deviceSecret,_that.inverterSerialNumber);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'gateway_id')  String gatewayId, @JsonKey(name: 'inverter_id')  String inverterId, @JsonKey(name: 'device_secret')  String deviceSecret, @JsonKey(name: 'inverter_sn')  String inverterSerialNumber)?  $default,) {final _that = this;
switch (_that) {
case _GatewayRegistrationResponse() when $default != null:
return $default(_that.gatewayId,_that.inverterId,_that.deviceSecret,_that.inverterSerialNumber);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GatewayRegistrationResponse with DiagnosticableTreeMixin implements GatewayRegistrationResponse {
  const _GatewayRegistrationResponse({@JsonKey(name: 'gateway_id') required this.gatewayId, @JsonKey(name: 'inverter_id') required this.inverterId, @JsonKey(name: 'device_secret') required this.deviceSecret, @JsonKey(name: 'inverter_sn') required this.inverterSerialNumber});
  factory _GatewayRegistrationResponse.fromJson(Map<String, dynamic> json) => _$GatewayRegistrationResponseFromJson(json);

@override@JsonKey(name: 'gateway_id') final  String gatewayId;
@override@JsonKey(name: 'inverter_id') final  String inverterId;
@override@JsonKey(name: 'device_secret') final  String deviceSecret;
@override@JsonKey(name: 'inverter_sn') final  String inverterSerialNumber;

/// Create a copy of GatewayRegistrationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GatewayRegistrationResponseCopyWith<_GatewayRegistrationResponse> get copyWith => __$GatewayRegistrationResponseCopyWithImpl<_GatewayRegistrationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GatewayRegistrationResponseToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'GatewayRegistrationResponse'))
    ..add(DiagnosticsProperty('gatewayId', gatewayId))..add(DiagnosticsProperty('inverterId', inverterId))..add(DiagnosticsProperty('deviceSecret', deviceSecret))..add(DiagnosticsProperty('inverterSerialNumber', inverterSerialNumber));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GatewayRegistrationResponse&&(identical(other.gatewayId, gatewayId) || other.gatewayId == gatewayId)&&(identical(other.inverterId, inverterId) || other.inverterId == inverterId)&&(identical(other.deviceSecret, deviceSecret) || other.deviceSecret == deviceSecret)&&(identical(other.inverterSerialNumber, inverterSerialNumber) || other.inverterSerialNumber == inverterSerialNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gatewayId,inverterId,deviceSecret,inverterSerialNumber);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'GatewayRegistrationResponse(gatewayId: $gatewayId, inverterId: $inverterId, deviceSecret: $deviceSecret, inverterSerialNumber: $inverterSerialNumber)';
}


}

/// @nodoc
abstract mixin class _$GatewayRegistrationResponseCopyWith<$Res> implements $GatewayRegistrationResponseCopyWith<$Res> {
  factory _$GatewayRegistrationResponseCopyWith(_GatewayRegistrationResponse value, $Res Function(_GatewayRegistrationResponse) _then) = __$GatewayRegistrationResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'gateway_id') String gatewayId,@JsonKey(name: 'inverter_id') String inverterId,@JsonKey(name: 'device_secret') String deviceSecret,@JsonKey(name: 'inverter_sn') String inverterSerialNumber
});




}
/// @nodoc
class __$GatewayRegistrationResponseCopyWithImpl<$Res>
    implements _$GatewayRegistrationResponseCopyWith<$Res> {
  __$GatewayRegistrationResponseCopyWithImpl(this._self, this._then);

  final _GatewayRegistrationResponse _self;
  final $Res Function(_GatewayRegistrationResponse) _then;

/// Create a copy of GatewayRegistrationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gatewayId = null,Object? inverterId = null,Object? deviceSecret = null,Object? inverterSerialNumber = null,}) {
  return _then(_GatewayRegistrationResponse(
gatewayId: null == gatewayId ? _self.gatewayId : gatewayId // ignore: cast_nullable_to_non_nullable
as String,inverterId: null == inverterId ? _self.inverterId : inverterId // ignore: cast_nullable_to_non_nullable
as String,deviceSecret: null == deviceSecret ? _self.deviceSecret : deviceSecret // ignore: cast_nullable_to_non_nullable
as String,inverterSerialNumber: null == inverterSerialNumber ? _self.inverterSerialNumber : inverterSerialNumber // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GatewayRegistrationRequest implements DiagnosticableTreeMixin {

@JsonKey(name: 'mode') GatewayRegistrationMode get mode;@JsonKey(name: 'hardware_id') String get hardwareId;@JsonKey(name: 'inverter_sn') String get inverterSerialNumber;@JsonKey(name: 'profile') String? get profile;@JsonKey(name: 'inverter_id') String? get inverterId;@JsonKey(name: 'display_name') String get displayName;@JsonKey(name: 'location') Location get location;
/// Create a copy of GatewayRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GatewayRegistrationRequestCopyWith<GatewayRegistrationRequest> get copyWith => _$GatewayRegistrationRequestCopyWithImpl<GatewayRegistrationRequest>(this as GatewayRegistrationRequest, _$identity);

  /// Serializes this GatewayRegistrationRequest to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'GatewayRegistrationRequest'))
    ..add(DiagnosticsProperty('mode', mode))..add(DiagnosticsProperty('hardwareId', hardwareId))..add(DiagnosticsProperty('inverterSerialNumber', inverterSerialNumber))..add(DiagnosticsProperty('profile', profile))..add(DiagnosticsProperty('inverterId', inverterId))..add(DiagnosticsProperty('displayName', displayName))..add(DiagnosticsProperty('location', location));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GatewayRegistrationRequest&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.hardwareId, hardwareId) || other.hardwareId == hardwareId)&&(identical(other.inverterSerialNumber, inverterSerialNumber) || other.inverterSerialNumber == inverterSerialNumber)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.inverterId, inverterId) || other.inverterId == inverterId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,hardwareId,inverterSerialNumber,profile,inverterId,displayName,location);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'GatewayRegistrationRequest(mode: $mode, hardwareId: $hardwareId, inverterSerialNumber: $inverterSerialNumber, profile: $profile, inverterId: $inverterId, displayName: $displayName, location: $location)';
}


}

/// @nodoc
abstract mixin class $GatewayRegistrationRequestCopyWith<$Res>  {
  factory $GatewayRegistrationRequestCopyWith(GatewayRegistrationRequest value, $Res Function(GatewayRegistrationRequest) _then) = _$GatewayRegistrationRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'mode') GatewayRegistrationMode mode,@JsonKey(name: 'hardware_id') String hardwareId,@JsonKey(name: 'inverter_sn') String inverterSerialNumber,@JsonKey(name: 'profile') String? profile,@JsonKey(name: 'inverter_id') String? inverterId,@JsonKey(name: 'display_name') String displayName,@JsonKey(name: 'location') Location location
});


$LocationCopyWith<$Res> get location;

}
/// @nodoc
class _$GatewayRegistrationRequestCopyWithImpl<$Res>
    implements $GatewayRegistrationRequestCopyWith<$Res> {
  _$GatewayRegistrationRequestCopyWithImpl(this._self, this._then);

  final GatewayRegistrationRequest _self;
  final $Res Function(GatewayRegistrationRequest) _then;

/// Create a copy of GatewayRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? hardwareId = null,Object? inverterSerialNumber = null,Object? profile = freezed,Object? inverterId = freezed,Object? displayName = null,Object? location = null,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as GatewayRegistrationMode,hardwareId: null == hardwareId ? _self.hardwareId : hardwareId // ignore: cast_nullable_to_non_nullable
as String,inverterSerialNumber: null == inverterSerialNumber ? _self.inverterSerialNumber : inverterSerialNumber // ignore: cast_nullable_to_non_nullable
as String,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as String?,inverterId: freezed == inverterId ? _self.inverterId : inverterId // ignore: cast_nullable_to_non_nullable
as String?,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as Location,
  ));
}
/// Create a copy of GatewayRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationCopyWith<$Res> get location {
  
  return $LocationCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// Adds pattern-matching-related methods to [GatewayRegistrationRequest].
extension GatewayRegistrationRequestPatterns on GatewayRegistrationRequest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GatewayRegistrationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GatewayRegistrationRequest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GatewayRegistrationRequest value)  $default,){
final _that = this;
switch (_that) {
case _GatewayRegistrationRequest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GatewayRegistrationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _GatewayRegistrationRequest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'mode')  GatewayRegistrationMode mode, @JsonKey(name: 'hardware_id')  String hardwareId, @JsonKey(name: 'inverter_sn')  String inverterSerialNumber, @JsonKey(name: 'profile')  String? profile, @JsonKey(name: 'inverter_id')  String? inverterId, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'location')  Location location)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GatewayRegistrationRequest() when $default != null:
return $default(_that.mode,_that.hardwareId,_that.inverterSerialNumber,_that.profile,_that.inverterId,_that.displayName,_that.location);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'mode')  GatewayRegistrationMode mode, @JsonKey(name: 'hardware_id')  String hardwareId, @JsonKey(name: 'inverter_sn')  String inverterSerialNumber, @JsonKey(name: 'profile')  String? profile, @JsonKey(name: 'inverter_id')  String? inverterId, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'location')  Location location)  $default,) {final _that = this;
switch (_that) {
case _GatewayRegistrationRequest():
return $default(_that.mode,_that.hardwareId,_that.inverterSerialNumber,_that.profile,_that.inverterId,_that.displayName,_that.location);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'mode')  GatewayRegistrationMode mode, @JsonKey(name: 'hardware_id')  String hardwareId, @JsonKey(name: 'inverter_sn')  String inverterSerialNumber, @JsonKey(name: 'profile')  String? profile, @JsonKey(name: 'inverter_id')  String? inverterId, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'location')  Location location)?  $default,) {final _that = this;
switch (_that) {
case _GatewayRegistrationRequest() when $default != null:
return $default(_that.mode,_that.hardwareId,_that.inverterSerialNumber,_that.profile,_that.inverterId,_that.displayName,_that.location);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GatewayRegistrationRequest with DiagnosticableTreeMixin implements GatewayRegistrationRequest {
  const _GatewayRegistrationRequest({@JsonKey(name: 'mode') required this.mode, @JsonKey(name: 'hardware_id') required this.hardwareId, @JsonKey(name: 'inverter_sn') required this.inverterSerialNumber, @JsonKey(name: 'profile') this.profile, @JsonKey(name: 'inverter_id') this.inverterId, @JsonKey(name: 'display_name') required this.displayName, @JsonKey(name: 'location') required this.location});
  factory _GatewayRegistrationRequest.fromJson(Map<String, dynamic> json) => _$GatewayRegistrationRequestFromJson(json);

@override@JsonKey(name: 'mode') final  GatewayRegistrationMode mode;
@override@JsonKey(name: 'hardware_id') final  String hardwareId;
@override@JsonKey(name: 'inverter_sn') final  String inverterSerialNumber;
@override@JsonKey(name: 'profile') final  String? profile;
@override@JsonKey(name: 'inverter_id') final  String? inverterId;
@override@JsonKey(name: 'display_name') final  String displayName;
@override@JsonKey(name: 'location') final  Location location;

/// Create a copy of GatewayRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GatewayRegistrationRequestCopyWith<_GatewayRegistrationRequest> get copyWith => __$GatewayRegistrationRequestCopyWithImpl<_GatewayRegistrationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GatewayRegistrationRequestToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'GatewayRegistrationRequest'))
    ..add(DiagnosticsProperty('mode', mode))..add(DiagnosticsProperty('hardwareId', hardwareId))..add(DiagnosticsProperty('inverterSerialNumber', inverterSerialNumber))..add(DiagnosticsProperty('profile', profile))..add(DiagnosticsProperty('inverterId', inverterId))..add(DiagnosticsProperty('displayName', displayName))..add(DiagnosticsProperty('location', location));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GatewayRegistrationRequest&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.hardwareId, hardwareId) || other.hardwareId == hardwareId)&&(identical(other.inverterSerialNumber, inverterSerialNumber) || other.inverterSerialNumber == inverterSerialNumber)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.inverterId, inverterId) || other.inverterId == inverterId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,hardwareId,inverterSerialNumber,profile,inverterId,displayName,location);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'GatewayRegistrationRequest(mode: $mode, hardwareId: $hardwareId, inverterSerialNumber: $inverterSerialNumber, profile: $profile, inverterId: $inverterId, displayName: $displayName, location: $location)';
}


}

/// @nodoc
abstract mixin class _$GatewayRegistrationRequestCopyWith<$Res> implements $GatewayRegistrationRequestCopyWith<$Res> {
  factory _$GatewayRegistrationRequestCopyWith(_GatewayRegistrationRequest value, $Res Function(_GatewayRegistrationRequest) _then) = __$GatewayRegistrationRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'mode') GatewayRegistrationMode mode,@JsonKey(name: 'hardware_id') String hardwareId,@JsonKey(name: 'inverter_sn') String inverterSerialNumber,@JsonKey(name: 'profile') String? profile,@JsonKey(name: 'inverter_id') String? inverterId,@JsonKey(name: 'display_name') String displayName,@JsonKey(name: 'location') Location location
});


@override $LocationCopyWith<$Res> get location;

}
/// @nodoc
class __$GatewayRegistrationRequestCopyWithImpl<$Res>
    implements _$GatewayRegistrationRequestCopyWith<$Res> {
  __$GatewayRegistrationRequestCopyWithImpl(this._self, this._then);

  final _GatewayRegistrationRequest _self;
  final $Res Function(_GatewayRegistrationRequest) _then;

/// Create a copy of GatewayRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? hardwareId = null,Object? inverterSerialNumber = null,Object? profile = freezed,Object? inverterId = freezed,Object? displayName = null,Object? location = null,}) {
  return _then(_GatewayRegistrationRequest(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as GatewayRegistrationMode,hardwareId: null == hardwareId ? _self.hardwareId : hardwareId // ignore: cast_nullable_to_non_nullable
as String,inverterSerialNumber: null == inverterSerialNumber ? _self.inverterSerialNumber : inverterSerialNumber // ignore: cast_nullable_to_non_nullable
as String,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as String?,inverterId: freezed == inverterId ? _self.inverterId : inverterId // ignore: cast_nullable_to_non_nullable
as String?,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as Location,
  ));
}

/// Create a copy of GatewayRegistrationRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationCopyWith<$Res> get location {
  
  return $LocationCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}

// dart format on
