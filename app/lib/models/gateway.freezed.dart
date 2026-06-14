// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gateway.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Gateway implements DiagnosticableTreeMixin {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'hardware_id') String get hardwareId;@JsonKey(name: 'inverter_id') String get inverterId;@JsonKey(name: 'status') GatewayStatus get status;@JsonKey(name: 'provisioned_by') String get provisionedBy;@JsonKey(name: 'last_seen_at') DateTime get lastSeenAt;@JsonKey(name: 'firmware_version') String get firmwareVersion;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'retired_at') DateTime get retiredAt;
/// Create a copy of Gateway
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GatewayCopyWith<Gateway> get copyWith => _$GatewayCopyWithImpl<Gateway>(this as Gateway, _$identity);

  /// Serializes this Gateway to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Gateway'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('hardwareId', hardwareId))..add(DiagnosticsProperty('inverterId', inverterId))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('provisionedBy', provisionedBy))..add(DiagnosticsProperty('lastSeenAt', lastSeenAt))..add(DiagnosticsProperty('firmwareVersion', firmwareVersion))..add(DiagnosticsProperty('createdAt', createdAt))..add(DiagnosticsProperty('retiredAt', retiredAt));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Gateway&&(identical(other.id, id) || other.id == id)&&(identical(other.hardwareId, hardwareId) || other.hardwareId == hardwareId)&&(identical(other.inverterId, inverterId) || other.inverterId == inverterId)&&(identical(other.status, status) || other.status == status)&&(identical(other.provisionedBy, provisionedBy) || other.provisionedBy == provisionedBy)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.firmwareVersion, firmwareVersion) || other.firmwareVersion == firmwareVersion)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.retiredAt, retiredAt) || other.retiredAt == retiredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hardwareId,inverterId,status,provisionedBy,lastSeenAt,firmwareVersion,createdAt,retiredAt);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Gateway(id: $id, hardwareId: $hardwareId, inverterId: $inverterId, status: $status, provisionedBy: $provisionedBy, lastSeenAt: $lastSeenAt, firmwareVersion: $firmwareVersion, createdAt: $createdAt, retiredAt: $retiredAt)';
}


}

/// @nodoc
abstract mixin class $GatewayCopyWith<$Res>  {
  factory $GatewayCopyWith(Gateway value, $Res Function(Gateway) _then) = _$GatewayCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'hardware_id') String hardwareId,@JsonKey(name: 'inverter_id') String inverterId,@JsonKey(name: 'status') GatewayStatus status,@JsonKey(name: 'provisioned_by') String provisionedBy,@JsonKey(name: 'last_seen_at') DateTime lastSeenAt,@JsonKey(name: 'firmware_version') String firmwareVersion,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'retired_at') DateTime retiredAt
});




}
/// @nodoc
class _$GatewayCopyWithImpl<$Res>
    implements $GatewayCopyWith<$Res> {
  _$GatewayCopyWithImpl(this._self, this._then);

  final Gateway _self;
  final $Res Function(Gateway) _then;

/// Create a copy of Gateway
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? hardwareId = null,Object? inverterId = null,Object? status = null,Object? provisionedBy = null,Object? lastSeenAt = null,Object? firmwareVersion = null,Object? createdAt = null,Object? retiredAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hardwareId: null == hardwareId ? _self.hardwareId : hardwareId // ignore: cast_nullable_to_non_nullable
as String,inverterId: null == inverterId ? _self.inverterId : inverterId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GatewayStatus,provisionedBy: null == provisionedBy ? _self.provisionedBy : provisionedBy // ignore: cast_nullable_to_non_nullable
as String,lastSeenAt: null == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,firmwareVersion: null == firmwareVersion ? _self.firmwareVersion : firmwareVersion // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,retiredAt: null == retiredAt ? _self.retiredAt : retiredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Gateway].
extension GatewayPatterns on Gateway {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Gateway value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Gateway() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Gateway value)  $default,){
final _that = this;
switch (_that) {
case _Gateway():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Gateway value)?  $default,){
final _that = this;
switch (_that) {
case _Gateway() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'hardware_id')  String hardwareId, @JsonKey(name: 'inverter_id')  String inverterId, @JsonKey(name: 'status')  GatewayStatus status, @JsonKey(name: 'provisioned_by')  String provisionedBy, @JsonKey(name: 'last_seen_at')  DateTime lastSeenAt, @JsonKey(name: 'firmware_version')  String firmwareVersion, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'retired_at')  DateTime retiredAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Gateway() when $default != null:
return $default(_that.id,_that.hardwareId,_that.inverterId,_that.status,_that.provisionedBy,_that.lastSeenAt,_that.firmwareVersion,_that.createdAt,_that.retiredAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'hardware_id')  String hardwareId, @JsonKey(name: 'inverter_id')  String inverterId, @JsonKey(name: 'status')  GatewayStatus status, @JsonKey(name: 'provisioned_by')  String provisionedBy, @JsonKey(name: 'last_seen_at')  DateTime lastSeenAt, @JsonKey(name: 'firmware_version')  String firmwareVersion, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'retired_at')  DateTime retiredAt)  $default,) {final _that = this;
switch (_that) {
case _Gateway():
return $default(_that.id,_that.hardwareId,_that.inverterId,_that.status,_that.provisionedBy,_that.lastSeenAt,_that.firmwareVersion,_that.createdAt,_that.retiredAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'hardware_id')  String hardwareId, @JsonKey(name: 'inverter_id')  String inverterId, @JsonKey(name: 'status')  GatewayStatus status, @JsonKey(name: 'provisioned_by')  String provisionedBy, @JsonKey(name: 'last_seen_at')  DateTime lastSeenAt, @JsonKey(name: 'firmware_version')  String firmwareVersion, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'retired_at')  DateTime retiredAt)?  $default,) {final _that = this;
switch (_that) {
case _Gateway() when $default != null:
return $default(_that.id,_that.hardwareId,_that.inverterId,_that.status,_that.provisionedBy,_that.lastSeenAt,_that.firmwareVersion,_that.createdAt,_that.retiredAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Gateway with DiagnosticableTreeMixin implements Gateway {
  const _Gateway({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'hardware_id') required this.hardwareId, @JsonKey(name: 'inverter_id') required this.inverterId, @JsonKey(name: 'status') required this.status, @JsonKey(name: 'provisioned_by') required this.provisionedBy, @JsonKey(name: 'last_seen_at') required this.lastSeenAt, @JsonKey(name: 'firmware_version') required this.firmwareVersion, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'retired_at') required this.retiredAt});
  factory _Gateway.fromJson(Map<String, dynamic> json) => _$GatewayFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'hardware_id') final  String hardwareId;
@override@JsonKey(name: 'inverter_id') final  String inverterId;
@override@JsonKey(name: 'status') final  GatewayStatus status;
@override@JsonKey(name: 'provisioned_by') final  String provisionedBy;
@override@JsonKey(name: 'last_seen_at') final  DateTime lastSeenAt;
@override@JsonKey(name: 'firmware_version') final  String firmwareVersion;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'retired_at') final  DateTime retiredAt;

/// Create a copy of Gateway
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GatewayCopyWith<_Gateway> get copyWith => __$GatewayCopyWithImpl<_Gateway>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GatewayToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Gateway'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('hardwareId', hardwareId))..add(DiagnosticsProperty('inverterId', inverterId))..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('provisionedBy', provisionedBy))..add(DiagnosticsProperty('lastSeenAt', lastSeenAt))..add(DiagnosticsProperty('firmwareVersion', firmwareVersion))..add(DiagnosticsProperty('createdAt', createdAt))..add(DiagnosticsProperty('retiredAt', retiredAt));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Gateway&&(identical(other.id, id) || other.id == id)&&(identical(other.hardwareId, hardwareId) || other.hardwareId == hardwareId)&&(identical(other.inverterId, inverterId) || other.inverterId == inverterId)&&(identical(other.status, status) || other.status == status)&&(identical(other.provisionedBy, provisionedBy) || other.provisionedBy == provisionedBy)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.firmwareVersion, firmwareVersion) || other.firmwareVersion == firmwareVersion)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.retiredAt, retiredAt) || other.retiredAt == retiredAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,hardwareId,inverterId,status,provisionedBy,lastSeenAt,firmwareVersion,createdAt,retiredAt);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Gateway(id: $id, hardwareId: $hardwareId, inverterId: $inverterId, status: $status, provisionedBy: $provisionedBy, lastSeenAt: $lastSeenAt, firmwareVersion: $firmwareVersion, createdAt: $createdAt, retiredAt: $retiredAt)';
}


}

/// @nodoc
abstract mixin class _$GatewayCopyWith<$Res> implements $GatewayCopyWith<$Res> {
  factory _$GatewayCopyWith(_Gateway value, $Res Function(_Gateway) _then) = __$GatewayCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'hardware_id') String hardwareId,@JsonKey(name: 'inverter_id') String inverterId,@JsonKey(name: 'status') GatewayStatus status,@JsonKey(name: 'provisioned_by') String provisionedBy,@JsonKey(name: 'last_seen_at') DateTime lastSeenAt,@JsonKey(name: 'firmware_version') String firmwareVersion,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'retired_at') DateTime retiredAt
});




}
/// @nodoc
class __$GatewayCopyWithImpl<$Res>
    implements _$GatewayCopyWith<$Res> {
  __$GatewayCopyWithImpl(this._self, this._then);

  final _Gateway _self;
  final $Res Function(_Gateway) _then;

/// Create a copy of Gateway
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? hardwareId = null,Object? inverterId = null,Object? status = null,Object? provisionedBy = null,Object? lastSeenAt = null,Object? firmwareVersion = null,Object? createdAt = null,Object? retiredAt = null,}) {
  return _then(_Gateway(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,hardwareId: null == hardwareId ? _self.hardwareId : hardwareId // ignore: cast_nullable_to_non_nullable
as String,inverterId: null == inverterId ? _self.inverterId : inverterId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GatewayStatus,provisionedBy: null == provisionedBy ? _self.provisionedBy : provisionedBy // ignore: cast_nullable_to_non_nullable
as String,lastSeenAt: null == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,firmwareVersion: null == firmwareVersion ? _self.firmwareVersion : firmwareVersion // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,retiredAt: null == retiredAt ? _self.retiredAt : retiredAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
