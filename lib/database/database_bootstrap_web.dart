import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';

/// IndexedDB-backed SQLite for Flutter web (requires web/sqlite3.wasm from setup).
Future<void> initDatabasePlatform() async {
  databaseFactory = databaseFactoryFfiWebNoWebWorker;
  try {
    await sqfliteFfiWebLoadSqlite3Wasm(SqfliteFfiWebOptions());
  } catch (e) {
    // ignore: avoid_print
    print('sqlite3.wasm preload failed (will retry on open): $e');
  }
}
