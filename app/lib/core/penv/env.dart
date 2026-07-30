import 'package:flutter/foundation.dart';

import 'env_debug.dart';

/// These should be set via `--dart-define` at build time,
/// but defaults can be provided in [env_debug.dart] for local development.
class Env {
  static const openWeatherApiKey = String.fromEnvironment(
    'OPENWEATHER_API_KEY',
    defaultValue: kDebugOpenWeatherApiKey,
  );

  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: kDebugSupabaseUrl,
  );

  static const supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: kDebugSupabasePublishableKey,
  );

  @StaticAssert(
    openWeatherApiKey != kDebugOpenWeatherApiKey,
    'OPENWEATHER_API_KEY is not set',
  )
  @StaticAssert(supabaseUrl != kDebugSupabaseUrl, 'SUPABASE_URL is not set')
  @StaticAssert(
    supabasePublishableKey != kDebugSupabasePublishableKey,
    'SUPABASE_PUBLISHABLE_KEY is not set',
  )
  // ignore: unused_field
  static const _ = null;
}

class StaticAssert {
  const StaticAssert(bool condition, [String message = "Assertion Failed"])
    : assert(kDebugMode || condition, message);
}
