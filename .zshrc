########################################
# 環境変数
export LANG=ja_JP.UTF-8
export PATH=$PATH:$HOME/tools
export PATH=$PATH:/usr/local/Cellar/vim/8.1.2200/bin/vim
# export PATH="/Users/nishio-kun/anaconda3/bin:$PATH"  # commented out by conda initialize
export PATH="/usr/local/opt/binutils/bin:$PATH"
export PATH=$PATH:~/.roswell/bin
export PATH=$PATH:~/flutter/bin

# 色を使用出来るようにする
autoload -Uz colors
colors

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=1000000

# プロンプト
# PROMPT="%{${fg[green]}%}%n%{${reset_color}%} %~
# %# "

# キーバインドを vi にする
bindkey -v

########################################
# 補完
# 補完機能を有効にする
autoload -Uz compinit
compinit

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'


########################################
# vcs_info
# autoload -Uz vcs_info
# autoload -Uz add-zsh-hook
# 
# zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
# zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'
# 
# function _update_vcs_info_msg() {
#     LANG=en_US.UTF-8 vcs_info
#     RPROMPT="${vcs_info_msg_0_}"
# }
# add-zsh-hook precmd _update_vcs_info_msg


########################################
# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# Ctrl+Dでzshを終了しない
setopt ignore_eof

# '#' 以降をコメントとして扱う
setopt interactive_comments

# ディレクトリ名だけでcdする
setopt auto_cd

# cd したら自動的にpushdする
setopt auto_pushd

# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 高機能なワイルドカード展開を使用する
setopt extended_glob

########################################
# キーバインド
# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward

########################################
# エイリアス

alias ls='ls -G -F'
alias la='ls -a'
alias ll='ls -l'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -p'

alias gs='git status'
alias gpp='git pull --prune'
alias glogr='git log --oneline --graph --remotes'
alias glog='git log --oneline --graph'

alias dcb='docker-compose build'
alias dcu='docker-compose up'
alias dcd='docker-compose down'

alias pyvenv='source venv/bin/activate'
alias cab='conda activate base'


export CLICOLOR=1

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/nishio-kun/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/nishio-kun/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/nishio-kun/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/nishio-kun/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


. /Users/nishio-kun/torch/install/bin/torch-activate

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/nishio-kun/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/nishio-kun/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/nishio-kun/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/nishio-kun/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

autoload -U promptinit; promptinit
prompt pure

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ghq と fzf を使って検索する。
function ghq-fzf() {
  local src=$(ghq list | fzf --preview "ls -laTp $(ghq root)/{} | tail -n+4 | awk '{print \$9\"/\"\$6\"/\"\$7 \" \" \$10}'")
  if [ -n "$src" ]; then
    BUFFER="cd $(ghq root)/$src"
    zle accept-line
  fi
  zle -R -c
}
zle -N ghq-fzf
bindkey '^]' ghq-fzf

# GitHub CLI の補完
eval "$(gh completion -s zsh)"
