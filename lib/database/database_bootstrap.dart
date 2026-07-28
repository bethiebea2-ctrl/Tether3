import 'database_bootstrap_stub.dart'
    if (dart.library.html) 'database_bootstrap_web.dart';

Future<void> ensureDatabaseInitialized() => initDatabasePlatform();
