// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inverter_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InverterSnapshot implements DiagnosticableTreeMixin {

 int get id;@JsonKey(name: 'inverter_id') String get inverterId;@JsonKey(name: 'gateway_id') String get gatewayId;@JsonKey(name: 'recorded_at') DateTime get recordedAt;@JsonKey(name: 'ingested_at') DateTime get ingestedAt;@JsonKey(name: 'battery_soc_percent') double get batteryStateOfCharge;@JsonKey(name: 'battery_voltage_v') double get batteryVoltage;@JsonKey(name: 'battery_current_a') double get batteryCurrent;@JsonKey(name: 'battery_charge_power_w') double get chargePower;@JsonKey(name: 'battery_discharge_power_w') double get dischargePower;@JsonKey(name: 'battery_charge_energy_today_kwh') double get chargeEnergyToday;@JsonKey(name: 'battery_discharge_energy_today_kwh') double get dischargeEnergyToday;@JsonKey(name: 'grid_active_power_w') double get gridActivePower;@JsonKey(name: 'grid_frequency_hz') double get gridFrequency;@JsonKey(name: 'grid_voltage_v') double get gridVoltage;@JsonKey(name: 'grid_current_a') double get gridCurrent;@JsonKey(name: 'grid_export_power_w') double get gridExportPower;@JsonKey(name: 'grid_export_energy_today_kwh') double get gridExportEnergyToday;@JsonKey(name: 'grid_import_energy_today_kwh') double get gridImportEnergyToday;@JsonKey(name: 'grid_charge_power_w') double get gridChargePower;@JsonKey(name: 'solar_energy_today_kwh') double get solarEnergyToday;@JsonKey(name: 'solar_power_w') double get solarPower;@JsonKey(name: 'home_load_power_w') double get homeLoadPower;
/// Create a copy of InverterSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InverterSnapshotCopyWith<InverterSnapshot> get copyWith => _$InverterSnapshotCopyWithImpl<InverterSnapshot>(this as InverterSnapshot, _$identity);

  /// Serializes this InverterSnapshot to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'InverterSnapshot'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('inverterId', inverterId))..add(DiagnosticsProperty('gatewayId', gatewayId))..add(DiagnosticsProperty('recordedAt', recordedAt))..add(DiagnosticsProperty('ingestedAt', ingestedAt))..add(DiagnosticsProperty('batteryStateOfCharge', batteryStateOfCharge))..add(DiagnosticsProperty('batteryVoltage', batteryVoltage))..add(DiagnosticsProperty('batteryCurrent', batteryCurrent))..add(DiagnosticsProperty('chargePower', chargePower))..add(DiagnosticsProperty('dischargePower', dischargePower))..add(DiagnosticsProperty('chargeEnergyToday', chargeEnergyToday))..add(DiagnosticsProperty('dischargeEnergyToday', dischargeEnergyToday))..add(DiagnosticsProperty('gridActivePower', gridActivePower))..add(DiagnosticsProperty('gridFrequency', gridFrequency))..add(DiagnosticsProperty('gridVoltage', gridVoltage))..add(DiagnosticsProperty('gridCurrent', gridCurrent))..add(DiagnosticsProperty('gridExportPower', gridExportPower))..add(DiagnosticsProperty('gridExportEnergyToday', gridExportEnergyToday))..add(DiagnosticsProperty('gridImportEnergyToday', gridImportEnergyToday))..add(DiagnosticsProperty('gridChargePower', gridChargePower))..add(DiagnosticsProperty('solarEnergyToday', solarEnergyToday))..add(DiagnosticsProperty('solarPower', solarPower))..add(DiagnosticsProperty('homeLoadPower', homeLoadPower));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InverterSnapshot&&(identical(other.id, id) || other.id == id)&&(identical(other.inverterId, inverterId) || other.inverterId == inverterId)&&(identical(other.gatewayId, gatewayId) || other.gatewayId == gatewayId)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.ingestedAt, ingestedAt) || other.ingestedAt == ingestedAt)&&(identical(other.batteryStateOfCharge, batteryStateOfCharge) || other.batteryStateOfCharge == batteryStateOfCharge)&&(identical(other.batteryVoltage, batteryVoltage) || other.batteryVoltage == batteryVoltage)&&(identical(other.batteryCurrent, batteryCurrent) || other.batteryCurrent == batteryCurrent)&&(identical(other.chargePower, chargePower) || other.chargePower == chargePower)&&(identical(other.dischargePower, dischargePower) || other.dischargePower == dischargePower)&&(identical(other.chargeEnergyToday, chargeEnergyToday) || other.chargeEnergyToday == chargeEnergyToday)&&(identical(other.dischargeEnergyToday, dischargeEnergyToday) || other.dischargeEnergyToday == dischargeEnergyToday)&&(identical(other.gridActivePower, gridActivePower) || other.gridActivePower == gridActivePower)&&(identical(other.gridFrequency, gridFrequency) || other.gridFrequency == gridFrequency)&&(identical(other.gridVoltage, gridVoltage) || other.gridVoltage == gridVoltage)&&(identical(other.gridCurrent, gridCurrent) || other.gridCurrent == gridCurrent)&&(identical(other.gridExportPower, gridExportPower) || other.gridExportPower == gridExportPower)&&(identical(other.gridExportEnergyToday, gridExportEnergyToday) || other.gridExportEnergyToday == gridExportEnergyToday)&&(identical(other.gridImportEnergyToday, gridImportEnergyToday) || other.gridImportEnergyToday == gridImportEnergyToday)&&(identical(other.gridChargePower, gridChargePower) || other.gridChargePower == gridChargePower)&&(identical(other.solarEnergyToday, solarEnergyToday) || other.solarEnergyToday == solarEnergyToday)&&(identical(other.solarPower, solarPower) || other.solarPower == solarPower)&&(identical(other.homeLoadPower, homeLoadPower) || other.homeLoadPower == homeLoadPower));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,inverterId,gatewayId,recordedAt,ingestedAt,batteryStateOfCharge,batteryVoltage,batteryCurrent,chargePower,dischargePower,chargeEnergyToday,dischargeEnergyToday,gridActivePower,gridFrequency,gridVoltage,gridCurrent,gridExportPower,gridExportEnergyToday,gridImportEnergyToday,gridChargePower,solarEnergyToday,solarPower,homeLoadPower]);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'InverterSnapshot(id: $id, inverterId: $inverterId, gatewayId: $gatewayId, recordedAt: $recordedAt, ingestedAt: $ingestedAt, batteryStateOfCharge: $batteryStateOfCharge, batteryVoltage: $batteryVoltage, batteryCurrent: $batteryCurrent, chargePower: $chargePower, dischargePower: $dischargePower, chargeEnergyToday: $chargeEnergyToday, dischargeEnergyToday: $dischargeEnergyToday, gridActivePower: $gridActivePower, gridFrequency: $gridFrequency, gridVoltage: $gridVoltage, gridCurrent: $gridCurrent, gridExportPower: $gridExportPower, gridExportEnergyToday: $gridExportEnergyToday, gridImportEnergyToday: $gridImportEnergyToday, gridChargePower: $gridChargePower, solarEnergyToday: $solarEnergyToday, solarPower: $solarPower, homeLoadPower: $homeLoadPower)';
}


}

/// @nodoc
abstract mixin class $InverterSnapshotCopyWith<$Res>  {
  factory $InverterSnapshotCopyWith(InverterSnapshot value, $Res Function(InverterSnapshot) _then) = _$InverterSnapshotCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'inverter_id') String inverterId,@JsonKey(name: 'gateway_id') String gatewayId,@JsonKey(name: 'recorded_at') DateTime recordedAt,@JsonKey(name: 'ingested_at') DateTime ingestedAt,@JsonKey(name: 'battery_soc_percent') double batteryStateOfCharge,@JsonKey(name: 'battery_voltage_v') double batteryVoltage,@JsonKey(name: 'battery_current_a') double batteryCurrent,@JsonKey(name: 'battery_charge_power_w') double chargePower,@JsonKey(name: 'battery_discharge_power_w') double dischargePower,@JsonKey(name: 'battery_charge_energy_today_kwh') double chargeEnergyToday,@JsonKey(name: 'battery_discharge_energy_today_kwh') double dischargeEnergyToday,@JsonKey(name: 'grid_active_power_w') double gridActivePower,@JsonKey(name: 'grid_frequency_hz') double gridFrequency,@JsonKey(name: 'grid_voltage_v') double gridVoltage,@JsonKey(name: 'grid_current_a') double gridCurrent,@JsonKey(name: 'grid_export_power_w') double gridExportPower,@JsonKey(name: 'grid_export_energy_today_kwh') double gridExportEnergyToday,@JsonKey(name: 'grid_import_energy_today_kwh') double gridImportEnergyToday,@JsonKey(name: 'grid_charge_power_w') double gridChargePower,@JsonKey(name: 'solar_energy_today_kwh') double solarEnergyToday,@JsonKey(name: 'solar_power_w') double solarPower,@JsonKey(name: 'home_load_power_w') double homeLoadPower
});




}
/// @nodoc
class _$InverterSnapshotCopyWithImpl<$Res>
    implements $InverterSnapshotCopyWith<$Res> {
  _$InverterSnapshotCopyWithImpl(this._self, this._then);

  final InverterSnapshot _self;
  final $Res Function(InverterSnapshot) _then;

/// Create a copy of InverterSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? inverterId = null,Object? gatewayId = null,Object? recordedAt = null,Object? ingestedAt = null,Object? batteryStateOfCharge = null,Object? batteryVoltage = null,Object? batteryCurrent = null,Object? chargePower = null,Object? dischargePower = null,Object? chargeEnergyToday = null,Object? dischargeEnergyToday = null,Object? gridActivePower = null,Object? gridFrequency = null,Object? gridVoltage = null,Object? gridCurrent = null,Object? gridExportPower = null,Object? gridExportEnergyToday = null,Object? gridImportEnergyToday = null,Object? gridChargePower = null,Object? solarEnergyToday = null,Object? solarPower = null,Object? homeLoadPower = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,inverterId: null == inverterId ? _self.inverterId : inverterId // ignore: cast_nullable_to_non_nullable
as String,gatewayId: null == gatewayId ? _self.gatewayId : gatewayId // ignore: cast_nullable_to_non_nullable
as String,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,ingestedAt: null == ingestedAt ? _self.ingestedAt : ingestedAt // ignore: cast_nullable_to_non_nullable
as DateTime,batteryStateOfCharge: null == batteryStateOfCharge ? _self.batteryStateOfCharge : batteryStateOfCharge // ignore: cast_nullable_to_non_nullable
as double,batteryVoltage: null == batteryVoltage ? _self.batteryVoltage : batteryVoltage // ignore: cast_nullable_to_non_nullable
as double,batteryCurrent: null == batteryCurrent ? _self.batteryCurrent : batteryCurrent // ignore: cast_nullable_to_non_nullable
as double,chargePower: null == chargePower ? _self.chargePower : chargePower // ignore: cast_nullable_to_non_nullable
as double,dischargePower: null == dischargePower ? _self.dischargePower : dischargePower // ignore: cast_nullable_to_non_nullable
as double,chargeEnergyToday: null == chargeEnergyToday ? _self.chargeEnergyToday : chargeEnergyToday // ignore: cast_nullable_to_non_nullable
as double,dischargeEnergyToday: null == dischargeEnergyToday ? _self.dischargeEnergyToday : dischargeEnergyToday // ignore: cast_nullable_to_non_nullable
as double,gridActivePower: null == gridActivePower ? _self.gridActivePower : gridActivePower // ignore: cast_nullable_to_non_nullable
as double,gridFrequency: null == gridFrequency ? _self.gridFrequency : gridFrequency // ignore: cast_nullable_to_non_nullable
as double,gridVoltage: null == gridVoltage ? _self.gridVoltage : gridVoltage // ignore: cast_nullable_to_non_nullable
as double,gridCurrent: null == gridCurrent ? _self.gridCurrent : gridCurrent // ignore: cast_nullable_to_non_nullable
as double,gridExportPower: null == gridExportPower ? _self.gridExportPower : gridExportPower // ignore: cast_nullable_to_non_nullable
as double,gridExportEnergyToday: null == gridExportEnergyToday ? _self.gridExportEnergyToday : gridExportEnergyToday // ignore: cast_nullable_to_non_nullable
as double,gridImportEnergyToday: null == gridImportEnergyToday ? _self.gridImportEnergyToday : gridImportEnergyToday // ignore: cast_nullable_to_non_nullable
as double,gridChargePower: null == gridChargePower ? _self.gridChargePower : gridChargePower // ignore: cast_nullable_to_non_nullable
as double,solarEnergyToday: null == solarEnergyToday ? _self.solarEnergyToday : solarEnergyToday // ignore: cast_nullable_to_non_nullable
as double,solarPower: null == solarPower ? _self.solarPower : solarPower // ignore: cast_nullable_to_non_nullable
as double,homeLoadPower: null == homeLoadPower ? _self.homeLoadPower : homeLoadPower // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [InverterSnapshot].
extension InverterSnapshotPatterns on InverterSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InverterSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InverterSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InverterSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _InverterSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InverterSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _InverterSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'inverter_id')  String inverterId, @JsonKey(name: 'gateway_id')  String gatewayId, @JsonKey(name: 'recorded_at')  DateTime recordedAt, @JsonKey(name: 'ingested_at')  DateTime ingestedAt, @JsonKey(name: 'battery_soc_percent')  double batteryStateOfCharge, @JsonKey(name: 'battery_voltage_v')  double batteryVoltage, @JsonKey(name: 'battery_current_a')  double batteryCurrent, @JsonKey(name: 'battery_charge_power_w')  double chargePower, @JsonKey(name: 'battery_discharge_power_w')  double dischargePower, @JsonKey(name: 'battery_charge_energy_today_kwh')  double chargeEnergyToday, @JsonKey(name: 'battery_discharge_energy_today_kwh')  double dischargeEnergyToday, @JsonKey(name: 'grid_active_power_w')  double gridActivePower, @JsonKey(name: 'grid_frequency_hz')  double gridFrequency, @JsonKey(name: 'grid_voltage_v')  double gridVoltage, @JsonKey(name: 'grid_current_a')  double gridCurrent, @JsonKey(name: 'grid_export_power_w')  double gridExportPower, @JsonKey(name: 'grid_export_energy_today_kwh')  double gridExportEnergyToday, @JsonKey(name: 'grid_import_energy_today_kwh')  double gridImportEnergyToday, @JsonKey(name: 'grid_charge_power_w')  double gridChargePower, @JsonKey(name: 'solar_energy_today_kwh')  double solarEnergyToday, @JsonKey(name: 'solar_power_w')  double solarPower, @JsonKey(name: 'home_load_power_w')  double homeLoadPower)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InverterSnapshot() when $default != null:
return $default(_that.id,_that.inverterId,_that.gatewayId,_that.recordedAt,_that.ingestedAt,_that.batteryStateOfCharge,_that.batteryVoltage,_that.batteryCurrent,_that.chargePower,_that.dischargePower,_that.chargeEnergyToday,_that.dischargeEnergyToday,_that.gridActivePower,_that.gridFrequency,_that.gridVoltage,_that.gridCurrent,_that.gridExportPower,_that.gridExportEnergyToday,_that.gridImportEnergyToday,_that.gridChargePower,_that.solarEnergyToday,_that.solarPower,_that.homeLoadPower);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'inverter_id')  String inverterId, @JsonKey(name: 'gateway_id')  String gatewayId, @JsonKey(name: 'recorded_at')  DateTime recordedAt, @JsonKey(name: 'ingested_at')  DateTime ingestedAt, @JsonKey(name: 'battery_soc_percent')  double batteryStateOfCharge, @JsonKey(name: 'battery_voltage_v')  double batteryVoltage, @JsonKey(name: 'battery_current_a')  double batteryCurrent, @JsonKey(name: 'battery_charge_power_w')  double chargePower, @JsonKey(name: 'battery_discharge_power_w')  double dischargePower, @JsonKey(name: 'battery_charge_energy_today_kwh')  double chargeEnergyToday, @JsonKey(name: 'battery_discharge_energy_today_kwh')  double dischargeEnergyToday, @JsonKey(name: 'grid_active_power_w')  double gridActivePower, @JsonKey(name: 'grid_frequency_hz')  double gridFrequency, @JsonKey(name: 'grid_voltage_v')  double gridVoltage, @JsonKey(name: 'grid_current_a')  double gridCurrent, @JsonKey(name: 'grid_export_power_w')  double gridExportPower, @JsonKey(name: 'grid_export_energy_today_kwh')  double gridExportEnergyToday, @JsonKey(name: 'grid_import_energy_today_kwh')  double gridImportEnergyToday, @JsonKey(name: 'grid_charge_power_w')  double gridChargePower, @JsonKey(name: 'solar_energy_today_kwh')  double solarEnergyToday, @JsonKey(name: 'solar_power_w')  double solarPower, @JsonKey(name: 'home_load_power_w')  double homeLoadPower)  $default,) {final _that = this;
switch (_that) {
case _InverterSnapshot():
return $default(_that.id,_that.inverterId,_that.gatewayId,_that.recordedAt,_that.ingestedAt,_that.batteryStateOfCharge,_that.batteryVoltage,_that.batteryCurrent,_that.chargePower,_that.dischargePower,_that.chargeEnergyToday,_that.dischargeEnergyToday,_that.gridActivePower,_that.gridFrequency,_that.gridVoltage,_that.gridCurrent,_that.gridExportPower,_that.gridExportEnergyToday,_that.gridImportEnergyToday,_that.gridChargePower,_that.solarEnergyToday,_that.solarPower,_that.homeLoadPower);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'inverter_id')  String inverterId, @JsonKey(name: 'gateway_id')  String gatewayId, @JsonKey(name: 'recorded_at')  DateTime recordedAt, @JsonKey(name: 'ingested_at')  DateTime ingestedAt, @JsonKey(name: 'battery_soc_percent')  double batteryStateOfCharge, @JsonKey(name: 'battery_voltage_v')  double batteryVoltage, @JsonKey(name: 'battery_current_a')  double batteryCurrent, @JsonKey(name: 'battery_charge_power_w')  double chargePower, @JsonKey(name: 'battery_discharge_power_w')  double dischargePower, @JsonKey(name: 'battery_charge_energy_today_kwh')  double chargeEnergyToday, @JsonKey(name: 'battery_discharge_energy_today_kwh')  double dischargeEnergyToday, @JsonKey(name: 'grid_active_power_w')  double gridActivePower, @JsonKey(name: 'grid_frequency_hz')  double gridFrequency, @JsonKey(name: 'grid_voltage_v')  double gridVoltage, @JsonKey(name: 'grid_current_a')  double gridCurrent, @JsonKey(name: 'grid_export_power_w')  double gridExportPower, @JsonKey(name: 'grid_export_energy_today_kwh')  double gridExportEnergyToday, @JsonKey(name: 'grid_import_energy_today_kwh')  double gridImportEnergyToday, @JsonKey(name: 'grid_charge_power_w')  double gridChargePower, @JsonKey(name: 'solar_energy_today_kwh')  double solarEnergyToday, @JsonKey(name: 'solar_power_w')  double solarPower, @JsonKey(name: 'home_load_power_w')  double homeLoadPower)?  $default,) {final _that = this;
switch (_that) {
case _InverterSnapshot() when $default != null:
return $default(_that.id,_that.inverterId,_that.gatewayId,_that.recordedAt,_that.ingestedAt,_that.batteryStateOfCharge,_that.batteryVoltage,_that.batteryCurrent,_that.chargePower,_that.dischargePower,_that.chargeEnergyToday,_that.dischargeEnergyToday,_that.gridActivePower,_that.gridFrequency,_that.gridVoltage,_that.gridCurrent,_that.gridExportPower,_that.gridExportEnergyToday,_that.gridImportEnergyToday,_that.gridChargePower,_that.solarEnergyToday,_that.solarPower,_that.homeLoadPower);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InverterSnapshot with DiagnosticableTreeMixin implements InverterSnapshot {
  const _InverterSnapshot({required this.id, @JsonKey(name: 'inverter_id') required this.inverterId, @JsonKey(name: 'gateway_id') required this.gatewayId, @JsonKey(name: 'recorded_at') required this.recordedAt, @JsonKey(name: 'ingested_at') required this.ingestedAt, @JsonKey(name: 'battery_soc_percent') required this.batteryStateOfCharge, @JsonKey(name: 'battery_voltage_v') required this.batteryVoltage, @JsonKey(name: 'battery_current_a') required this.batteryCurrent, @JsonKey(name: 'battery_charge_power_w') required this.chargePower, @JsonKey(name: 'battery_discharge_power_w') required this.dischargePower, @JsonKey(name: 'battery_charge_energy_today_kwh') required this.chargeEnergyToday, @JsonKey(name: 'battery_discharge_energy_today_kwh') required this.dischargeEnergyToday, @JsonKey(name: 'grid_active_power_w') required this.gridActivePower, @JsonKey(name: 'grid_frequency_hz') required this.gridFrequency, @JsonKey(name: 'grid_voltage_v') required this.gridVoltage, @JsonKey(name: 'grid_current_a') required this.gridCurrent, @JsonKey(name: 'grid_export_power_w') required this.gridExportPower, @JsonKey(name: 'grid_export_energy_today_kwh') required this.gridExportEnergyToday, @JsonKey(name: 'grid_import_energy_today_kwh') required this.gridImportEnergyToday, @JsonKey(name: 'grid_charge_power_w') required this.gridChargePower, @JsonKey(name: 'solar_energy_today_kwh') required this.solarEnergyToday, @JsonKey(name: 'solar_power_w') required this.solarPower, @JsonKey(name: 'home_load_power_w') required this.homeLoadPower});
  factory _InverterSnapshot.fromJson(Map<String, dynamic> json) => _$InverterSnapshotFromJson(json);

@override final  int id;
@override@JsonKey(name: 'inverter_id') final  String inverterId;
@override@JsonKey(name: 'gateway_id') final  String gatewayId;
@override@JsonKey(name: 'recorded_at') final  DateTime recordedAt;
@override@JsonKey(name: 'ingested_at') final  DateTime ingestedAt;
@override@JsonKey(name: 'battery_soc_percent') final  double batteryStateOfCharge;
@override@JsonKey(name: 'battery_voltage_v') final  double batteryVoltage;
@override@JsonKey(name: 'battery_current_a') final  double batteryCurrent;
@override@JsonKey(name: 'battery_charge_power_w') final  double chargePower;
@override@JsonKey(name: 'battery_discharge_power_w') final  double dischargePower;
@override@JsonKey(name: 'battery_charge_energy_today_kwh') final  double chargeEnergyToday;
@override@JsonKey(name: 'battery_discharge_energy_today_kwh') final  double dischargeEnergyToday;
@override@JsonKey(name: 'grid_active_power_w') final  double gridActivePower;
@override@JsonKey(name: 'grid_frequency_hz') final  double gridFrequency;
@override@JsonKey(name: 'grid_voltage_v') final  double gridVoltage;
@override@JsonKey(name: 'grid_current_a') final  double gridCurrent;
@override@JsonKey(name: 'grid_export_power_w') final  double gridExportPower;
@override@JsonKey(name: 'grid_export_energy_today_kwh') final  double gridExportEnergyToday;
@override@JsonKey(name: 'grid_import_energy_today_kwh') final  double gridImportEnergyToday;
@override@JsonKey(name: 'grid_charge_power_w') final  double gridChargePower;
@override@JsonKey(name: 'solar_energy_today_kwh') final  double solarEnergyToday;
@override@JsonKey(name: 'solar_power_w') final  double solarPower;
@override@JsonKey(name: 'home_load_power_w') final  double homeLoadPower;

/// Create a copy of InverterSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InverterSnapshotCopyWith<_InverterSnapshot> get copyWith => __$InverterSnapshotCopyWithImpl<_InverterSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InverterSnapshotToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'InverterSnapshot'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('inverterId', inverterId))..add(DiagnosticsProperty('gatewayId', gatewayId))..add(DiagnosticsProperty('recordedAt', recordedAt))..add(DiagnosticsProperty('ingestedAt', ingestedAt))..add(DiagnosticsProperty('batteryStateOfCharge', batteryStateOfCharge))..add(DiagnosticsProperty('batteryVoltage', batteryVoltage))..add(DiagnosticsProperty('batteryCurrent', batteryCurrent))..add(DiagnosticsProperty('chargePower', chargePower))..add(DiagnosticsProperty('dischargePower', dischargePower))..add(DiagnosticsProperty('chargeEnergyToday', chargeEnergyToday))..add(DiagnosticsProperty('dischargeEnergyToday', dischargeEnergyToday))..add(DiagnosticsProperty('gridActivePower', gridActivePower))..add(DiagnosticsProperty('gridFrequency', gridFrequency))..add(DiagnosticsProperty('gridVoltage', gridVoltage))..add(DiagnosticsProperty('gridCurrent', gridCurrent))..add(DiagnosticsProperty('gridExportPower', gridExportPower))..add(DiagnosticsProperty('gridExportEnergyToday', gridExportEnergyToday))..add(DiagnosticsProperty('gridImportEnergyToday', gridImportEnergyToday))..add(DiagnosticsProperty('gridChargePower', gridChargePower))..add(DiagnosticsProperty('solarEnergyToday', solarEnergyToday))..add(DiagnosticsProperty('solarPower', solarPower))..add(DiagnosticsProperty('homeLoadPower', homeLoadPower));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InverterSnapshot&&(identical(other.id, id) || other.id == id)&&(identical(other.inverterId, inverterId) || other.inverterId == inverterId)&&(identical(other.gatewayId, gatewayId) || other.gatewayId == gatewayId)&&(identical(other.recordedAt, recordedAt) || other.recordedAt == recordedAt)&&(identical(other.ingestedAt, ingestedAt) || other.ingestedAt == ingestedAt)&&(identical(other.batteryStateOfCharge, batteryStateOfCharge) || other.batteryStateOfCharge == batteryStateOfCharge)&&(identical(other.batteryVoltage, batteryVoltage) || other.batteryVoltage == batteryVoltage)&&(identical(other.batteryCurrent, batteryCurrent) || other.batteryCurrent == batteryCurrent)&&(identical(other.chargePower, chargePower) || other.chargePower == chargePower)&&(identical(other.dischargePower, dischargePower) || other.dischargePower == dischargePower)&&(identical(other.chargeEnergyToday, chargeEnergyToday) || other.chargeEnergyToday == chargeEnergyToday)&&(identical(other.dischargeEnergyToday, dischargeEnergyToday) || other.dischargeEnergyToday == dischargeEnergyToday)&&(identical(other.gridActivePower, gridActivePower) || other.gridActivePower == gridActivePower)&&(identical(other.gridFrequency, gridFrequency) || other.gridFrequency == gridFrequency)&&(identical(other.gridVoltage, gridVoltage) || other.gridVoltage == gridVoltage)&&(identical(other.gridCurrent, gridCurrent) || other.gridCurrent == gridCurrent)&&(identical(other.gridExportPower, gridExportPower) || other.gridExportPower == gridExportPower)&&(identical(other.gridExportEnergyToday, gridExportEnergyToday) || other.gridExportEnergyToday == gridExportEnergyToday)&&(identical(other.gridImportEnergyToday, gridImportEnergyToday) || other.gridImportEnergyToday == gridImportEnergyToday)&&(identical(other.gridChargePower, gridChargePower) || other.gridChargePower == gridChargePower)&&(identical(other.solarEnergyToday, solarEnergyToday) || other.solarEnergyToday == solarEnergyToday)&&(identical(other.solarPower, solarPower) || other.solarPower == solarPower)&&(identical(other.homeLoadPower, homeLoadPower) || other.homeLoadPower == homeLoadPower));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,inverterId,gatewayId,recordedAt,ingestedAt,batteryStateOfCharge,batteryVoltage,batteryCurrent,chargePower,dischargePower,chargeEnergyToday,dischargeEnergyToday,gridActivePower,gridFrequency,gridVoltage,gridCurrent,gridExportPower,gridExportEnergyToday,gridImportEnergyToday,gridChargePower,solarEnergyToday,solarPower,homeLoadPower]);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'InverterSnapshot(id: $id, inverterId: $inverterId, gatewayId: $gatewayId, recordedAt: $recordedAt, ingestedAt: $ingestedAt, batteryStateOfCharge: $batteryStateOfCharge, batteryVoltage: $batteryVoltage, batteryCurrent: $batteryCurrent, chargePower: $chargePower, dischargePower: $dischargePower, chargeEnergyToday: $chargeEnergyToday, dischargeEnergyToday: $dischargeEnergyToday, gridActivePower: $gridActivePower, gridFrequency: $gridFrequency, gridVoltage: $gridVoltage, gridCurrent: $gridCurrent, gridExportPower: $gridExportPower, gridExportEnergyToday: $gridExportEnergyToday, gridImportEnergyToday: $gridImportEnergyToday, gridChargePower: $gridChargePower, solarEnergyToday: $solarEnergyToday, solarPower: $solarPower, homeLoadPower: $homeLoadPower)';
}


}

/// @nodoc
abstract mixin class _$InverterSnapshotCopyWith<$Res> implements $InverterSnapshotCopyWith<$Res> {
  factory _$InverterSnapshotCopyWith(_InverterSnapshot value, $Res Function(_InverterSnapshot) _then) = __$InverterSnapshotCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'inverter_id') String inverterId,@JsonKey(name: 'gateway_id') String gatewayId,@JsonKey(name: 'recorded_at') DateTime recordedAt,@JsonKey(name: 'ingested_at') DateTime ingestedAt,@JsonKey(name: 'battery_soc_percent') double batteryStateOfCharge,@JsonKey(name: 'battery_voltage_v') double batteryVoltage,@JsonKey(name: 'battery_current_a') double batteryCurrent,@JsonKey(name: 'battery_charge_power_w') double chargePower,@JsonKey(name: 'battery_discharge_power_w') double dischargePower,@JsonKey(name: 'battery_charge_energy_today_kwh') double chargeEnergyToday,@JsonKey(name: 'battery_discharge_energy_today_kwh') double dischargeEnergyToday,@JsonKey(name: 'grid_active_power_w') double gridActivePower,@JsonKey(name: 'grid_frequency_hz') double gridFrequency,@JsonKey(name: 'grid_voltage_v') double gridVoltage,@JsonKey(name: 'grid_current_a') double gridCurrent,@JsonKey(name: 'grid_export_power_w') double gridExportPower,@JsonKey(name: 'grid_export_energy_today_kwh') double gridExportEnergyToday,@JsonKey(name: 'grid_import_energy_today_kwh') double gridImportEnergyToday,@JsonKey(name: 'grid_charge_power_w') double gridChargePower,@JsonKey(name: 'solar_energy_today_kwh') double solarEnergyToday,@JsonKey(name: 'solar_power_w') double solarPower,@JsonKey(name: 'home_load_power_w') double homeLoadPower
});




}
/// @nodoc
class __$InverterSnapshotCopyWithImpl<$Res>
    implements _$InverterSnapshotCopyWith<$Res> {
  __$InverterSnapshotCopyWithImpl(this._self, this._then);

  final _InverterSnapshot _self;
  final $Res Function(_InverterSnapshot) _then;

/// Create a copy of InverterSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? inverterId = null,Object? gatewayId = null,Object? recordedAt = null,Object? ingestedAt = null,Object? batteryStateOfCharge = null,Object? batteryVoltage = null,Object? batteryCurrent = null,Object? chargePower = null,Object? dischargePower = null,Object? chargeEnergyToday = null,Object? dischargeEnergyToday = null,Object? gridActivePower = null,Object? gridFrequency = null,Object? gridVoltage = null,Object? gridCurrent = null,Object? gridExportPower = null,Object? gridExportEnergyToday = null,Object? gridImportEnergyToday = null,Object? gridChargePower = null,Object? solarEnergyToday = null,Object? solarPower = null,Object? homeLoadPower = null,}) {
  return _then(_InverterSnapshot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,inverterId: null == inverterId ? _self.inverterId : inverterId // ignore: cast_nullable_to_non_nullable
as String,gatewayId: null == gatewayId ? _self.gatewayId : gatewayId // ignore: cast_nullable_to_non_nullable
as String,recordedAt: null == recordedAt ? _self.recordedAt : recordedAt // ignore: cast_nullable_to_non_nullable
as DateTime,ingestedAt: null == ingestedAt ? _self.ingestedAt : ingestedAt // ignore: cast_nullable_to_non_nullable
as DateTime,batteryStateOfCharge: null == batteryStateOfCharge ? _self.batteryStateOfCharge : batteryStateOfCharge // ignore: cast_nullable_to_non_nullable
as double,batteryVoltage: null == batteryVoltage ? _self.batteryVoltage : batteryVoltage // ignore: cast_nullable_to_non_nullable
as double,batteryCurrent: null == batteryCurrent ? _self.batteryCurrent : batteryCurrent // ignore: cast_nullable_to_non_nullable
as double,chargePower: null == chargePower ? _self.chargePower : chargePower // ignore: cast_nullable_to_non_nullable
as double,dischargePower: null == dischargePower ? _self.dischargePower : dischargePower // ignore: cast_nullable_to_non_nullable
as double,chargeEnergyToday: null == chargeEnergyToday ? _self.chargeEnergyToday : chargeEnergyToday // ignore: cast_nullable_to_non_nullable
as double,dischargeEnergyToday: null == dischargeEnergyToday ? _self.dischargeEnergyToday : dischargeEnergyToday // ignore: cast_nullable_to_non_nullable
as double,gridActivePower: null == gridActivePower ? _self.gridActivePower : gridActivePower // ignore: cast_nullable_to_non_nullable
as double,gridFrequency: null == gridFrequency ? _self.gridFrequency : gridFrequency // ignore: cast_nullable_to_non_nullable
as double,gridVoltage: null == gridVoltage ? _self.gridVoltage : gridVoltage // ignore: cast_nullable_to_non_nullable
as double,gridCurrent: null == gridCurrent ? _self.gridCurrent : gridCurrent // ignore: cast_nullable_to_non_nullable
as double,gridExportPower: null == gridExportPower ? _self.gridExportPower : gridExportPower // ignore: cast_nullable_to_non_nullable
as double,gridExportEnergyToday: null == gridExportEnergyToday ? _self.gridExportEnergyToday : gridExportEnergyToday // ignore: cast_nullable_to_non_nullable
as double,gridImportEnergyToday: null == gridImportEnergyToday ? _self.gridImportEnergyToday : gridImportEnergyToday // ignore: cast_nullable_to_non_nullable
as double,gridChargePower: null == gridChargePower ? _self.gridChargePower : gridChargePower // ignore: cast_nullable_to_non_nullable
as double,solarEnergyToday: null == solarEnergyToday ? _self.solarEnergyToday : solarEnergyToday // ignore: cast_nullable_to_non_nullable
as double,solarPower: null == solarPower ? _self.solarPower : solarPower // ignore: cast_nullable_to_non_nullable
as double,homeLoadPower: null == homeLoadPower ? _self.homeLoadPower : homeLoadPower // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
