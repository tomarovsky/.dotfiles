#!/bin/bash
# URL-decode (%20 -> space, etc.)
urldecode() {
    local s="${1//+/ }"
    printf '%b' "${s//%/\\x}"
}

clipboard_content=$(wl-paste -n 2>/dev/null)

# Check for empty clipboard
if [ -z "$clipboard_content" ]; then
    notify-send "SVG to PNG" "Clipboard is empty"
    exit 1
fi

# Normalize path: first line, strip file://, URL-decode, trim whitespace
clipboard_content=$(printf '%s' "$clipboard_content" | head -n1)
clipboard_content="${clipboard_content#file://}"
clipboard_content=$(urldecode "$clipboard_content")
clipboard_content="${clipboard_content#"${clipboard_content%%[![:space:]]*}"}"
clipboard_content="${clipboard_content%"${clipboard_content##*[![:space:]]}"}"

# Verify it's an existing SVG file
if [[ "$clipboard_content" != *.svg ]] || [ ! -f "$clipboard_content" ]; then
    notify-send "SVG to PNG" "Not a valid SVG file"
    exit 1
fi

# Set output path
output_path="${clipboard_content%.svg}.png"

# Convert using Inkscape
inkscape "$clipboard_content" \
    --export-filename="$output_path" \
    --export-type=png \
    --export-dpi=400 \
    --export-background="#ffffff"

# Show result notification
if [ $? -eq 0 ]; then
    notify-send "SVG to PNG" "Conversion successful: $(basename "$output_path")"
else
    notify-send "SVG to PNG" "Conversion failed"
fi
