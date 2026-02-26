source /usr/share/gef/gef.py

# 1. 设置 GDB 原生历史路径
set history save on
set history size 10000
set history remove-duplicates unlimited
set history filename ~/.local/state/gdb/gdb_history_gef

# 2. 设置 GEF 特有的 readline 历史 (防止生成 ~/.gef_history)
# 注意：这行是 GEF 的专用命令，不是标准 GDB 命令
gef config gef.readline_history_path ~/.local/state/gdb/gef_history
