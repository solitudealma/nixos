# Created by newuser for 5.9

# oh my zsh
# _OMZ_APPLY_CHPWD_HOOK行为
#  1. 载入时，会自动切换到上一次cd过的目录
#  2. 发生cd命令时，自动记录当前cd的目录(在缓存文件中)
export _OMZ_APPLY_CHPWD_HOOK=true
source ../omz/omz.zsh

export EDITOR=nvim
#export LC_ALL="C" #rofi需要
export LC_CTYPE="en_US.UTF-8"

host_ip="127.0.0.1"
port=7890
#host_ip="172.20.10.1"
#port=11209
PROXY_HTTP="http://${host_ip}:${port}"
PROXY_HTTPS="http://${host_ip}:${port}"
PROXY_SOCKS5="sockes5://${host_ip}:${port}"

export http_proxy="${PROXY_HTTP}"
export HTTP_PROXY="${PROXY_HTTP}"
export https_proxy="${PROXY_HTTPS}"
export HTTPS_PROXY="${PROXY_HTTPS}"
export ALL_PROXY="${PROXY_SOCKS5}"
export all_proxy="${PROXY_SOCKS5}"

export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS=\@im=fcitx5
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=ibus
export INPUT_METHOD=fcitx5

alias tmux="tmux -u"
alias scp=~/.ssh/scp.sh
alias ssh=~/.ssh/ssh.sh
alias pip="pip3"

function ya() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# Helpful aliases
alias  l='eza -lh  --icons=auto' # long list
alias ls='eza -1   --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias un='$aurhelper -Rns' # uninstall package
alias up='$aurhelper -Syu' # update system/package/aur
alias pl='$aurhelper -Qs' # list installed package
alias pa='$aurhelper -Ss' # list availabe package
alias pc='$aurhelper -Sc' # remove unused cache
alias po='$aurhelper -Qtdq | $aurhelper -Rns -' # remove unused packages, also try > $aurhelper -Qqd | $aurhelper -Rsu --print -
alias code='code --disable-gpu' # gui code editor

#Display Pokemon
#pokemon-colorscripts --no-title -r 1,3,6
