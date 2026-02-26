#!/usr/bin/env bash
set -euo pipefail

# 找到第一个可读的 fan*_input（也可以把 head -n1 改成你想固定的 fan1_input）
fan_file="$(ls /sys/class/hwmon/hwmon*/fan*_input 2>/dev/null | head -n1 || true)"

if [[ -z "${fan_file}" || ! -r "${fan_file}" ]]; then
  echo "FAN ?"
  exit 0
fi

rpm="$(cat "$fan_file" 2>/dev/null || echo 0)"
rpm="${rpm:-0}"

# rpm 可能不是纯数字的话兜底
if ! [[ "$rpm" =~ ^[0-9]+$ ]]; then
  echo "FAN ?"
  exit 0
fi

if [[ "$rpm" -eq 0 ]]; then
  echo "FAN:off"
  exit 0
fi

# 缩写：>=1000 显示 3.2k；否则显示 850
if [[ "$rpm" -ge 1000 ]]; then
  # 保留 1 位小数：3200 -> 3.2k
  # 用 awk 避免 bash 浮点痛苦
  short="$(awk -v r="$rpm" 'BEGIN{printf "%.1fk", r/1000.0}')"
  # 去掉 3.0k 这种多余的 .0 -> 3k
  short="${short/\.0k/k}"
  echo "FAN:$short"
else
  echo "FAN:${rpm}"
fi
