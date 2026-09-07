# Tether

Life-coordination app (Flutter).

## Run in Chrome (easiest — no phone cable)

### Option A — GitHub Pages (no local Flutter needed)

After each push to `main`, GitHub Actions builds and publishes the web app.

1. Open repo **Settings → Pages**
2. Source: **Deploy from branch** → branch **`gh-pages`** → **`/ (root)`** → Save
3. Wait for the [Actions](../../actions) workflow **Deploy web to GitHub Pages** to finish (green tick)
4. Open: **https://bethiebea2-ctrl.github.io/Tether3/**

You should see a **green “Tether v0.2.0 · Phase 2A”** banner, then the **sign-in / create account** screen.

### Option B — Local Flutter

```bash
git pull origin main
chmod +x scripts/run_chrome.sh
./scripts/run_chrome.sh
```

Or manually:

```bash
git pull origin main
flutter clean && flutter pub get && flutter run -d chrome
```

**If `flutter pub get` fails, the app does not update** — Chrome keeps the old version. Fix pub get first.

See [`docs/running_on_chrome.md`](docs/running_on_chrome.md) for troubleshooting.

## How to tell old vs new build

| Old | New (Phase 2A) |
|-----|----------------|
| Tab title `beth_app` | Tab title **`Tether 2A`** |
| Edit profile → “Coming in Phase 2A” | Real edit profile form |
| Straight to dashboard | **Sign in** screen first |
| No green banner on load | Green **v0.2.0 · Phase 2A** banner |
