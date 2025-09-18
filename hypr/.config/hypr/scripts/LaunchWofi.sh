#!/bin/bash

# Fedora Wofi Launcher with Icon Support
# This script sets proper environment variables for Wofi to display icons

# Set icon theme environment variables
export GTK_ICON_THEME_NAME="Papirus"
export GTK_THEME_NAME="Adwaita-dark"
export GTK_APPLICATION_PREFER_DARK_THEME="true"

# Set additional Fedora-specific variables
export XDG_CURRENT_DESKTOP="Hyprland"
export XDG_SESSION_TYPE="wayland"
export QT_QPA_PLATFORM="wayland"

# Launch Wofi with proper configuration
wofi --show=drun \
     --width=500 \
     --height=400 \
     --style=~/.config/wofi/style.css
