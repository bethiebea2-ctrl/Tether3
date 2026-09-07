# Web SQLite (Chrome)

Flutter web needs a **version-matched** `sqlite3.wasm` in this folder.

**Do not** download wasm manually from random release tags — the wrong version causes:

`WebAssembly.instantiate(): Import … "xFileControl": function import requires a callable`

## Setup (required once per clone)

```bash
dart run sqflite_common_ffi_web:setup
```

This writes `web/sqlite3.wasm` and `web/sqflite_sw.js` matched to your pub lockfile.

Or use `./scripts/run_chrome.sh` which runs setup automatically.

## After updating dependencies

Re-run setup, then hard-refresh Chrome (Cmd+Shift+R).

If Family Hub still fails, tap **Reset local data** once (clears corrupted IndexedDB).
