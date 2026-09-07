# Running the latest Tether build

Phase 2A (auth, onboarding, household) lives on the **`cursor/dashboard-v3-colour-capacity`** branch — **not** on `main` yet.

## Quick check — are you on the new build?

After installing, open **Settings → About & licences** (or the footer at the bottom of Settings):

- **Old build:** `Version 1.0.0 · Phase 1B`
- **New build:** `v0.2.0 (Phase 2A — Connection layer)`

On launch, the **new build always shows the sign-in / create account screen first** (unless you already signed in on that device).

## Install latest on your phone or emulator

```bash
git fetch origin
git checkout cursor/dashboard-v3-colour-capacity
git pull origin cursor/dashboard-v3-colour-capacity
flutter clean
flutter pub get
flutter run
```

**Important:** Quitting and reopening the app is not enough if the binary was not rebuilt. You need a fresh `flutter run` or install after pulling.

### iOS / Xcode
Product → Clean Build Folder, then run again from the feature branch.

### Android
Uninstall the old app if unsure, then `flutter run` from the feature branch.

## Still on the old screen?

1. Confirm branch: `git branch --show-current` → should be `cursor/dashboard-v3-colour-capacity`
2. Confirm latest commit includes Phase 2A: `git log -1 --oneline`
3. Check Settings footer for `v0.2.0 (Phase 2A ...)`
