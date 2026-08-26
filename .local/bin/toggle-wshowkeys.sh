#!/usr/bin/env bash
set -euo pipefail

PIDFILE="${XDG_RUNTIME_DIR:-/tmp}/wshowkeys.pid"

notify() {
    notify-send -a "wshowkeys" "$1" "${2:-}"
}

# --- If wshowkeys is already running, stop it ---
if [[ -f "$PIDFILE" ]] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
    PID="$(cat "$PIDFILE")"
    kill "$PID"
    rm -f "$PIDFILE"
    notify "Keystroke display disabled"
    exit 0
fi

# --- Otherwise, start wshowkeys ---
wshowkeys \
    -a bottom \
    -F 'JetBrains Mono 60' \
    </dev/null >/dev/null 2>&1 &

echo $! > "$PIDFILE"
notify "Keystroke display enabled" "Super + Shift + K to disable"
