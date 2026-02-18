#!/bin/bash

MODE=${1:-ghost}
icon="󱙝"

frames=(
  "$icon     "
  "$icon z   "
  "$icon zz  "
  "$icon zzZ "
)

while true; do
  for frame in "${frames[@]}"; do
    echo "$frame"
    sleep 1
  done
done
