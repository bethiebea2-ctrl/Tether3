/// Visible build identity — bump when shipping a new phase slice.
class AppBuildInfo {
  AppBuildInfo._();

  static const String version = '0.2.0';
  static const int buildNumber = 4;
  static const String phase = '2A';
  static const String label = 'Phase 2A — Connection layer';
  static const bool authGateEnabled = true;

  static String get fullLabel => 'v$version ($label)';
}
