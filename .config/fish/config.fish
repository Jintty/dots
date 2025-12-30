if status is-interactive
    # Commands to run in interactive sessions can go here
end

set fish_greeting "~0.o~"

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
    # 1. 扫描并用 fzf 显示列表
    # -SSID: 只显示 SSID
    # -SECURITY: 显示加密方式
    # -BARS: 显示信号强度
    set -l ssid (nmcli --color=yes device wifi list | fzf --ansi --height 40% --layout=reverse --header "Select WiFi Network" | awk '{print $2}')

    if test -n "$ssid"
        # 2. 如果选中的是已保存的网络，直接 Up
        if nmcli connection show "$ssid" >/dev/null 2>&1
            echo "🔄 Connecting to saved network: $ssid..."
            nmcli connection up "$ssid"
        else
            # 3. 如果是新网络，尝试连接（通常会触发密码提示）
            echo "✨ Connecting to new network: $ssid..."
            nmcli device wifi connect "$ssid"
        end
    end
end
