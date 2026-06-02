#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_NAME="Codex Spend"
BUNDLE_ID="com.local.codex-spend"
DEPLOYMENT_TARGET="${MACOSX_DEPLOYMENT_TARGET:-13.0}"
ARCH="${ARCH:-$(uname -m)}"
DIST_DIR="$ROOT_DIR/dist"
APP_DIR="$DIST_DIR/$APP_NAME.app"
MODULE_CACHE_DIR="$DIST_DIR/ModuleCache"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"
EXECUTABLE="$MACOS_DIR/$APP_NAME"

rm -rf "$APP_DIR" "$MODULE_CACHE_DIR"
mkdir -p "$MACOS_DIR" "$RESOURCES_DIR" "$MODULE_CACHE_DIR"

cp "$ROOT_DIR/Resources/Info.plist" "$CONTENTS_DIR/Info.plist"

swiftc \
  -O \
  -module-cache-path "$MODULE_CACHE_DIR" \
  -target "$ARCH-apple-macos$DEPLOYMENT_TARGET" \
  -framework AppKit \
  "$ROOT_DIR/Sources/CodexSpend/main.swift" \
  -o "$EXECUTABLE"

if command -v codesign >/dev/null 2>&1; then
  codesign --force --deep --sign - --identifier "$BUNDLE_ID" "$APP_DIR" >/dev/null
fi

echo "Built $APP_DIR"
