#!/usr/bin/env bash
# Run Tether in Chrome with diagnostics. Usage: ./scripts/run_chrome.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "=== Tether Chrome launcher ==="
echo "Folder: $ROOT"
echo "Branch: $(git branch --show-current 2>/dev/null || echo '?')"
echo "Commit: $(git log -1 --oneline 2>/dev/null || echo '?')"
echo ""

if ! command -v flutter >/dev/null 2>&1; then
  echo "ERROR: flutter not found in PATH."
  echo "Install Flutter: https://docs.flutter.dev/get-started/install"
  exit 1
fi

echo "Flutter: $(flutter --version 2>/dev/null | head -1)"
echo ""

echo "→ flutter pub get"
if ! flutter pub get; then
  echo ""
  echo "ERROR: pub get failed — the app was NOT rebuilt."
  echo "Fix the error above, then run this script again."
  echo "While pub get fails, Chrome keeps showing the OLD app from your last successful run."
  exit 1
fi

if [ ! -f web/sqlite3.wasm ]; then
  echo "→ Downloading web/sqlite3.wasm (first-time web setup)"
  curl -fsSL -o web/sqlite3.wasm \
    "https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-3.5.0/sqlite3.wasm" \
    || echo "WARN: sqlite3.wasm download failed — see web/README_sqlite.md"
fi

echo "→ flutter clean"
flutter clean >/dev/null

echo "→ flutter pub get (after clean)"
flutter pub get

echo ""
echo "Starting Chrome. Expect:"
echo "  • Green banner: Tether v0.2.0 · Phase 2A"
echo "  • Sign in / Create account screen"
echo "  • Chrome tab title: Tether 2A"
echo ""
echo "Press q in this terminal to stop."
echo ""

flutter run -d chrome
