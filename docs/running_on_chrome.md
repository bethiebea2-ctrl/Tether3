# Running Tether in Chrome (web)

No phone cable needed. Flutter web runs in Chrome on your computer.

## The mistake that causes “no change”

These **do not** update the app:

- Closing the Chrome tab and reopening the same URL
- Refresh (F5) on an old `localhost` tab
- `git pull` alone

Chrome is running a **compiled JavaScript bundle** from the last time you ran `flutter run -d chrome`. Until you rebuild, you keep the old app — including **“Coming in Phase 2A”** on Edit profile.

## Install the latest build (Chrome)

In Terminal, from your Tether3 project folder:

```bash
git pull origin main
./scripts/run_chrome.sh
```

(`run_chrome.sh` runs pub get, web SQLite setup, clean, and opens Chrome.)

Flutter will open a **new** Chrome window/tab with a fresh build.

### Web SQLite setup (required for Family Hub, Calendar, Tasks, etc.)

If screens spin forever or Family Hub shows a wasm error like `xFileControl`:

```bash
dart run sqflite_common_ffi_web:setup
./scripts/run_chrome.sh
```

In the app: **Family Hub → Reset local data** once (clears bad IndexedDB), then hard-refresh Chrome (`Cmd+Shift+R`).

See `web/README_sqlite.md` for details.

## How to know the new build loaded

| Check | Old build | New build (2A) |
|-------|-----------|----------------|
| Launch | Straight to dashboard | **Sign in / Create account** first |
| Dashboard subtitle | Greeting only | **`v0.2.0 (Phase 2A — Connection layer)`** under greeting |
| Settings → Edit profile | “Coming in Phase 2A” stub | Opens **Edit profile** form |
| Settings → About | Phase 1B | **v0.2.0 (Phase 2A …)** |

## If it still looks old

1. **Stop any old Flutter process** — in the terminal where `flutter run` is running, press `q` to quit. Old `localhost` servers keep serving old code.
2. Run `flutter clean` again, then `flutter run -d chrome`.
3. In Chrome: **hard refresh** — Mac: `Cmd+Shift+R`, Windows: `Ctrl+Shift+R`.
4. Still stuck? Clear site data for localhost:
   - Chrome → DevTools (F12) → **Application** → **Clear site data**
   - Or remove the site under **Settings → Privacy → Site settings**

## Daily workflow (Chrome)

```bash
git pull origin main    # when you want latest code
flutter run -d chrome   # rebuild + open Chrome
```

While developing, save a Dart file and use **`r`** in the terminal for hot reload, or **`R`** for hot **restart**. Structural changes (like Phase 2A auth gate) usually need a full quit (`q`) and `flutter run -d chrome` again.
