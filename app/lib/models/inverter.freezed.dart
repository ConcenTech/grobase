// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inverter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Inverter implements DiagnosticableTreeMixin {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'serial_number') String get serialNumber;@JsonKey(name: 'display_name') String get displayName;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'last_seen_at') DateTime get lastSeenAt;@JsonKey(name: 'location') Location get location;
/// Create a copy of Inverter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InverterCopyWith<Inverter> get copyWith => _$InverterCopyWithImpl<Inverter>(this as Inverter, _$identity);

  /// Serializes this Inverter to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Inverter'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('serialNumber', serialNumber))..add(DiagnosticsProperty('displayName', displayName))..add(DiagnosticsProperty('createdAt', createdAt))..add(DiagnosticsProperty('lastSeenAt', lastSeenAt))..add(DiagnosticsProperty('location', location));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Inverter&&(identical(other.id, id) || other.id == id)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,serialNumber,displayName,createdAt,lastSeenAt,location);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Inverter(id: $id, serialNumber: $serialNumber, displayName: $displayName, createdAt: $createdAt, lastSeenAt: $lastSeenAt, location: $location)';
}


}

/// @nodoc
abstract mixin class $InverterCopyWith<$Res>  {
  factory $InverterCopyWith(Inverter value, $Res Function(Inverter) _then) = _$InverterCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'serial_number') String serialNumber,@JsonKey(name: 'display_name') String displayName,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'last_seen_at') DateTime lastSeenAt,@JsonKey(name: 'location') Location location
});


$LocationCopyWith<$Res> get location;

}
/// @nodoc
class _$InverterCopyWithImpl<$Res>
    implements $InverterCopyWith<$Res> {
  _$InverterCopyWithImpl(this._self, this._then);

  final Inverter _self;
  final $Res Function(Inverter) _then;

/// Create a copy of Inverter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? serialNumber = null,Object? displayName = null,Object? createdAt = null,Object? lastSeenAt = null,Object? location = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastSeenAt: null == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as Location,
  ));
}
/// Create a copy of Inverter
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationCopyWith<$Res> get location {
  
  return $LocationCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// Adds pattern-matching-related methods to [Inverter].
extension InverterPatterns on Inverter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Inverter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Inverter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Inverter value)  $default,){
final _that = this;
switch (_that) {
case _Inverter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Inverter value)?  $default,){
final _that = this;
switch (_that) {
case _Inverter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'serial_number')  String serialNumber, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'last_seen_at')  DateTime lastSeenAt, @JsonKey(name: 'location')  Location location)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Inverter() when $default != null:
return $default(_that.id,_that.serialNumber,_that.displayName,_that.createdAt,_that.lastSeenAt,_that.location);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'serial_number')  String serialNumber, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'last_seen_at')  DateTime lastSeenAt, @JsonKey(name: 'location')  Location location)  $default,) {final _that = this;
switch (_that) {
case _Inverter():
return $default(_that.id,_that.serialNumber,_that.displayName,_that.createdAt,_that.lastSeenAt,_that.location);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'serial_number')  String serialNumber, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'last_seen_at')  DateTime lastSeenAt, @JsonKey(name: 'location')  Location location)?  $default,) {final _that = this;
switch (_that) {
case _Inverter() when $default != null:
return $default(_that.id,_that.serialNumber,_that.displayName,_that.createdAt,_that.lastSeenAt,_that.location);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Inverter with DiagnosticableTreeMixin implements Inverter {
  const _Inverter({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'serial_number') required this.serialNumber, @JsonKey(name: 'display_name') required this.displayName, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'last_seen_at') required this.lastSeenAt, @JsonKey(name: 'location') required this.location});
  factory _Inverter.fromJson(Map<String, dynamic> json) => _$InverterFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'serial_number') final  String serialNumber;
@override@JsonKey(name: 'display_name') final  String displayName;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'last_seen_at') final  DateTime lastSeenAt;
@override@JsonKey(name: 'location') final  Location location;

/// Create a copy of Inverter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InverterCopyWith<_Inverter> get copyWith => __$InverterCopyWithImpl<_Inverter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InverterToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'Inverter'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('serialNumber', serialNumber))..add(DiagnosticsProperty('displayName', displayName))..add(DiagnosticsProperty('createdAt', createdAt))..add(DiagnosticsProperty('lastSeenAt', lastSeenAt))..add(DiagnosticsProperty('location', location));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Inverter&&(identical(other.id, id) || other.id == id)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,serialNumber,displayName,createdAt,lastSeenAt,location);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'Inverter(id: $id, serialNumber: $serialNumber, displayName: $displayName, createdAt: $createdAt, lastSeenAt: $lastSeenAt, location: $location)';
}


}

/// @nodoc
abstract mixin class _$InverterCopyWith<$Res> implements $InverterCopyWith<$Res> {
  factory _$InverterCopyWith(_Inverter value, $Res Function(_Inverter) _then) = __$InverterCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'serial_number') String serialNumber,@JsonKey(name: 'display_name') String displayName,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'last_seen_at') DateTime lastSeenAt,@JsonKey(name: 'location') Location location
});


@override $LocationCopyWith<$Res> get location;

}
/// @nodoc
class __$InverterCopyWithImpl<$Res>
    implements _$InverterCopyWith<$Res> {
  __$InverterCopyWithImpl(this._self, this._then);

  final _Inverter _self;
  final $Res Function(_Inverter) _then;

/// Create a copy of Inverter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? serialNumber = null,Object? displayName = null,Object? createdAt = null,Object? lastSeenAt = null,Object? location = null,}) {
  return _then(_Inverter(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,serialNumber: null == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastSeenAt: null == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as Location,
  ));
}

/// Create a copy of Inverter
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
