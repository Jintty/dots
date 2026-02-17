if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting "Hi, Jin."

zoxide init fish | source
direnv hook fish | source

alias ff="fastfetch"
alias ls="lsd -la"
alias lg="lazygit"
alias gdb="gdb -q"
alias cat="bat"
alias cdh="cd ~"
alias cdw="cd ~/workspace/"

# Check or Query installed packages.
alias lspkg="paru -Qe"
alias lshist="grep 'installed' /var/log/pacman.log | tail -n 20"
alias fzpkg="paru -Qq | fzf --preview 'paru -Qil {}' --layout=reverse"

# lazygit manage dotfiles
alias lgdot='lazygit --git-dir=$HOME/.dots/ --work-tree=$HOME'
# bare git
function dot
    /usr/bin/git --git-dir=$HOME/.dots/ --work-tree=$HOME $argv
end

function wifi
    # 1. 获取列表
    # -t: 机器可读模式 (用冒号分隔)
    # -f: 指定字段 (SSID, 信号条, 加密)
    # awk: 简单的格式化，让 fzf 显示得好看一点，同时保留原始 SSID 在行首以便提取
    # 格式化后长这样: "MyWiFi  |  ▂▄▆_  |  WPA2"
    set -l list (nmcli -t -f SSID,BARS,SECURITY device wifi list | \
        awk -F: '{printf "%-30s  %s  %s\n", $1, $2, $3}' | \
        fzf --height 40% --layout=reverse --header "Select WiFi (Ctrl+C to cancel)" --cycle)

    if test -z "$list"
        return
    end

    # 2. 提取 SSID (极度稳健)
    # 逻辑：取前30个字符 -> 去掉尾部空格
    # 因为我们在 awk 里用了 "%-30s"，所以前30位一定是 SSID (含填充空格)
    set -l ssid (string sub -l 30 -- "$list" | string trim)

    if test -n "$ssid"
        echo "Target: [$ssid]"

        # 3. 连接逻辑
        # --ask: 强制在终端询问密码，解决 "Secrets were required" 报错
        # 加上 time 还能顺便看下连接耗时
        time nmcli --ask device wifi connect "$ssid"
    end
end

# --- GDB Modes (XDG Config) ---
alias gef='gdb -q -x ~/.config/gdb/gef.gdb'
alias pwn='gdb -q -x ~/.config/gdb/pwndbg.gdb'

# ZVM
set -gx ZVM_INSTALL "$HOME/.zvm/self"
set -gx PATH $PATH "$HOME/.zvm/bin"
set -gx PATH $PATH "$ZVM_INSTALL/"

# list fonts
alias lsfonts='fc-list --format="%{family[0]}\n" | sort -u | fzf'
