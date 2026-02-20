#!/bin/bash

# Get last copied path from clipboard
clipboard_content=$(xclip -o -selection clipboard 2>/dev/null)

# Check if clipboard is empty
if [ -z "$clipboard_content" ]; then
    notify-send "SVG to PNG" "Clipboard is empty"
    exit 1
fi

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
    notify-send "SVG to PNG" "Conversion successful"
else
    notify-send "SVG to PNG" "Conversion failed"
fi
