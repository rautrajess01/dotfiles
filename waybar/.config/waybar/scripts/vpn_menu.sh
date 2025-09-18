#!/usr/bin/env bash
set -euo pipefail

active_vpn=$(nmcli -t -f TYPE,NAME,DEVICE con show --active | awk -F: '$1=="vpn"{print $2; exit}')

case "${1:-status}" in
  status)
    if [[ -n "${active_vpn:-}" ]]; then
      echo "󰒋 ${active_vpn}"
    else
      echo "󰒋"
    fi
    ;;
  menu)
    mapfile -t vpns < <(nmcli -t -f NAME,TYPE connection show | awk -F: '$2=="vpn"{print $1}' | sort -u)
    if (( ${#vpns[@]} == 0 )); then
      notify-send "Waybar VPN" "No VPN profiles found" || true
      nm-connection-editor &>/dev/null &
      exit 0
    fi

    if command -v wofi >/dev/null 2>&1; then
      menu_cmd=(wofi --dmenu -p "VPN" --style "$HOME/.config/wofi/style.css")
    elif command -v rofi >/dev/null 2>&1; then
      menu_cmd=(rofi -dmenu -i -p "VPN" -theme "$HOME/.config/waybar/rofi/modern-menu.rasi")
    else
      nm-connection-editor &>/dev/null &
      exit 0
    fi

    choices=()
    if [[ -n "${active_vpn:-}" ]]; then
      choices+=("⏏ Disconnect ${active_vpn}")
    fi
    for n in "${vpns[@]}"; do choices+=("${n}"); done

    selection=$(printf '%s\n' "${choices[@]}" | "${menu_cmd[@]}")
    [[ -z "${selection}" ]] && exit 0

    if [[ "${selection}" == ⏏* ]]; then
      nmcli con down id "${active_vpn}" || true
    else
      nmcli con up id "${selection}" || nmcli con up uuid "${selection}" || true
    fi
    ;;
  *)
    echo "Usage: $0 [status|menu]" >&2
    exit 1
    ;;
 esac
