#!/bin/bash

# Test Wofi Icons - Fedora Optimized

echo "🔍 Testing Wofi Icon Display on Fedora..."
echo ""

# Check if wofi is installed
if ! command -v wofi &> /dev/null; then
    echo "❌ Wofi is not installed!"
    exit 1
fi

echo "✅ Wofi is installed (version: $(wofi --version))"
echo ""

# Check desktop files
echo "📱 Checking desktop files..."
if [ -d "/usr/share/applications" ]; then
    desktop_count=$(ls /usr/share/applications/*.desktop | wc -l)
    echo "   Found $desktop_count desktop files"
else
    echo "   ❌ No desktop files directory found"
fi

# Check icon themes
echo ""
echo "🎨 Checking icon themes..."
icon_themes=("Papirus" "gnome" "Adwaita" "breeze" "elementary")
for theme in "${icon_themes[@]}"; do
    if [ -d "/usr/share/icons/$theme" ]; then
        echo "   ✅ $theme theme available"
    else
        echo "   ❌ $theme theme not found"
    fi
done

# Test different wofi configurations
echo ""
echo "🧪 Testing different Wofi configurations..."

# Test 1: Basic with Papirus icons
echo "   Test 1: Basic wofi with Papirus icons..."
GTK_ICON_THEME_NAME=Papirus wofi --show=drun --width=400 --height=300 &

echo ""
echo "   Press Enter to continue to next test..."
read -r

# Test 2: With custom style
echo "   Test 2: With custom style..."
GTK_ICON_THEME_NAME=Papirus wofi --show=drun --width=400 --height=300 --style=~/.config/wofi/style.css &

echo ""
echo "   Press Enter to continue to next test..."
read -r

# Test 3: Using launch script
echo "   Test 3: Using launch script..."
~/.config/hypr/scripts/LaunchWofi.sh &

echo ""
echo "   Press Enter to continue to next test..."
read -r

echo "🎉 Icon testing completed!"
echo ""
echo "💡 If icons still don't show, try these Fedora-specific solutions:"
echo "   1. Restart Hyprland: systemctl --user restart hyprland-session.target"
echo "   2. Check icon cache: gtk-update-icon-cache -f -t /usr/share/icons/Papirus"
echo "   3. Verify environment: echo \$GTK_ICON_THEME_NAME"
echo "   4. Try different icon themes: sudo dnf install breeze-icon-theme"
echo ""
echo "🎯 Current configuration:"
echo "   Icon Theme: Papirus"
echo "   Style: ~/.config/wofi/style.css"
echo "   Launch Script: ~/.config/hypr/scripts/LaunchWofi.sh"
