#!/usr/bin/env bash
# Idempotent Cloud Agent bootstrap for the Beth/Tether Flutter app.
# Installs a pinned Flutter SDK (compatible with pubspec.lock) and fetches
# Dart/Flutter package dependencies. Safe to re-run against cached state.
set -euo pipefail

FLUTTER_VERSION="3.47.2"
FLUTTER_HOME="/opt/flutter"
FLUTTER_ARCHIVE="flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/${FLUTTER_ARCHIVE}"

install_flutter() {
  local installed=""
  if [ -x "${FLUTTER_HOME}/bin/flutter" ]; then
    installed="$("${FLUTTER_HOME}/bin/flutter" --version 2>/dev/null | head -n1 || true)"
  fi
  if printf '%s' "${installed}" | grep -q "Flutter ${FLUTTER_VERSION}"; then
    echo "Flutter ${FLUTTER_VERSION} already installed."
    return
  fi

  echo "Installing Flutter ${FLUTTER_VERSION} to ${FLUTTER_HOME}..."
  sudo rm -rf "${FLUTTER_HOME}"
  local tmp
  tmp="$(mktemp -d)"
  curl -fSL --retry 4 --retry-delay 4 -o "${tmp}/${FLUTTER_ARCHIVE}" "${FLUTTER_URL}"
  sudo mkdir -p "$(dirname "${FLUTTER_HOME}")"
  sudo tar -xf "${tmp}/${FLUTTER_ARCHIVE}" -C "$(dirname "${FLUTTER_HOME}")"
  sudo chown -R "$(id -u):$(id -g)" "${FLUTTER_HOME}"
  rm -rf "${tmp}"
}

install_flutter

# Make flutter/dart resolvable in every shell (login, non-login, and tmux terminals).
sudo ln -sf "${FLUTTER_HOME}/bin/flutter" /usr/local/bin/flutter
sudo ln -sf "${FLUTTER_HOME}/bin/dart" /usr/local/bin/dart
export PATH="${FLUTTER_HOME}/bin:${PATH}"

# Git considers the SDK checkout as owned by another user otherwise.
git config --global --add safe.directory "${FLUTTER_HOME}" || true

# Disable telemetry prompts so setup stays non-interactive.
flutter config --no-analytics >/dev/null 2>&1 || true
dart --disable-analytics >/dev/null 2>&1 || true

# This app runs on Flutter web (Chrome) in the Cloud Agent VM.
flutter config --enable-web >/dev/null 2>&1 || true

echo "Precaching web artifacts..."
flutter precache --web

echo "Fetching package dependencies..."
flutter pub get

echo "Bootstrap complete: $(flutter --version | head -n1)"
