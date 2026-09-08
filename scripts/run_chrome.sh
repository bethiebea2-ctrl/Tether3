#!/usr/bin/env bash
# Run Tether in Chrome with diagnostics. Usage: ./scripts/run_chrome.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# Web auth + prefs are stored per browser origin — keep port fixed between runs.
WEB_PORT="${TETHER_WEB_PORT:-7357}"

echo "=== Tether Chrome launcher ==="
echo "Folder: $ROOT"
echo "Branch: $(git branch --show-current 2>/dev/null || echo '?')"
echo "Commit: $(git log -1 --oneline 2>/dev/null || echo '?')"
echo "URL:    http://localhost:${WEB_PORT}"
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

echo "→ flutter pub get (after setup)"
flutter pub get

echo ""
echo "Starting Chrome at http://localhost:${WEB_PORT}"
echo "Expect:"
echo "  • Green banner: Tether v0.2.0 · Phase 2B"
echo "  • Sign in / Create account screen (or dashboard if session saved)"
echo "  • Family Hub / Calendar / Tasks load without wasm errors"
echo ""
echo "Bookmark http://localhost:${WEB_PORT} — your account is saved per port."
echo "Press q in this terminal to stop."
echo ""

flutter run -d chrome --web-hostname=localhost --web-port="${WEB_PORT}"
