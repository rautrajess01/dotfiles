#!/bin/bash

# Enhanced Clipboard Manager with Rofi Type 1
# Uses cliphist and rofi for a beautiful clipboard experience

# Check if required tools are installed
if ! command -v cliphist &> /dev/null; then
    echo "❌ cliphist is not installed!"
    echo "Install with: sudo dnf install cliphist"
    exit 1
fi

if ! command -v rofi &> /dev/null; then
    echo "❌ rofi is not installed!"
    echo "Install with: sudo dnf install rofi"
    exit 1
fi

# Check if wl-copy is available
if command -v wl-copy &> /dev/null; then
    PASTE_CMD="wl-copy"
elif command -v xclip &> /dev/null; then
    PASTE_CMD="xclip -selection clipboard"
else
    echo "❌ No clipboard tool found (wl-copy or xclip)"
    exit 1
fi

# Get clipboard history and show selection menu
selected=$(cliphist list | rofi -dmenu -theme ~/.config/rofi/launchers/type-1/style-1.rasi -i -p "📋 Clipboard History")

if [[ -n "$selected" ]]; then
    # Extract the clipboard content (remove the ID number)
    content=$(echo "$selected" | sed 's/^[0-9]*[[:space:]]*//')
    
    # Copy selected content to clipboard
    echo "$content" | $PASTE_CMD
    
    # Show notification
    notify-send "Clipboard Manager" "Copied to clipboard: ${content:0:50}..."
    
    echo "✅ Copied to clipboard: ${content:0:50}..."
else
    echo "❌ No selection made"
fi
