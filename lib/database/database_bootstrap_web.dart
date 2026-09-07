import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';

/// IndexedDB-backed SQLite for Flutter web.
/// Requires version-matched [web/sqlite3.wasm] from `dart run sqflite_common_ffi_web:setup`.
Future<void> initDatabasePlatform() async {
  databaseFactory = databaseFactoryFfiWebNoWebWorker;
  try {
    await sqfliteFfiWebLoadSqlite3Wasm(
      SqfliteFfiWebOptions(
        sqlite3WasmUri: Uri.parse('sqlite3.wasm'),
        sharedWorkerUri: Uri.parse('sqflite_sw.js'),
      ),
    );
  } catch (e) {
    // ignore: avoid_print
    print(
      'sqlite3.wasm preload failed: $e\n'
      'Run: dart run sqflite_common_ffi_web:setup',
    );
  }
}
