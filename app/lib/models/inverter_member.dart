import 'package:freezed_annotation/freezed_annotation.dart';

part 'inverter_member.freezed.dart';
part 'inverter_member.g.dart';

@freezed
abstract class InverterMember with _$InverterMember {
  const factory InverterMember({
    @JsonKey(name: 'inverter_id') required String inverterId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'role') required InverterMemberRole role,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _InverterMember;

  factory InverterMember.fromJson(Map<String, dynamic> json) =>
      _$InverterMemberFromJson(json);
}

enum InverterMemberRole { owner, viewer }
