#!/bin/bash

# 1. 检查是否开启了勿扰模式 (DND)
if makoctl mode | grep -q 'dnd'; then
  echo '{"text": "MSG:DND", "class": "dnd"}'
  exit 0
fi

# 2. 绕过 makoctl，直接通过 D-Bus 截取 Mako 的底层 JSON 数据
# busctl 会调用 /fr/emersion/Mako 接口的 ListNotifications 方法，返回极其纯净的 JSON 字符串
count=$(busctl --user call org.freedesktop.Notifications /fr/emersion/Mako fr.emersion.Mako ListNotifications 2>/dev/null | grep -o '"id"' | wc -l)

# 3. 根据数量输出给 Waybar
if [ "$count" -gt 0 ]; then
  echo '{"text": "MSG:'$count'", "class": "unread"}'
else
  echo '{"text": "MSG:0", "class": "idle"}'
fi
