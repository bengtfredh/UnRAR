#!/usr/bin/env bash

DIR="$1"

if [ -z "$DIR" ]; then
    echo "Usage: $(basename "$0") <directory>"
    exit 1
fi

function extractRar() {
    _DIRNAME="$1"
    _RAR="$2"
    _FILES="$3"
    _EXTRACTED=0

    while read -r FILE; do
        if [ -n "$FILE" ] && [ ! -f "$_DIRNAME/$FILE" ]; then
            echo "Extracting"
            if unrar x "$_RAR" "$_DIRNAME"; then
                _EXTRACTED=1
            fi
        fi
    done <<< "$_FILES"

    if [ "$_EXTRACTED" -eq 1 ]; then
        echo "Deleting rar files"
        rm -f "$_DIRNAME"/*.rar "$_DIRNAME"/*.r[0-9][0-9]
    fi
}

echo "Starting UNRAR"

while IFS= read -r -d $'\0'; do
    echo "=> $(basename "$REPLY")"

    DIRNAME="$(dirname "$REPLY")"
    FILES="$(unrar lb "$REPLY" | grep -v '.txt' | grep -v '.nfo')"

    extractRar "$DIRNAME" "$REPLY" "$FILES"
done < <(find "$DIR" -name '*.rar' -print0)

echo "UNRAR Done"
