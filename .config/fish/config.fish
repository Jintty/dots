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

# --- GDB Modes (XDG Config) ---
alias gef='gdb -q -x ~/.config/gdb/gef.gdb'
alias pwn='gdb -q -x ~/.config/gdb/pwndbg.gdb'

# ZVM
set -gx ZVM_INSTALL "$HOME/.zvm/self"
set -gx PATH $PATH "$HOME/.zvm/bin"
set -gx PATH $PATH "$ZVM_INSTALL/"

# list fonts
alias lsfonts='fc-list --format="%{family[0]}\n" | sort -u | fzf'

# impala
alias wifi='impala'
