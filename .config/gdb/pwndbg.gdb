source /usr/share/pwndbg/gdbinit.py

set history save on
set history size 10000
set history remove-duplicates unlimited
# 给 pwndbg 一个独立的历史文件，防止和 gef 混淆
set history filename ~/.local/state/gdb/gdb_history_pwndbg
