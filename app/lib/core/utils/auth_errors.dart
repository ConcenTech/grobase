import 'package:supabase_flutter/supabase_flutter.dart';

/// Maps Supabase [AuthException] values to short, user-facing copy.
///
/// Prefer [AuthException.code] when present; fall back to known message
/// fragments for older responses that omit a code. Never pass the raw
/// server message through to the UI.
class AuthErrors {
  AuthErrors._();

  static const unexpected = 'Something went wrong. Please try again.';

  /// Whether this exception means the account exists but email is unconfirmed.
  static bool isEmailNotConfirmed(AuthException error) {
    if (error.code == 'email_not_confirmed') return true;
    return _messageContains(error, 'email not confirmed');
  }

  static const offline =
      'No internet connection. Check your network and try again.';

  /// Clean message suitable for inline Auth UI error text.
  static String userFacingMessage(AuthException error) {
    // Transient network failures during token refresh (e.g. DNS not ready on
    // app resume). AuthRetryableFetchException is expected and retryable.
    if (error is AuthRetryableFetchException) {
      return offline;
    }

    final code = error.code;
    if (code != null && code.isNotEmpty) {
      final fromCode = _messageForCode(code);
      if (fromCode != null) return fromCode;
    }

    final fromMessage = _messageForRawMessage(error.message);
    if (fromMessage != null) return fromMessage;

    return unexpected;
  }

  static String? _messageForCode(String code) {
    switch (code) {
      case 'invalid_credentials':
      case 'user_not_found':
        return 'Incorrect email or password.';
      case 'email_not_confirmed':
        return 'Please confirm your email before signing in.';
      case 'email_exists':
      case 'user_already_exists':
        return 'An account with this email already exists.';
      case 'email_address_invalid':
        return 'Please enter a valid email address.';
      case 'weak_password':
        return 'Please choose a stronger password.';
      case 'same_password':
        return 'Please choose a password you have not used before.';
      case 'over_email_send_rate_limit':
      case 'over_request_rate_limit':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'signup_disabled':
      case 'email_provider_disabled':
        return 'New account registration is currently unavailable.';
      case 'user_banned':
        return 'This account is temporarily unavailable.';
      case 'session_expired':
      case 'session_not_found':
      case 'refresh_token_not_found':
        return 'Your session has expired. Please sign in again.';
      case 'otp_expired':
        return 'This link has expired. Please request a new one.';
      case 'validation_failed':
        return 'Please check your details and try again.';
      case 'email_address_not_authorized':
        return 'Unable to send email to this address right now.';
      default:
        return null;
    }
  }

  static String? _messageForRawMessage(String message) {
    final lower = message.toLowerCase();

    if (lower.contains('invalid login credentials')) {
      return 'Incorrect email or password.';
    }
    if (lower.contains('email not confirmed')) {
      return 'Please confirm your email before signing in.';
    }
    if (lower.contains('user already registered') ||
        lower.contains('already been registered')) {
      return 'An account with this email already exists.';
    }
    if (lower.contains('password should be') ||
        lower.contains('password is known to be weak') ||
        lower.contains('weak password')) {
      return 'Please choose a stronger password.';
    }
    if (lower.contains('for security purposes') ||
        lower.contains('rate limit') ||
        lower.contains('too many requests')) {
      return 'Too many attempts. Please wait a moment and try again.';
    }
    if (lower.contains('auth session missing') ||
        lower.contains('session missing')) {
      return 'Your session has expired. Please sign in again.';
    }
    if (lower.contains('signup is disabled') ||
        lower.contains('signups not allowed')) {
      return 'New account registration is currently unavailable.';
    }
    if (lower.contains('unable to validate email') ||
        lower.contains('invalid email')) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  static bool _messageContains(AuthException error, String fragment) {
    return error.message.toLowerCase().contains(fragment.toLowerCase());
  }
}
