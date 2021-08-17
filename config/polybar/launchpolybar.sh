#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

echo "---" | tee -a /tmp/polybarTop.log /tmp/polybarBottom.log

# Launch topBar and bottomBar and create logs for eache
polybar top 2>&1 | tee -a /tmp/polybarTop.log & disown
polybar bottom 2>&1 | tee -a /tmp/polybarBottom.log & disown

echo "Bars launched..."
