import '../constants.dart';

class Validators {
  // static final required = RequiredValidator(errorText: kRequired);
  static const required = _requiredValidator;

  static String? _requiredValidator(Object? value) {
    if (value is String) {
      return value.isEmpty ? kRequired : null;
    }
    return value == null ? kRequired : null;
  }

  static const email = _emailValidator;

  static String? _emailValidator(String? value) {
    var error = _requiredValidator(value);

    if (error != null) {
      return error;
    }

    if (!value!.contains('@')) {
      return 'Please enter a valid email';
    }

    return null;
  }

  static String? requiredInt(String? value) {
    if (value == null) {
      return kRequired;
    }

    if (int.tryParse(value) == null) {
      return 'Invalid value';
    }

    return null;
  }

  static String? requiredDouble(String? value) {
    if (value == null) {
      return kRequired;
    }
    if (!value.contains('.')) {
      return 'Decimal place required';
    }
    if (double.tryParse(value) == null) {
      return 'Invalid value';
    }

    return null;
  }

  static String? password(String? value) {
    var error = _requiredValidator(value);

    if (error != null) {
      return error;
    }

    if (value!.length < 6) {
      return 'Password must be at least 6 characters';
    }

    if (!RegExp(r'(?=.*?[#?!@$%^&*-=])').hasMatch(value)) {
      return 'Passwords must have at least one special character';
    }

    return null;
  }

  static String? confirmPassword(String? value, String? password) {
    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }
}
