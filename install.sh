#!/bin/bash -eux

OS="$(uname -s)"
BROWSER="$(echo ${1:-chrome} | tr '[:upper:]' '[:lower:]')"

# https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Native_manifests#Manifest_location
# https://developer.chrome.com/extensions/nativeMessaging#native-messaging-host-location
case "$OS $BROWSER" in
    "Linux firefox")
        MANIFEST_LOCATION="$HOME/.mozilla/native-messaging-hosts";;
    "Darwin firefox")
        MANIFEST_LOCATION="$HOME/Library/Application Support/Mozilla/NativeMessagingHosts";;
    "Linux chrome")
        MANIFEST_LOCATION="$HOME/.config/google-chrome/NativeMessagingHosts";;
    "Linux chromium")
        MANIFEST_LOCATION="$HOME/.config/chromium/NativeMessagingHosts";;
    "Darwin chrome")
        MANIFEST_LOCATION="$HOME/Library/Application Support/Google/Chrome/NativeMessagingHosts";;
    "Darwin chromium")
        MANIFEST_LOCATION="$HOME/Library/Application Support/Chromium/NativeMessagingHosts";;
esac

mkdir -p "$MANIFEST_LOCATION"

APP_NAME="com.rsnous.tabfs"
EXE_PATH=$(pwd)/fs/tabfs

case "$BROWSER" in
    chrome | chromium)
        MANIFEST=$(cat <<EOF
{
  "name": "$APP_NAME",
  "description": "TabFS",
  "path": "$EXE_PATH",
  "type": "stdio",
  "allowed_extensions": ["tabfs@rsnous.com"],
  "allowed_origins": ["chrome-extension://jimpolemfaeckpjijgapgkmolankohgj/"]
}
EOF
        );;
    firefox)
        MANIFEST=$(cat <<EOF
{
  "name": "$APP_NAME",
  "description": "TabFS",
  "path": "$EXE_PATH",
  "type": "stdio",
  "allowed_extensions": ["tabfs@rsnous.com"]
}
EOF
        );;
esac

echo "$MANIFEST" > "$MANIFEST_LOCATION/$APP_NAME.json"