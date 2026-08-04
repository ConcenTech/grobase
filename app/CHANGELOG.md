
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.14] - 04/08/26

### Fixed
- SyncService doesn't get initial state when app resumes from the background.
- onAuthStateChange throws when offline.

## [0.1.13] - 01/08/26

### Fixed
- There is no GoRouterState above the current context. (Sentry)
- Chart labels overflow when user has device scaling set to high.

### Added
- Side navigation bar for lanscape ordientations.

## [0.1.12] - 30/07/26

### Fixed
- Weather based background makes UI unclear.
- Chart axis labels don't scale well across screen sizes and scales.

### Added
- Sentry.io integration

## [0.1.11] - 29/07/26

### Added
- Connected weather UI to weather services.
- Inverter details screen
- Inveter invite flow.

### Fixed
- OPENWEATHER_API_KEY missing from builds.
Constants from the environment are now checked at compile time rather than run time.

## [0.1.10] - 24/07/26

### Fixed
- Moved environment strings into Env class, added compile time checks to ensure they are set with --dart-define.
- Providers rebuilding unnessesarily.
Provider.family requires a stable key to prevent rebuilds. Inverter uses equality on all parameters meaning updates cause equality to fail so prefer inverter.id instead.
- Session tokens are expired when resuming app.
RealtimeChannels now refresh token if expired before opening the channel.
- Home screen overlay flickers when provider is loading.

### Added
- Weather service

## [0.1.9] - 21/07/26

### Fixed
- Firmware bug that made it seem gridActivePower is the sum of grid import and export.
- Renamed gridActivePower to gridImportPower for clarity.

## [0.1.8] - 20/07/26

### Fixed
- Primary keys not set on database classes.
- gridActivePower tracks import and export.

### Added
- removeSnapshots method added to offline databse.
SyncService now removes snapshots for inverters that have been removed.
- Session token checks.
OnlineDatabaseService now checks the session token is valid before making any database calls.

### Updated
- Bumped dependancies to latest versions

## [0.1.7] - 18/07/26

### Fixed
- Missing AppLogger import in main.dart

## [0.1.6] - 18/07/26

### Fixed
- Inverter.lastSeenAt should be nullable
- EnergyCard has inconsistend value text size.
- EnergyCard has a minimum width that can allow clipping of the title text.

## Added
- Log viewer.
A dialog can now be opened from the settings screen with the ability to view and copy recent logs.

## [0.1.5] - 17/07/26 

### Fixed
- Sync errors not surfaced in the UI
- EnergyCard widgets overflow.

## [0.1.4] - 17/07/26

### Fixed
- Android release builds missing INTERNET permission, blocking Supabase backend connectivity.
- Auth screens showing raw Supabase error messages instead of clean user-facing copy.

## [0.1.3] - 16/07/26

### Added
- Mocks for OnlineDatabaseService and AppRouter to allow for easier UI testing

### Fixed
- House overflows on main screen when device is landscape.
- Safe area clips home screen when device is landscape.
- Duplicate permission declarations in Android manifest.
- Real inverter data not displayed in systems screen.

## [0.1.2] - 14/07/26

### Fixed
- Unable to find SplashScreen or TestScreen during build

## [0.1.1] - 14/07/26

Initial beta app release

### Fixed
- SUPABASE_URL and SUPABASE_PUBLISHABLE_KEY missing from build

### Added
- Settings screen. Placeholder only for now.
- Bottom bar added to home screen. Users can now navigate between [Home] [Systems] [Settings]

[0.1.1]: https://github.com/ConcenTech/grobase/compare/main...v0.1.1
[0.1.2]: https://github.com/ConcenTech/grobase/compare/v0.1.1...v0.1.2
[0.1.3]: https://github.com/ConcenTech/grobase/compare/v0.1.2...v0.1.3
[0.1.4]: https://github.com/ConcenTech/grobase/compare/v0.1.3...v0.1.4
[0.1.5]: https://github.com/ConcenTech/grobase/compare/v0.1.4...v0.1.5
[0.1.6]: https://github.com/ConcenTech/grobase/compare/v0.1.5...v0.1.6
[0.1.7]: https://github.com/ConcenTech/grobase/compare/v0.1.6...v0.1.7
[0.1.8]: https://github.com/ConcenTech/grobase/compare/v0.1.7...v0.1.8
[0.1.9]: https://github.com/ConcenTech/grobase/compare/v0.1.8...v0.1.9
[0.1.10]: https://github.com/ConcenTech/grobase/compare/v0.1.9...v0.1.10
[0.1.11]: https://github.com/ConcenTech/grobase/compare/v0.1.10...v0.1.11
[0.1.12]: https://github.com/ConcenTech/grobase/compare/v0.1.11...v0.1.12
[0.1.13]: https://github.com/ConcenTech/grobase/compare/v0.1.12...v0.1.13