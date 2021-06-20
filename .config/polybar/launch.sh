#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# If all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch top bar 
# echo "---" | tee -a /tmp/topbar.log
# polybar top 2>&1 | tee -a /tmp/topbar.log & disown

polybar top &

echo "Polybar launched..."
