// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inverter_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InverterMember {

@JsonKey(name: 'inverter_id') String get inverterId;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'role') InverterMemberRole get role;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of InverterMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InverterMemberCopyWith<InverterMember> get copyWith => _$InverterMemberCopyWithImpl<InverterMember>(this as InverterMember, _$identity);

  /// Serializes this InverterMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InverterMember&&(identical(other.inverterId, inverterId) || other.inverterId == inverterId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inverterId,userId,role,createdAt);

@override
String toString() {
  return 'InverterMember(inverterId: $inverterId, userId: $userId, role: $role, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $InverterMemberCopyWith<$Res>  {
  factory $InverterMemberCopyWith(InverterMember value, $Res Function(InverterMember) _then) = _$InverterMemberCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'inverter_id') String inverterId,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'role') InverterMemberRole role,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$InverterMemberCopyWithImpl<$Res>
    implements $InverterMemberCopyWith<$Res> {
  _$InverterMemberCopyWithImpl(this._self, this._then);

  final InverterMember _self;
  final $Res Function(InverterMember) _then;

/// Create a copy of InverterMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inverterId = null,Object? userId = null,Object? role = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
inverterId: null == inverterId ? _self.inverterId : inverterId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as InverterMemberRole,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [InverterMember].
extension InverterMemberPatterns on InverterMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InverterMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InverterMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InverterMember value)  $default,){
final _that = this;
switch (_that) {
case _InverterMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InverterMember value)?  $default,){
final _that = this;
switch (_that) {
case _InverterMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'inverter_id')  String inverterId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'role')  InverterMemberRole role, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InverterMember() when $default != null:
return $default(_that.inverterId,_that.userId,_that.role,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'inverter_id')  String inverterId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'role')  InverterMemberRole role, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _InverterMember():
return $default(_that.inverterId,_that.userId,_that.role,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'inverter_id')  String inverterId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'role')  InverterMemberRole role, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _InverterMember() when $default != null:
return $default(_that.inverterId,_that.userId,_that.role,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InverterMember implements InverterMember {
  const _InverterMember({@JsonKey(name: 'inverter_id') required this.inverterId, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'role') required this.role, @JsonKey(name: 'created_at') required this.createdAt});
  factory _InverterMember.fromJson(Map<String, dynamic> json) => _$InverterMemberFromJson(json);

@override@JsonKey(name: 'inverter_id') final  String inverterId;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'role') final  InverterMemberRole role;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of InverterMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InverterMemberCopyWith<_InverterMember> get copyWith => __$InverterMemberCopyWithImpl<_InverterMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InverterMemberToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InverterMember&&(identical(other.inverterId, inverterId) || other.inverterId == inverterId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inverterId,userId,role,createdAt);

@override
String toString() {
  return 'InverterMember(inverterId: $inverterId, userId: $userId, role: $role, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$InverterMemberCopyWith<$Res> implements $InverterMemberCopyWith<$Res> {
  factory _$InverterMemberCopyWith(_InverterMember value, $Res Function(_InverterMember) _then) = __$InverterMemberCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'inverter_id') String inverterId,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'role') InverterMemberRole role,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$InverterMemberCopyWithImpl<$Res>
    implements _$InverterMemberCopyWith<$Res> {
  __$InverterMemberCopyWithImpl(this._self, this._then);

  final _InverterMember _self;
  final $Res Function(_InverterMember) _then;

/// Create a copy of InverterMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inverterId = null,Object? userId = null,Object? role = null,Object? createdAt = null,}) {
  return _then(_InverterMember(
inverterId: null == inverterId ? _self.inverterId : inverterId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as InverterMemberRole,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
