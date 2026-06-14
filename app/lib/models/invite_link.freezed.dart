// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invite_link.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InviteLink {

@JsonKey(name: 'invite_id') String get id;@JsonKey(name: 'token') String get token;@JsonKey(name: 'invite_url') String get url;@JsonKey(name: 'expires_at') DateTime get expiresAt;
/// Create a copy of InviteLink
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InviteLinkCopyWith<InviteLink> get copyWith => _$InviteLinkCopyWithImpl<InviteLink>(this as InviteLink, _$identity);

  /// Serializes this InviteLink to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InviteLink&&(identical(other.id, id) || other.id == id)&&(identical(other.token, token) || other.token == token)&&(identical(other.url, url) || other.url == url)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,token,url,expiresAt);

@override
String toString() {
  return 'InviteLink(id: $id, token: $token, url: $url, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $InviteLinkCopyWith<$Res>  {
  factory $InviteLinkCopyWith(InviteLink value, $Res Function(InviteLink) _then) = _$InviteLinkCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'invite_id') String id,@JsonKey(name: 'token') String token,@JsonKey(name: 'invite_url') String url,@JsonKey(name: 'expires_at') DateTime expiresAt
});




}
/// @nodoc
class _$InviteLinkCopyWithImpl<$Res>
    implements $InviteLinkCopyWith<$Res> {
  _$InviteLinkCopyWithImpl(this._self, this._then);

  final InviteLink _self;
  final $Res Function(InviteLink) _then;

/// Create a copy of InviteLink
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? token = null,Object? url = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [InviteLink].
extension InviteLinkPatterns on InviteLink {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InviteLink value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InviteLink() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InviteLink value)  $default,){
final _that = this;
switch (_that) {
case _InviteLink():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InviteLink value)?  $default,){
final _that = this;
switch (_that) {
case _InviteLink() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'invite_id')  String id, @JsonKey(name: 'token')  String token, @JsonKey(name: 'invite_url')  String url, @JsonKey(name: 'expires_at')  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InviteLink() when $default != null:
return $default(_that.id,_that.token,_that.url,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'invite_id')  String id, @JsonKey(name: 'token')  String token, @JsonKey(name: 'invite_url')  String url, @JsonKey(name: 'expires_at')  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _InviteLink():
return $default(_that.id,_that.token,_that.url,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'invite_id')  String id, @JsonKey(name: 'token')  String token, @JsonKey(name: 'invite_url')  String url, @JsonKey(name: 'expires_at')  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _InviteLink() when $default != null:
return $default(_that.id,_that.token,_that.url,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InviteLink implements InviteLink {
  const _InviteLink({@JsonKey(name: 'invite_id') required this.id, @JsonKey(name: 'token') required this.token, @JsonKey(name: 'invite_url') required this.url, @JsonKey(name: 'expires_at') required this.expiresAt});
  factory _InviteLink.fromJson(Map<String, dynamic> json) => _$InviteLinkFromJson(json);

@override@JsonKey(name: 'invite_id') final  String id;
@override@JsonKey(name: 'token') final  String token;
@override@JsonKey(name: 'invite_url') final  String url;
@override@JsonKey(name: 'expires_at') final  DateTime expiresAt;

/// Create a copy of InviteLink
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InviteLinkCopyWith<_InviteLink> get copyWith => __$InviteLinkCopyWithImpl<_InviteLink>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InviteLinkToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InviteLink&&(identical(other.id, id) || other.id == id)&&(identical(other.token, token) || other.token == token)&&(identical(other.url, url) || other.url == url)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,token,url,expiresAt);

@override
String toString() {
  return 'InviteLink(id: $id, token: $token, url: $url, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$InviteLinkCopyWith<$Res> implements $InviteLinkCopyWith<$Res> {
  factory _$InviteLinkCopyWith(_InviteLink value, $Res Function(_InviteLink) _then) = __$InviteLinkCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'invite_id') String id,@JsonKey(name: 'token') String token,@JsonKey(name: 'invite_url') String url,@JsonKey(name: 'expires_at') DateTime expiresAt
});




}
/// @nodoc
class __$InviteLinkCopyWithImpl<$Res>
    implements _$InviteLinkCopyWith<$Res> {
  __$InviteLinkCopyWithImpl(this._self, this._then);

  final _InviteLink _self;
  final $Res Function(_InviteLink) _then;

/// Create a copy of InviteLink
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? token = null,Object? url = null,Object? expiresAt = null,}) {
  return _then(_InviteLink(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
