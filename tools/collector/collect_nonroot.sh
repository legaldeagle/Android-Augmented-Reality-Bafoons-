#!/usr/bin/env bash
set -euo pipefail

# collect_nonroot.sh
# Starter script to collect non-root Android artifacts via adb.
# Run from this folder: ./collect_nonroot.sh

OUT_DIR="$(pwd)/output/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$OUT_DIR"

echo "Output directory: $OUT_DIR"

echo "1) Checking adb devices..."
adb devices

echo "2) Saving device properties..."
adb shell getprop > "$OUT_DIR/device_props.txt"

echo "3) Capturing bugreport (this may take time)..."
adb bugreport "$OUT_DIR/bugreport.zip"

echo "4) Capturing logcat..."
adb logcat -d > "$OUT_DIR/logcat.txt" || true

echo "5) Pulling /sdcard (shared storage)..."
mkdir -p "$OUT_DIR/sdcard"
adb pull /sdcard "$OUT_DIR/sdcard" || echo "Warning: pull /sdcard failed or empty"

echo "6) Listing packages and saving package metadata..."
adb shell pm list packages -f > "$OUT_DIR/packages_raw.txt" || true
adb shell pm list packages -3 > "$OUT_DIR/user_packages.txt" || true

echo "7) Making hashes for text artifacts (best-effort)..."
if [ -f "$OUT_DIR/bugreport.zip" ]; then
  sha256sum "$OUT_DIR/bugreport.zip" > "$OUT_DIR/bugreport.zip.sha256"
fi
if [ -f "$OUT_DIR/logcat.txt" ]; then
  sha256sum "$OUT_DIR/logcat.txt" > "$OUT_DIR/logcat.txt.sha256"
fi

echo "8) Best-effort redaction (plaintext files only)"
REDACT_DIR="$OUT_DIR/redacted"
mkdir -p "$REDACT_DIR"

# Redact email addresses and phone numbers in text files (very simple regex rules)
shopt -s nullglob
for txt in "$OUT_DIR"/*.txt; do
  bn=$(basename "$txt")
  sed -E 's/[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/[REDACTED_EMAIL]/g; s/\+?[0-9][0-9 \-()]{6,}/[REDACTED_PHONE]/g' "$txt" > "$REDACT_DIR/$bn"
done

echo "9) Create final archive (unencrypted). Review redacted files before sharing." 
ARCHIVE="$OUT_DIR/evidence_$(date +%Y%m%d_%H%M%S).tar.gz"
tar -czf "$ARCHIVE" -C "$OUT_DIR" .
sha256sum "$ARCHIVE" > "$ARCHIVE.sha256"

echo "Done. Archive: $ARCHIVE" 
echo "Please review files in $OUT_DIR/redacted and consider encrypting before upload to IPFS."

exit 0
