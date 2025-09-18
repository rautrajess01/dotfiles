#!/bin/bash

# Test Premium Wofi Themes
# Showcase all available themes

echo "🎨 Testing Premium Wofi Themes..."
echo ""

# Check if wofi is installed
if ! command -v wofi &> /dev/null; then
    echo "❌ Wofi is not installed!"
    echo "Please install wofi: sudo pacman -S wofi (Arch) or sudo apt install wofi (Ubuntu)"
    exit 1
fi

echo "✅ Wofi is installed"
echo ""

# Test each theme
themes=(
    "style.css:macOS Spotlight Theme"
    "style-modern.css:Purple & Gold Theme"
    "style-premium.css:Ultra-Premium Glass Theme"
)

for theme in "${themes[@]}"; do
    theme_file=$(echo "$theme" | cut -d: -f1)
    theme_name=$(echo "$theme" | cut -d: -f2)
    
    echo "🎯 Testing: $theme_name"
    echo "   File: $theme_file"
    echo ""
    
    # Update config to use this theme
    sed -i "s|style = .*|style = $HOME/.config/wofi/$theme_file|" "$HOME/.config/wofi/config"
    
    echo "   ✅ Theme applied! Press ALT+SPACE to test"
    echo "   Press Enter to continue to next theme..."
    read -r
    
    echo ""
done

echo "🎉 All themes tested! Use SUPER+CTRL+R to switch themes anytime."
echo "Current theme: $(grep 'style =' "$HOME/.config/wofi/config" | cut -d'/' -f6)"
