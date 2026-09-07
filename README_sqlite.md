# Web SQLite (Chrome)

Flutter web needs a **version-matched** `sqlite3.wasm` in this folder.

The `sqflite_common_ffi_web:setup` command downloads **2.x** wasm, which breaks with **sqlite3 3.x** (`WebAssembly.instantiate(): Import #25 "env"`).

After `pub get`, if Family Hub fails on Chrome, refresh wasm:

```bash
curl -fsSL -o web/sqlite3.wasm \
  "https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-3.5.0/sqlite3.wasm"
```

Check `pubspec.lock` for your `sqlite3` version and use the same tag from
https://github.com/simolus3/sqlite3.dart/releases

Also keep `sqflite_sw.js` from:

```bash
dart run sqflite_common_ffi_web:setup
```

Then **hard refresh** Chrome (or clear site data) and run again.
