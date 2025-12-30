#!/bin/bash

# 1. 获取当前硬件主音量状态
# Master 通道通常控制 F1 的 LED
IS_ON=$(amixer -c 1 get Master | grep "\[on\]")

if [ -n "$IS_ON" ]; then
  # === 当前是开启状态，执行静音 ===

  # 1. 底层关硬件 (让 LED 亮起)
  amixer -c 1 set Master mute

  # 2. 上层通知 PipeWire (让 Waybar 图标变静音)
  # 注意这里是 SINK (输出设备)
  wpctl set-mute @DEFAULT_AUDIO_SINK@ 1

else
  # === 当前是静音状态，执行开启 ===

  # 1. 底层开硬件 (让 LED 熄灭)
  amixer -c 1 set Master unmute

  # 2. 上层通知 PipeWire
  wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
fi
