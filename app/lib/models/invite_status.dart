enum InviteStatus { pending, expired, used, revoked }

extension InviteStatusExtension on InviteStatus {
  String get displayName {
    switch (this) {
      case InviteStatus.pending:
        return 'Pending';
      case InviteStatus.expired:
        return 'Expired';
      case InviteStatus.used:
        return 'Used';
      case InviteStatus.revoked:
        return 'Revoked';
    }
  }
}
