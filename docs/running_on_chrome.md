# Running Tether in Chrome (web)

No phone cable needed. Flutter web runs in Chrome on your computer.

## The mistake that causes “account didn’t save”

On web, your sign-in is stored in **Chrome localStorage for one exact URL**.

`./scripts/run_chrome.sh` always opens **`http://localhost:7357`**.

If you run plain `flutter run -d chrome` instead, Flutter may pick a **different port each time** (e.g. `:51234` then `:49876`). Each port is a separate “site” — your account on `:51234` will not appear on `:49876`.

**Do this:**

1. Always launch with `./scripts/run_chrome.sh`
2. Bookmark **`http://localhost:7357`**
3. Do **not** use Chrome **Clear site data** for localhost unless you want to wipe your web account (Family Hub **Reset local data** only clears the calendar/people database, not your login)

## The mistake that causes “no change” (old build)

These **do not** update the app:

- Closing the Chrome tab and reopening the same URL
- Refresh (F5) on an old `localhost` tab
- `git pull` alone

Chrome is running a **compiled JavaScript bundle** from the last time you ran the launcher. Until you rebuild, you keep the old app.

## Install the latest build (Chrome)

In Terminal, from your Tether3 project folder:

```bash
git pull origin main
./scripts/run_chrome.sh
```

(`run_chrome.sh` runs pub get, web SQLite setup, clean, and opens Chrome on port 7357.)

### Web SQLite setup (required for Family Hub, Calendar, Tasks, etc.)

If screens spin forever or Family Hub shows a wasm error like `xFileControl`:

```bash
dart run sqflite_common_ffi_web:setup
./scripts/run_chrome.sh
```

In the app: **Family Hub → Reset local data** once (clears bad IndexedDB only — **not** your login), then hard-refresh Chrome (`Cmd+Shift+R`).

See `web/README_sqlite.md` for details.

## How to know the new build loaded

| Check | Old build | New build (2A) |
|-------|-----------|----------------|
| Launch | Straight to dashboard | **Sign in / Create account** first |
| Dashboard subtitle | Greeting only | **`v0.2.0 (Phase 2A — Connection layer)`** under greeting |
| Settings → Edit profile | “Coming in Phase 2A” stub | Opens **Edit profile** form |
| Settings → About | Phase 1B | **v0.2.0 (Phase 2A …)** |
| Auth screen footer | — | Mentions `localhost:7357` when on the correct port |

## If it still looks old

1. **Stop any old Flutter process** — in the terminal where `flutter run` is running, press `q` to quit.
2. Run `./scripts/run_chrome.sh` again (not an old bookmark on a different port).
3. In Chrome: **hard refresh** — Mac: `Cmd+Shift+R`, Windows: `Ctrl+Shift+R`.

## Daily workflow (Chrome)

```bash
git pull origin main    # when you want latest code
./scripts/run_chrome.sh
```

While developing, save a Dart file and use **`r`** in the terminal for hot reload, or **`R`** for hot **restart**. Structural changes (like Phase 2A auth gate) usually need a full quit (`q`) and `./scripts/run_chrome.sh` again.
