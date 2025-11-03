#!/usr/bin/env bash
set -euo pipefail
# publish_template.sh
# Template showing how a user could upload an evidence archive to web3.storage using curl.
# The user must supply WEB3_API_TOKEN (do not commit tokens to the repo).

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 path/to/archive.tar.gz"
  exit 2
fi

ARCHIVE_PATH="$1"

if [ ! -f "$ARCHIVE_PATH" ]; then
  echo "File not found: $ARCHIVE_PATH"
  exit 2
fi

if [ -z "${WEB3_API_TOKEN:-}" ]; then
  echo "Set WEB3_API_TOKEN environment variable with your web3.storage API token."
  exit 2
fi

echo "Uploading $ARCHIVE_PATH to web3.storage..."

CID=$(curl -s -X POST "https://api.web3.storage/upload" \
  -H "Authorization: Bearer $WEB3_API_TOKEN" \
  -H "Accept: application/json" \
  -F file=@"$ARCHIVE_PATH" | jq -r '.cid')

if [ -z "$CID" ] || [ "$CID" = "null" ]; then
  echo "Upload failed or jq missing. Inspect response." && exit 3
fi

echo "Uploaded. CID: $CID"
echo "Save CID and pin with another service for redundancy if desired."
