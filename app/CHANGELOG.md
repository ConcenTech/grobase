
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.5] - 17/07/26

### Fixed
- Sync errors not surfaced in the UI
- EnergyCard widgets overflow.
- Systems failing to load from release DB when `last_seen_at` (or snapshot metrics) are null — common before the first gateway ingest; development seed always populated these fields.
- Clearer sync error when the Data API role lacks table grants (PGRST205 / schema cache).

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

