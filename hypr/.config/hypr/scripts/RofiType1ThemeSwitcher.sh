#!/bin/bash

# Rofi Type 1 Theme Switcher
# Switch between different Type 1 launcher themes

rofi_dir="$HOME/.config/rofi/launchers/type-1"
rofi_theme_dir="$HOME/.config/rofi/launchers/type-1"

# Available themes
themes=(
    "style-1.rasi:Style 1 - Classic"
    "style-2.rasi:Style 2 - Modern"
    "style-3.rasi:Style 3 - Elegant"
    "style-4.rasi:Style 4 - Minimal"
    "style-5.rasi:Style 5 - Dark"
    "style-6.rasi:Style 6 - Light"
    "style-7.rasi:Style 7 - Colorful"
    "style-8.rasi:Style 8 - Professional"
    "style-9.rasi:Style 9 - Artistic"
    "style-10.rasi:Style 10 - Futuristic"
    "style-11.rasi:Style 11 - Retro"
    "style-12.rasi:Style 12 - Clean"
    "style-13.rasi:Style 13 - Bold"
    "style-14.rasi:Style 14 - Subtle"
    "style-15.rasi:Style 15 - Premium"
)

# Function to show theme selection menu
show_theme_menu() {
    local msg="Choose a Type 1 Rofi theme:"
    local choice
    
    choice=$(printf '%s\n' "${themes[@]}" | rofi -dmenu -theme "$rofi_theme_dir/style-1.rasi" -i -p "$msg")
    
    if [[ -n "$choice" ]]; then
        local theme_file=$(echo "$choice" | cut -d: -f1)
        local theme_name=$(echo "$choice" | cut -d: -f2)
        
        # Update launcher script to use selected theme
        if [[ -f "$rofi_dir/launcher.sh" ]]; then
            sed -i "s|theme='style-[0-9]*'|theme='${theme_file%.rasi}'|" "$rofi_dir/launcher.sh"
            echo "✅ Applied theme: $theme_name"
            notify-send "Rofi Type 1 Theme" "Applied: $theme_name"
        else
            echo "❌ Launcher script not found at $rofi_dir/launcher.sh"
        fi
    fi
}

# Main execution
if command -v rofi &> /dev/null; then
    show_theme_menu
else
    echo "❌ Rofi is not installed!"
    exit 1
fi
