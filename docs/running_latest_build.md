# Running the latest Tether build

Phase 2A (auth, onboarding, household) is on **`main`**.

## Running in Chrome (no cable needed)

If you use **Chrome on your computer**, see **[`docs/running_on_chrome.md`](running_on_chrome.md)** — that is the usual reason “quit and reopen” shows no change.

Quick version:

```bash
git pull origin main
flutter clean && flutter pub get
flutter run -d chrome
```

Press **`q`** in the terminal to stop any old `flutter run` session before starting a new one.

## Quick check — are you on the new build?

| Location | Old build | New build (2A) |
|----------|-----------|----------------|
| Dashboard title area | Greeting only | Greeting + **`v0.2.0 (Phase 2A — Connection layer)`** |
| Settings → About | `Phase 1B` | **`v0.2.0 (Phase 2A — Connection layer)`** |
| Settings → Edit profile | "Coming in Phase 2A" stub | Opens **Edit profile** screen |
| App launch | Straight to dashboard | **Sign in / Create account** first |

If you still see **Bethany Clulow** hardcoded with **Coming in Phase 2A** on Edit profile, the old app binary is still installed.

## Install latest on your phone or emulator

Git pull alone is **not enough**. You must **rebuild and reinstall** the app.

```bash
cd /path/to/Tether3
git pull origin main
flutter clean
flutter pub get
flutter run
```

### iOS (Xcode or flutter run)
1. `flutter clean && flutter pub get`
2. In Xcode: **Product → Clean Build Folder**
3. Run again (`flutter run` or ▶ in Xcode)

### Android
1. **Uninstall** the existing Tether app from the phone (recommended if unsure)
2. `flutter clean && flutter pub get && flutter run`

### Why quit & reopen is not enough
Closing the app only restarts the **same compiled binary** already on your device. New Dart code from GitHub is not applied until you run `flutter run` (or build a new APK/IPA) again.

## Still stuck?

1. Confirm folder: `git remote -v` should point at **Tether3**
2. Confirm branch: `git branch --show-current` → `main`
3. Confirm code: `git log -1 --oneline` should mention Phase 2A or v0.2.0
4. Confirm rebuild: after `flutter run`, dashboard subtitle must show **v0.2.0**
