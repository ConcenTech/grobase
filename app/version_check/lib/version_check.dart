class VersionTriple {
  final int major;
  final int minor;
  final int patch;

  const VersionTriple(this.major, this.minor, this.patch);

  /// True when this version is a greater major, minor, or patch than [previous].
  bool isNewerThan(VersionTriple previous) {
    if (major != previous.major) {
      return major > previous.major;
    }
    if (minor != previous.minor) {
      return minor > previous.minor;
    }
    return patch > previous.patch;
  }

  @override
  String toString() => '$major.$minor.$patch';
}

/// Drops a `v` or `firmware-v` tag prefix and any `+build` metadata.
String stripVersionPrefix(String version) {
  return version.trim().replaceFirst(RegExp(r'^(?:firmware-)?v'), '');
}

VersionTriple? parseVersion(String raw) {
  final core = stripVersionPrefix(raw).split('+').first;
  final parts = core.split('.');
  if (parts.length < 3) {
    return null;
  }
  final major = int.tryParse(parts[0]);
  final minor = int.tryParse(parts[1]);
  final patch = int.tryParse(parts[2]);
  if (major == null || minor == null || patch == null) {
    return null;
  }
  return VersionTriple(major, minor, patch);
}
