#!/bin/bash

# Create a temp file for the screenshot
IMG=$(mktemp --suffix=.png)
TXT=$(mktemp)

# Take screenshot
grim -g "$(slurp)" "$IMG"

# Run OCR
tesseract "$IMG" "$TXT" -l eng

# Copy to clipboard
cat "$TXT.txt" | wl-copy

# Cleanup
rm "$IMG" "$TXT.txt"

