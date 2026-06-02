#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_NAME="Codex Spend"
APP_PATH="$HOME/Applications/$APP_NAME.app"
EXECUTABLE_PATH="$APP_PATH/Contents/MacOS/$APP_NAME"
LAUNCH_AGENT_ID="com.local.codex-spend"
LAUNCH_AGENT_PATH="$HOME/Library/LaunchAgents/$LAUNCH_AGENT_ID.plist"

install_app() {
  "$ROOT_DIR/scripts/build.sh"
  mkdir -p "$HOME/Applications"
  pkill -x "$APP_NAME" >/dev/null 2>&1 || true
  for _ in {1..20}; do
    pgrep -x "$APP_NAME" >/dev/null 2>&1 || break
    sleep 0.1
  done
  rm -rf "$APP_PATH"
  cp -R "$ROOT_DIR/dist/$APP_NAME.app" "$APP_PATH"
  open "$APP_PATH"
  echo "Installed and launched $APP_PATH"
}

install_login_item() {
  mkdir -p "$HOME/Library/LaunchAgents"
  cat > "$LAUNCH_AGENT_PATH" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$LAUNCH_AGENT_ID</string>
  <key>ProgramArguments</key>
  <array>
    <string>$EXECUTABLE_PATH</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <false/>
</dict>
</plist>
PLIST

  launchctl bootout "gui/$(id -u)" "$LAUNCH_AGENT_PATH" >/dev/null 2>&1 || true
  echo "Installed login item $LAUNCH_AGENT_ID"
}

uninstall_login_item() {
  launchctl bootout "gui/$(id -u)" "$LAUNCH_AGENT_PATH" >/dev/null 2>&1 || true
  rm -f "$LAUNCH_AGENT_PATH"
  echo "Removed login item $LAUNCH_AGENT_ID"
}

uninstall_app() {
  uninstall_login_item
  pkill -f "$EXECUTABLE_PATH" >/dev/null 2>&1 || true
  rm -rf "$APP_PATH"
  echo "Removed $APP_PATH"
}

case "${1:-}" in
  --login)
    install_app
    install_login_item
    ;;
  --uninstall-login)
    uninstall_login_item
    ;;
  --uninstall)
    uninstall_app
    ;;
  "" )
    install_app
    ;;
  * )
    echo "Usage: $0 [--login|--uninstall-login|--uninstall]" >&2
    exit 2
    ;;
esac
