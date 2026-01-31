#!/bin/bash

# 使用方法: ./animate.sh ghost (默认) 或 ./animate.sh pacman
MODE=${1:-ghost}

# --- 图标选择 ---
if [ "$MODE" == "pacman" ]; then
  icon="ᗧ" # 吃豆人
elif [ "$MODE" == "ghost" ]; then
  icon="󱙝" # 幽灵 (Nerd Font)
  # icon="👻" # 如果你喜欢 Emoji 版本
else
  icon="😽" # 保留猫咪作为彩蛋
fi

# --- 瞌睡动画逻辑 (通用) ---
# 节奏：慢吸气 -> 熟睡停顿 -> 慢呼气
frames=(
  "$icon    "  # 4个空格
  "$icon z   " # z + 3个空格
  "$icon zz  " # zz + 2个空格
  "$icon zzZ " # zzZ + 1个空格
  "$icon zzZ " # (停顿)
  "$icon zzZ " # (停顿)
  "$icon zz  " # 慢慢呼气
  "$icon z   "
)

while true; do
  for frame in "${frames[@]}"; do
    echo "$frame"
    sleep 0.8
  done
done
