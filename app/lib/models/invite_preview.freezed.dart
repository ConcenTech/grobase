// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invite_preview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InvitePreview implements DiagnosticableTreeMixin {

@JsonKey(name: 'status') InviteStatus get status;@JsonKey(name: 'invited_by_email') String? get invitedByEmail;@JsonKey(name: 'inverter_display_name') String? get inverterName;@JsonKey(name: 'expires_at') DateTime get expiresAt;
/// Create a copy of InvitePreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvitePreviewCopyWith<InvitePreview> get copyWith => _$InvitePreviewCopyWithImpl<InvitePreview>(this as InvitePreview, _$identity);

  /// Serializes this InvitePreview to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'InvitePreview'))
    ..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('invitedByEmail', invitedByEmail))..add(DiagnosticsProperty('inverterName', inverterName))..add(DiagnosticsProperty('expiresAt', expiresAt));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvitePreview&&(identical(other.status, status) || other.status == status)&&(identical(other.invitedByEmail, invitedByEmail) || other.invitedByEmail == invitedByEmail)&&(identical(other.inverterName, inverterName) || other.inverterName == inverterName)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,invitedByEmail,inverterName,expiresAt);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'InvitePreview(status: $status, invitedByEmail: $invitedByEmail, inverterName: $inverterName, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $InvitePreviewCopyWith<$Res>  {
  factory $InvitePreviewCopyWith(InvitePreview value, $Res Function(InvitePreview) _then) = _$InvitePreviewCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'status') InviteStatus status,@JsonKey(name: 'invited_by_email') String? invitedByEmail,@JsonKey(name: 'inverter_display_name') String? inverterName,@JsonKey(name: 'expires_at') DateTime expiresAt
});




}
/// @nodoc
class _$InvitePreviewCopyWithImpl<$Res>
    implements $InvitePreviewCopyWith<$Res> {
  _$InvitePreviewCopyWithImpl(this._self, this._then);

  final InvitePreview _self;
  final $Res Function(InvitePreview) _then;

/// Create a copy of InvitePreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? invitedByEmail = freezed,Object? inverterName = freezed,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InviteStatus,invitedByEmail: freezed == invitedByEmail ? _self.invitedByEmail : invitedByEmail // ignore: cast_nullable_to_non_nullable
as String?,inverterName: freezed == inverterName ? _self.inverterName : inverterName // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [InvitePreview].
extension InvitePreviewPatterns on InvitePreview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvitePreview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvitePreview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvitePreview value)  $default,){
final _that = this;
switch (_that) {
case _InvitePreview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvitePreview value)?  $default,){
final _that = this;
switch (_that) {
case _InvitePreview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'status')  InviteStatus status, @JsonKey(name: 'invited_by_email')  String? invitedByEmail, @JsonKey(name: 'inverter_display_name')  String? inverterName, @JsonKey(name: 'expires_at')  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvitePreview() when $default != null:
return $default(_that.status,_that.invitedByEmail,_that.inverterName,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'status')  InviteStatus status, @JsonKey(name: 'invited_by_email')  String? invitedByEmail, @JsonKey(name: 'inverter_display_name')  String? inverterName, @JsonKey(name: 'expires_at')  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _InvitePreview():
return $default(_that.status,_that.invitedByEmail,_that.inverterName,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'status')  InviteStatus status, @JsonKey(name: 'invited_by_email')  String? invitedByEmail, @JsonKey(name: 'inverter_display_name')  String? inverterName, @JsonKey(name: 'expires_at')  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _InvitePreview() when $default != null:
return $default(_that.status,_that.invitedByEmail,_that.inverterName,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InvitePreview with DiagnosticableTreeMixin implements InvitePreview {
  const _InvitePreview({@JsonKey(name: 'status') required this.status, @JsonKey(name: 'invited_by_email') this.invitedByEmail, @JsonKey(name: 'inverter_display_name') this.inverterName, @JsonKey(name: 'expires_at') required this.expiresAt});
  factory _InvitePreview.fromJson(Map<String, dynamic> json) => _$InvitePreviewFromJson(json);

@override@JsonKey(name: 'status') final  InviteStatus status;
@override@JsonKey(name: 'invited_by_email') final  String? invitedByEmail;
@override@JsonKey(name: 'inverter_display_name') final  String? inverterName;
@override@JsonKey(name: 'expires_at') final  DateTime expiresAt;

/// Create a copy of InvitePreview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvitePreviewCopyWith<_InvitePreview> get copyWith => __$InvitePreviewCopyWithImpl<_InvitePreview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvitePreviewToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'InvitePreview'))
    ..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('invitedByEmail', invitedByEmail))..add(DiagnosticsProperty('inverterName', inverterName))..add(DiagnosticsProperty('expiresAt', expiresAt));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvitePreview&&(identical(other.status, status) || other.status == status)&&(identical(other.invitedByEmail, invitedByEmail) || other.invitedByEmail == invitedByEmail)&&(identical(other.inverterName, inverterName) || other.inverterName == inverterName)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,invitedByEmail,inverterName,expiresAt);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'InvitePreview(status: $status, invitedByEmail: $invitedByEmail, inverterName: $inverterName, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$InvitePreviewCopyWith<$Res> implements $InvitePreviewCopyWith<$Res> {
  factory _$InvitePreviewCopyWith(_InvitePreview value, $Res Function(_InvitePreview) _then) = __$InvitePreviewCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'status') InviteStatus status,@JsonKey(name: 'invited_by_email') String? invitedByEmail,@JsonKey(name: 'inverter_display_name') String? inverterName,@JsonKey(name: 'expires_at') DateTime expiresAt
});




}
/// @nodoc
class __$InvitePreviewCopyWithImpl<$Res>
    implements _$InvitePreviewCopyWith<$Res> {
  __$InvitePreviewCopyWithImpl(this._self, this._then);

  final _InvitePreview _self;
  final $Res Function(_InvitePreview) _then;

/// Create a copy of InvitePreview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? invitedByEmail = freezed,Object? inverterName = freezed,Object? expiresAt = null,}) {
  return _then(_InvitePreview(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InviteStatus,invitedByEmail: freezed == invitedByEmail ? _self.invitedByEmail : invitedByEmail // ignore: cast_nullable_to_non_nullable
as String?,inverterName: freezed == inverterName ? _self.inverterName : inverterName // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
