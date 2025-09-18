#!/usr/bin/env bash
set -euo pipefail

# Colors for better visual appeal
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

if ! command -v nmcli >/dev/null 2>&1; then
  notify-send "Waybar Wi-Fi" "NetworkManager (nmcli) not found" || true
  exit 1
fi

wifi_iface=$(nmcli -t -f DEVICE,TYPE device status | awk -F: '$2=="wifi"{print $1; exit}')
if [[ -z "${wifi_iface:-}" ]]; then
  notify-send "Waybar Wi-Fi" "No Wi-Fi interface detected" || true
  exit 0
fi

active_ssid=$(nmcli -t -f NAME,TYPE con show --active | awk -F: '$2=="wifi"{print $1; exit}')

# Function to get the best available launcher
get_launcher() {
  # Priority order: rofi > wofi > nm-connection-editor
  if command -v rofi >/dev/null 2>&1; then
    echo "rofi"
  elif command -v wofi >/dev/null 2>&1; then
    echo "wofi"
  else
    echo "nm-connection-editor"
  fi
}

# Function to get launcher command with proper styling
get_launcher_cmd() {
  local launcher="$1"
  case "$launcher" in
    "rofi")
      # Check if custom theme exists, otherwise use default
      if [[ -f "$HOME/.config/waybar/rofi/wifi-menu.rasi" ]]; then
        echo "rofi -dmenu -i -p 'Wi-Fi Networks' -theme '$HOME/.config/waybar/rofi/wifi-menu.rasi' -width 400"
      elif [[ -f "$HOME/.config/waybar/rofi/modern-menu.rasi" ]]; then
        echo "rofi -dmenu -i -p 'Wi-Fi Networks' -theme '$HOME/.config/waybar/rofi/modern-menu.rasi' -width 400"
      else
        echo "rofi -dmenu -i -p 'Wi-Fi Networks' -width 400 -theme Arc-Dark"
      fi
      ;;
    "wofi")
      # Check if custom style exists, otherwise use default
      if [[ -f "$HOME/.config/wofi/style.css" ]]; then
        echo "wofi --dmenu -p 'Wi-Fi Networks' --style '$HOME/.config/wofi/style.css' --width 400"
      else
        echo "wofi --dmenu -p 'Wi-Fi Networks' --width 400"
      fi
      ;;
    *)
      echo "nm-connection-editor"
      ;;
  esac
}

# Function to get password prompt command
get_password_cmd() {
  local launcher="$1"
  case "$launcher" in
    "rofi")
      if [[ -f "$HOME/.config/waybar/rofi/wifi-menu.rasi" ]]; then
        echo "rofi -dmenu -password -p 'Password for %s' -theme '$HOME/.config/waybar/rofi/wifi-menu.rasi' -width 300"
      elif [[ -f "$HOME/.config/waybar/rofi/modern-menu.rasi" ]]; then
        echo "rofi -dmenu -password -p 'Password for %s' -theme '$HOME/.config/waybar/rofi/modern-menu.rasi' -width 300"
      else
        echo "rofi -dmenu -password -p 'Password for %s' -width 300 -theme Arc-Dark"
      fi
      ;;
    "wofi")
      if [[ -f "$HOME/.config/wofi/style.css" ]]; then
        echo "wofi --dmenu -P -p 'Password for %s' --style '$HOME/.config/wofi/style.css' --width 300"
      else
        echo "wofi --dmenu -P -p 'Password for %s' --width 300"
      fi
      ;;
    *)
      echo "zenity --password --title='Wi-Fi Password' --text='Enter password for %s:'"
      ;;
  esac
}

case "${1:-menu}" in
  menu|refresh)
    launcher=$(get_launcher)
    
    # If no good launcher available, fall back to nm-connection-editor
    if [[ "$launcher" == "nm-connection-editor" ]]; then
      nm-connection-editor &>/dev/null &
      exit 0
    fi
    
    launcher_cmd=$(get_launcher_cmd "$launcher")
    password_cmd=$(get_password_cmd "$launcher")
    
    tmpmap=$(mktemp)
    # Fast list (no rescan) for instant popup; full rescan on "refresh"
    rescan_mode="no"
    [[ "${1:-menu}" == "refresh" ]] && rescan_mode="yes"
    
    # Get wifi list with better formatting
    while IFS=: read -r inuse ssid security signal; do
      [[ -z "${ssid}" ]] && ssid="(hidden)"
      [[ -z "${signal}" ]] && signal=0
      
      # Better icons for security and connection status
      lock_icon=""
      if [[ -n "${security}" && "${security}" != "--" && "${security}" != "OPEN" ]]; then
        lock_icon="󰌾"  # Modern lock icon
      fi
      
      # Better connection status indicator
      status_icon="  "
      if [[ "${inuse}" == "*" ]]; then
        status_icon="󰤢"  # Modern wifi connected icon
      fi
      
      # Format display with better spacing and icons
      display="${status_icon} ${ssid} ${lock_icon}"
      printf '%s\t%s\n' "$display" "$ssid" >>"$tmpmap"
    done < <(nmcli -t -f IN-USE,SSID,SECURITY,SIGNAL device wifi list ifname "$wifi_iface" --rescan "$rescan_mode" | sed 's/::/:OPEN:/' )

    # Add disconnect option if connected
    if [[ -n "${active_ssid:-}" ]]; then
      printf '%s\t%s\n' "⏏ Disconnect from ${active_ssid}" "__DISCONNECT__" >>"$tmpmap"
    fi
    
    # Add refresh option
    printf '%s\t%s\n' "🔄 Refresh Networks" "__REFRESH__" >>"$tmpmap"
    
    # Add network settings option
    printf '%s\t%s\n' "⚙️ Network Settings" "__SETTINGS__" >>"$tmpmap"

    # Show the menu
    selection=$(cut -f1 "$tmpmap" | eval "$launcher_cmd")
    [[ -z "${selection}" ]] && { rm -f "$tmpmap"; exit 0; }

    target=$(awk -F '\t' -v sel="${selection}" '$1==sel{print $2; exit}' "$tmpmap")
    rm -f "$tmpmap"

    case "$target" in
      "__DISCONNECT__")
        nmcli device disconnect "$wifi_iface" || true
        notify-send "Wi-Fi" "Disconnected from ${active_ssid}" || true
        exit 0
        ;;
      "__REFRESH__")
        # Recursively call with refresh
        exec "$0" refresh
        ;;
      "__SETTINGS__")
        nm-connection-editor &>/dev/null &
        exit 0
        ;;
      *)
        # Try to connect to the selected network
        if nmcli device wifi connect "$target" ifname "$wifi_iface" >/dev/null 2>&1; then
          notify-send "Wi-Fi" "Connected to ${target}" || true
          exit 0
        else
          # Prompt for password
          pass=""
          if [[ "$launcher" == "rofi" ]]; then
            pass=$(printf "$password_cmd" "$target" | eval "$launcher_cmd")
          elif [[ "$launcher" == "wofi" ]]; then
            pass=$(printf "$password_cmd" "$target" | eval "$launcher_cmd")
          else
            pass=$(printf "$password_cmd" "$target" | bash)
          fi
          
          [[ -z "${pass}" ]] && exit 1
          
          if nmcli device wifi connect "$target" ifname "$wifi_iface" password "$pass" >/dev/null 2>&1; then
            notify-send "Wi-Fi" "Connected to ${target}" || true
          else
            notify-send "Wi-Fi" "Failed to connect to ${target}" || true
          fi
          exit 0
        fi
        ;;
    esac
    ;;
  *)
    echo "Usage: $0 [menu|refresh]" >&2
    exit 1
    ;;
esac
