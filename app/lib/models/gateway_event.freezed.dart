// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gateway_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GatewayEvent {

 int get id;@JsonKey(name: 'gateway_id') String get gatewayId;@JsonKey(name: 'inverter_id') String get inverterId;@JsonKey(name: 'level') GatewayEventLevel get level;@JsonKey(name: 'code') String get code;@JsonKey(name: 'message') String get message;@JsonKey(name: 'metadata') Map<String, dynamic> get metadata;@JsonKey(name: 'recorded_at') DateTime get recordedAt;@JsonKey(name: 'ingested_at') DateTime get ingestedAt;
/// Create a copy of GatewayEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GatewayEventCopyWith<GatewayEvent> get copyWith => _$GatewayEventCopyWithImpl<GatewayEvent>(this as GatewayEvent, _$identity);

  /// Serializes this GatewayEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GatewayEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.gatewayId, gatewayId) || other.gatewayId == gatewayId)&&(identical(other.inverterId, inverterId) || other.inverterId == inverterId)&&(identical(other.level, level) || other.level == level)&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.ingestedAt, ingestedAt) || other.ingestedAt == ingestedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,gatewayId,inverterId,level,code,message,const DeepCollectionEquality().hash(metadata),recordedAt,ingestedAt);

@override
String toString() {
  return 'GatewayEvent(id: $id, gatewayId: $gatewayId, inverterId: $inverterId, level: $level, code: $code, message: $message, metadata: $metadata, recordedAt: $recordedAt, ingestedAt: $ingestedAt)';
}


}

/// @nodoc
abstract mixin class $GatewayEventCopyWith<$Res>  {
  factory $GatewayEventCopyWith(GatewayEvent value, $Res Function(GatewayEvent) _then) = _$GatewayEventCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'gateway_id') String gatewayId,@JsonKey(name: 'inverter_id') String inverterId,@JsonKey(name: 'level') GatewayEventLevel level,@JsonKey(name: 'code') String code,@JsonKey(name: 'message') String message,@JsonKey(name: 'metadata') Map<String, dynamic> metadata,@JsonKey(name: 'recorded_at') DateTime recordedAt,@JsonKey(name: 'ingested_at') DateTime ingestedAt
});




}
/// @nodoc
class _$GatewayEventCopyWithImpl<$Res>
    implements $GatewayEventCopyWith<$Res> {
  _$GatewayEventCopyWithImpl(this._self, this._then);

  final GatewayEvent _self;
  final $Res Function(GatewayEvent) _then;

/// Create a copy of GatewayEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? gatewayId = null,Object? inverterId = null,Object? level = null,Object? code = null,Object? message = null,Object? metadata = null,Object? recordedAt = null,Object? ingestedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,gatewayId: null == gatewayId ? _self.gatewayId : gatewayId // ignore: cast_nullable_to_non_nullable
as String,inverterId: null == inverterId ? _self.inverterId : inverterId // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as GatewayEventLevel,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,ingestedAt: null == ingestedAt ? _self.ingestedAt : ingestedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [GatewayEvent].
extension GatewayEventPatterns on GatewayEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GatewayEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GatewayEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GatewayEvent value)  $default,){
final _that = this;
switch (_that) {
case _GatewayEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GatewayEvent value)?  $default,){
final _that = this;
switch (_that) {
case _GatewayEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'gateway_id')  String gatewayId, @JsonKey(name: 'inverter_id')  String inverterId, @JsonKey(name: 'level')  GatewayEventLevel level, @JsonKey(name: 'code')  String code, @JsonKey(name: 'message')  String message, @JsonKey(name: 'metadata')  Map<String, dynamic> metadata, @JsonKey(name: 'recorded_at')  DateTime recordedAt, @JsonKey(name: 'ingested_at')  DateTime ingestedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GatewayEvent() when $default != null:
return $default(_that.id,_that.gatewayId,_that.inverterId,_that.level,_that.code,_that.message,_that.metadata,_that.recordedAt,_that.ingestedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'gateway_id')  String gatewayId, @JsonKey(name: 'inverter_id')  String inverterId, @JsonKey(name: 'level')  GatewayEventLevel level, @JsonKey(name: 'code')  String code, @JsonKey(name: 'message')  String message, @JsonKey(name: 'metadata')  Map<String, dynamic> metadata, @JsonKey(name: 'recorded_at')  DateTime recordedAt, @JsonKey(name: 'ingested_at')  DateTime ingestedAt)  $default,) {final _that = this;
switch (_that) {
case _GatewayEvent():
return $default(_that.id,_that.gatewayId,_that.inverterId,_that.level,_that.code,_that.message,_that.metadata,_that.recordedAt,_that.ingestedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'gateway_id')  String gatewayId, @JsonKey(name: 'inverter_id')  String inverterId, @JsonKey(name: 'level')  GatewayEventLevel level, @JsonKey(name: 'code')  String code, @JsonKey(name: 'message')  String message, @JsonKey(name: 'metadata')  Map<String, dynamic> metadata, @JsonKey(name: 'recorded_at')  DateTime recordedAt, @JsonKey(name: 'ingested_at')  DateTime ingestedAt)?  $default,) {final _that = this;
switch (_that) {
case _GatewayEvent() when $default != null:
return $default(_that.id,_that.gatewayId,_that.inverterId,_that.level,_that.code,_that.message,_that.metadata,_that.recordedAt,_that.ingestedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GatewayEvent implements GatewayEvent {
  const _GatewayEvent({required this.id, @JsonKey(name: 'gateway_id') required this.gatewayId, @JsonKey(name: 'inverter_id') required this.inverterId, @JsonKey(name: 'level') required this.level, @JsonKey(name: 'code') required this.code, @JsonKey(name: 'message') required this.message, @JsonKey(name: 'metadata') required final  Map<String, dynamic> metadata, @JsonKey(name: 'recorded_at') required this.recordedAt, @JsonKey(name: 'ingested_at') required this.ingestedAt}): _metadata = metadata;
  factory _GatewayEvent.fromJson(Map<String, dynamic> json) => _$GatewayEventFromJson(json);

@override final  int id;
@override@JsonKey(name: 'gateway_id') final  String gatewayId;
@override@JsonKey(name: 'inverter_id') final  String inverterId;
@override@JsonKey(name: 'level') final  GatewayEventLevel level;
@override@JsonKey(name: 'code') final  String code;
@override@JsonKey(name: 'message') final  String message;
 final  Map<String, dynamic> _metadata;
@override@JsonKey(name: 'metadata') Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}

@override@JsonKey(name: 'recorded_at') final  DateTime recordedAt;
@override@JsonKey(name: 'ingested_at') final  DateTime ingestedAt;

/// Create a copy of GatewayEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GatewayEventCopyWith<_GatewayEvent> get copyWith => __$GatewayEventCopyWithImpl<_GatewayEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GatewayEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GatewayEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.gatewayId, gatewayId) || other.gatewayId == gatewayId)&&(identical(other.inverterId, inverterId) || other.inverterId == inverterId)&&(identical(other.level, level) || other.level == level)&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.ingestedAt, ingestedAt) || other.ingestedAt == ingestedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,gatewayId,inverterId,level,code,message,const DeepCollectionEquality().hash(_metadata),recordedAt,ingestedAt);

@override
String toString() {
  return 'GatewayEvent(id: $id, gatewayId: $gatewayId, inverterId: $inverterId, level: $level, code: $code, message: $message, metadata: $metadata, recordedAt: $recordedAt, ingestedAt: $ingestedAt)';
}


}

/// @nodoc
abstract mixin class _$GatewayEventCopyWith<$Res> implements $GatewayEventCopyWith<$Res> {
  factory _$GatewayEventCopyWith(_GatewayEvent value, $Res Function(_GatewayEvent) _then) = __$GatewayEventCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'gateway_id') String gatewayId,@JsonKey(name: 'inverter_id') String inverterId,@JsonKey(name: 'level') GatewayEventLevel level,@JsonKey(name: 'code') String code,@JsonKey(name: 'message') String message,@JsonKey(name: 'metadata') Map<String, dynamic> metadata,@JsonKey(name: 'recorded_at') DateTime recordedAt,@JsonKey(name: 'ingested_at') DateTime ingestedAt
});




}
/// @nodoc
class __$GatewayEventCopyWithImpl<$Res>
    implements _$GatewayEventCopyWith<$Res> {
  __$GatewayEventCopyWithImpl(this._self, this._then);

  final _GatewayEvent _self;
  final $Res Function(_GatewayEvent) _then;

/// Create a copy of GatewayEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? gatewayId = null,Object? inverterId = null,Object? level = null,Object? code = null,Object? message = null,Object? metadata = null,Object? recordedAt = null,Object? ingestedAt = null,}) {
  return _then(_GatewayEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,gatewayId: null == gatewayId ? _self.gatewayId : gatewayId // ignore: cast_nullable_to_non_nullable
as String,inverterId: null == inverterId ? _self.inverterId : inverterId // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as GatewayEventLevel,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,ingestedAt: null == ingestedAt ? _self.ingestedAt : ingestedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
