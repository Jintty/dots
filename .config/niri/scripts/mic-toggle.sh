#!/bin/bash

# 1. 获取当前硬件录音状态
# 我们以 amixer (底层硬件/LED控制者) 为准
# grep "\[on\]" 表示当前是开启(录音)状态
IS_ON=$(amixer -c 1 get Capture | grep "\[on\]")

if [ -n "$IS_ON" ]; then
  # === 当前是开启状态，我们要执行静音 (Mute) ===

  # 1. 底层关硬件 (让 LED 亮起)
  # nocap = No Capture (停止录音)
  amixer -c 1 set Capture nocap

  # 2. 上层通知 PipeWire (让 Waybar 图标变红)
  # 1 = Mute (静音)
  wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1

  # (可选) 发个通知确认
  # notify-send -t 1000 "Microphone" "Muted 🔴"

else
  # === 当前是静音状态，我们要执行开启 (Unmute) ===

  # 1. 底层开硬件 (让 LED 熄灭)
  # cap = Capture (开始录音)
  amixer -c 1 set Capture cap

  # 2. 上层通知 PipeWire (让 Waybar 图标恢复)
  # 0 = Unmute (取消静音)
  wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0

  # (可选) 发个通知确认
  # notify-send -t 1000 "Microphone" "Unmuted 🟢"
fi
