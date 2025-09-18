#!/bin/bash

# Test Wofi App Launcher
# This script tests if Wofi is working properly

echo "Testing Wofi App Launcher..."

# Check if wofi is installed
if ! command -v wofi &> /dev/null; then
    echo "❌ Wofi is not installed!"
    echo "Please install wofi: sudo pacman -S wofi (Arch) or sudo apt install wofi (Ubuntu)"
    exit 1
fi

echo "✅ Wofi is installed"

# Test basic functionality
echo "Launching Wofi in test mode..."
wofi --show=drun --width=400 --height=300 --style=~/.config/wofi/style.css

echo "Test completed!"
