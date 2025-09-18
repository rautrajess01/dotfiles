#!/bin/bash

# Wofi Theme Switcher
# Switch between different Wofi themes

wofi_config="$HOME/.config/wofi/config"
wofi_style_dir="$HOME/.config/wofi"

# Available themes
themes=(
    "style.css:macOS Spotlight Theme"
    "style-modern.css:Purple & Gold Theme"
    "style-premium.css:Ultra-Premium Glass Theme"
)

# Function to show theme selection menu
show_theme_menu() {
    local msg="Choose a Wofi theme:"
    local choice
    
    choice=$(printf '%s\n' "${themes[@]}" | GTK_ICON_THEME_NAME=Papirus wofi --dmenu --prompt "$msg" --style "$wofi_style_dir/style.css")
    
    if [[ -n "$choice" ]]; then
        local theme_file=$(echo "$choice" | cut -d: -f1)
        local theme_name=$(echo "$choice" | cut -d: -f2)
        
        # Update wofi config to use selected theme
        if [[ -f "$wofi_config" ]]; then
            sed -i "s|style = .*|style = $wofi_style_dir/$theme_file|" "$wofi_config"
            echo "✅ Applied theme: $theme_name"
            notify-send "Wofi Theme" "Applied: $theme_name"
        else
            echo "❌ Wofi config not found at $wofi_config"
        fi
    fi
}

# Main execution
if command -v wofi &> /dev/null; then
    show_theme_menu
else
    echo "❌ Wofi is not installed!"
    exit 1
fi
