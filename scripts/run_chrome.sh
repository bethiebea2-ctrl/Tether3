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
  exit 1
fi

echo "→ dart run sqflite_common_ffi_web:setup (web SQLite wasm + worker)"
dart run sqflite_common_ffi_web:setup

echo "→ flutter clean"
flutter clean >/dev/null

echo "→ flutter pub get (after clean)"
flutter pub get

echo ""
echo "Starting Chrome. Expect:"
echo "  • Green banner: Tether v0.2.0 · Phase 2A"
echo "  • Sign in / Create account screen (or dashboard if session saved)"
echo "  • Family Hub / Calendar / Tasks load without wasm errors"
echo ""
echo "Press q in this terminal to stop."
echo ""

flutter run -d chrome
