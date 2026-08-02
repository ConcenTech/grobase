import 'dart:async';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../services/database/online_database_service.dart';
import 'auth_errors.dart';

/// Maps sync / database failures to short, user-facing copy.
///
/// Never pass raw exception text through to the UI. Prefer typed checks
/// ([PostgrestException], [AuthException], network errors) and fall back to
/// known message fragments only when needed.
class SyncErrors {
  SyncErrors._();

  static const unexpected =
      'Something went wrong while syncing. Please try again.';

  static const offline =
      'No internet connection. Check your network and try again.';

  static const timedOut = 'The request timed out. Please try again.';

  static const sessionExpired =
      'Your session has expired. Please sign in again.';

  static const noAccess = "You don't have access to this data.";

  /// Whether [error] is likely transient and worth automatic retry.
  static bool isRetryable(Object error) {
    if (error is AuthRetryableFetchException) return true;
    if (error is TimeoutException) return true;
    if (error is SocketException ||
        error is HttpException ||
        error is HandshakeException) {
      return true;
    }

    if (error is DatabaseException) {
      final nested = error.error;
      if (nested != null) return isRetryable(nested);
      return _isRetryableMessage(error.message);
    }

    // Permanent auth failures (expired session, banned, etc.) should surface.
    if (error is AuthException) return false;

    if (error is PostgrestException) {
      final code = error.code;
      if (code == 'PGRST301' || code == 'PGRST303') return false;
      if (code != null && code.startsWith('28')) return false;
      if (code == '42501') return false;
      return _isRetryableMessage(error.message);
    }

    return _isRetryableMessage(error.toString());
  }

  /// Clean message suitable for the sync error snackbar.
  static String userFacingMessage(Object error) {
    if (error is DatabaseException) {
      final nested = error.error;
      if (nested != null) {
        return userFacingMessage(nested);
      }
      return _messageForRawMessage(error.message) ?? unexpected;
    }

    if (error is PostgrestException) {
      return _messageForPostgrest(error);
    }

    // Transient auth network failures (e.g. token refresh on resume before DNS
    // is ready). Prefer the offline message over a generic auth error.
    if (error is AuthRetryableFetchException) {
      return offline;
    }

    if (error is AuthException) {
      return AuthErrors.userFacingMessage(error);
    }

    if (error is SocketException ||
        error is HttpException ||
        error is HandshakeException) {
      return offline;
    }

    if (error is TimeoutException) {
      return timedOut;
    }

    return _messageForRawMessage(error.toString()) ?? unexpected;
  }

  static bool _isRetryableMessage(String message) {
    final lower = message.toLowerCase();
    return lower.contains('failed host lookup') ||
        lower.contains('network is unreachable') ||
        lower.contains('connection refused') ||
        lower.contains('connection reset') ||
        lower.contains('socketexception') ||
        lower.contains('clientexception') ||
        lower.contains('no internet') ||
        lower.contains('offline') ||
        lower.contains('timed out') ||
        lower.contains('timeout') ||
        lower.contains('connection closed') ||
        lower.contains('temporarily unavailable');
  }

  static String _messageForPostgrest(PostgrestException error) {
    final code = error.code;
    if (code != null && code.isNotEmpty) {
      final fromCode = _messageForCode(code);
      if (fromCode != null) return fromCode;
    }

    return _messageForRawMessage(error.message) ?? unexpected;
  }

  static String? _messageForCode(String code) {
    switch (code) {
      // JWT expired / invalid (PostgREST)
      case 'PGRST301':
      case 'PGRST303':
        return sessionExpired;
      // Insufficient privilege
      case '42501':
        return noAccess;
      default:
        // Postgres SQLSTATE class 28 = invalid authorization
        if (code.startsWith('28')) return sessionExpired;
        return null;
    }
  }

  static String? _messageForRawMessage(String message) {
    final lower = message.toLowerCase();

    if (lower.contains('failed host lookup') ||
        lower.contains('network is unreachable') ||
        lower.contains('connection refused') ||
        lower.contains('connection reset') ||
        lower.contains('socketexception') ||
        lower.contains('clientexception') ||
        lower.contains('no internet') ||
        lower.contains('offline')) {
      return offline;
    }

    if (lower.contains('timed out') || lower.contains('timeout')) {
      return timedOut;
    }

    if (lower.contains('jwt expired') ||
        lower.contains('session missing') ||
        lower.contains('not authenticated') ||
        lower.contains('invalid jwt') ||
        lower.contains('refresh_token')) {
      return sessionExpired;
    }

    if (lower.contains('permission denied') ||
        lower.contains('row-level security') ||
        lower.contains('rls') ||
        lower.contains('insufficient privilege') ||
        lower.contains('not authorized')) {
      return noAccess;
    }

    return null;
  }
}
