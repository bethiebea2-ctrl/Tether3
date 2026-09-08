/// Visible build identity — bump when shipping a new phase slice.
class AppBuildInfo {
  AppBuildInfo._();

  static const String version = '0.2.0';
  static const int buildNumber = 7;
  static const String phase = '2B';
  static const String label = 'Phase 2B — Settings wiring + Creative refresh';
  static const bool authGateEnabled = true;

  static String get fullLabel => 'v$version ($label)';
}
