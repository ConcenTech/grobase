import 'package:freezed_annotation/freezed_annotation.dart';

part 'invite_link.freezed.dart';
part 'invite_link.g.dart';

@freezed
abstract class InviteLink with _$InviteLink {
  const factory InviteLink({
    @JsonKey(name: 'invite_id') required String id,
    @JsonKey(name: 'token') required String token,
    @JsonKey(name: 'invite_url') required String url,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
  }) = _InviteLink;

  factory InviteLink.fromJson(Map<String, dynamic> json) =>
      _$InviteLinkFromJson(json);
}
