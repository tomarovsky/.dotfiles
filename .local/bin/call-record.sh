#!/usr/bin/env bash
set -euo pipefail

PIDFILE="${XDG_RUNTIME_DIR:-/tmp}/call-record.pid"
OUTDIR="$HOME/Music"

notify() {
    notify-send -a "Call Recorder" "$1" "${2:-}"
}

# --- If a recording is already running, stop it ---
if [[ -f "$PIDFILE" ]] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
    PID="$(cat "$PIDFILE")"
    kill -INT "$PID"
    rm -f "$PIDFILE"
    notify "Recording stopped" "Saved to ~/Music/"
    exit 0
fi

# --- Otherwise, start a new recording ---
mkdir -p "$OUTDIR"
MIC="$(pactl get-default-source)"
MONITOR="$(pactl get-default-sink).monitor"
OUTFILE="$OUTDIR/call_$(date +%Y%m%d_%H%M%S).mp3"

ffmpeg -nostdin -loglevel error \
    -f pulse -i "$MONITOR" -f pulse -i "$MIC" \
    -filter_complex "amix=inputs=2:duration=longest:normalize=0" \
    -ac 2 -c:a libmp3lame -b:a 192k \
    "$OUTFILE" </dev/null >/dev/null 2>&1 &

echo $! > "$PIDFILE"
notify "Recording started" "$(basename "$OUTFILE")"
