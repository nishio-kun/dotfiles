########################################
# 環境変数
export LANG=ja_JP.UTF-8
export CLICOLOR=1

# Architecture-specific PATH settings
if [[ $(uname -m) == "arm64" ]]; then
  # Apple Silicon
  export PATH="/opt/homebrew/opt/binutils/bin:$PATH"
  export PATH="/opt/homebrew/opt/tcl-tk/bin:$PATH"
else
  # Intel Mac
  export PATH="/usr/local/opt/binutils/bin:$PATH"
fi

# Tool-specific PATH settings
export PATH="$HOME/.poetry/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Tesseract OCR
export TESSDATA_PREFIX=/opt/homebrew/share/

# コンパイル環境（asdf pythonビルド用）
export LDFLAGS="-L/opt/homebrew/opt/zlib/lib -L/opt/homebrew/opt/sqlite/lib -L/opt/homebrew/opt/openssl/lib -L/opt/homebrew/opt/readline/lib"
export CPPFLAGS="-I/opt/homebrew/opt/zlib/include -I/opt/homebrew/opt/sqlite/include -I/opt/homebrew/opt/openssl/include -I/opt/homebrew/opt/readline/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/zlib/lib/pkgconfig:/opt/homebrew/opt/sqlite/lib/pkgconfig:/opt/homebrew/opt/openssl/lib/pkgconfig:/opt/homebrew/opt/readline/lib"
export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)

########################################
# asdf（Homebrewインストール版：Go実装対応）
. /opt/homebrew/opt/asdf/libexec/asdf.sh

########################################
# conda（Miniforge）
__conda_setup="$('$HOME/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

########################################
# Google Cloud SDK
if [ -f '$HOME/google-cloud-sdk/path.zsh.inc' ]; then . '$HOME/google-cloud-sdk/path.zsh.inc'; fi
if [ -f '$HOME/google-cloud-sdk/completion.zsh.inc' ]; then . '$HOME/google-cloud-sdk/completion.zsh.inc'; fi

########################################
# 補完
autoload -Uz compinit
fpath+=~/.zfunc
fpath+=("/opt/homebrew/share/zsh/site-functions")
compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' ignore-parents parent pwd ..
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'

########################################
# ヒストリ
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=1000000

########################################
# オプション
setopt print_eight_bit
setopt no_beep
setopt no_flow_control
setopt ignore_eof
setopt interactive_comments
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt extended_glob

########################################
# キーバインド
bindkey -v
bindkey '^R' history-incremental-pattern-search-backward

########################################
# プロンプト設定
setopt prompt_subst
fpath=(~/.zsh/completion $fpath)

function left-prompt {
  name_t='179m%}'
  name_b='000m%}'
  path_t='255m%}'
  path_b='031m%}'
  arrow='087m%}'
  text_color='%{\e[38;5;'
  back_color='%{\e[30;48;5;'
  reset='%{\e[0m%}'
  sharp="\uE0B0"

  user="${back_color}${name_b}${text_color}${name_t}"
  dir="${back_color}${path_b}${text_color}${path_t}"
  echo "${user}%n%#@%m${back_color}${path_b}${text_color}${name_b}${sharp} ${dir}%~${reset}${text_color}${path_b}${sharp}${reset}\n${text_color}${arrow}> ${reset}"
}

PROMPT='`left-prompt`'

function precmd() {
  if [ -z "$NEW_LINE_BEFORE_PROMPT" ]; then
      NEW_LINE_BEFORE_PROMPT=1
  elif [ "$NEW_LINE_BEFORE_PROMPT" -eq 1 ]; then
      echo ""
  fi
}

function rprompt-git-current-branch {
  local branch_name st branch_status
  branch='\ue0a0'
  color='%{\e[38;5;'
  green='114m%}'
  red='001m%}'
  yellow='227m%}'
  blue='033m%}'
  reset='%{\e[0m%}'

  if [ ! -e  ".git" ]; then return; fi
  branch_name=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  st=$(git status 2>/dev/null)

  if [[ -n $(echo "$st" | grep "^nothing to") ]]; then
    branch_status="${color}${green}${branch}"
  elif [[ -n $(echo "$st" | grep "^Untracked files") ]]; then
    branch_status="${color}${red}${branch}?"
  elif [[ -n $(echo "$st" | grep "^Changes not staged for commit") ]]; then
    branch_status="${color}${red}${branch}+"
  elif [[ -n $(echo "$st" | grep "^Changes to be committed") ]]; then
    branch_status="${color}${yellow}${branch}!"
  elif [[ -n $(echo "$st" | grep "^rebase in progress") ]]; then
    echo "${color}${red}${branch}!(no branch)${reset}"
    return
  else
    branch_status="${color}${blue}${branch}"
  fi

  echo "${branch_status}$branch_name${reset}"
}

RPROMPT='`rprompt-git-current-branch`'

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

alias cab='conda activate base'

########################################
# fzf + ghq
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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

# GitHub CLI 補完
eval "$(gh completion -s zsh)"

# Python version management - using asdf (pyenv settings removed for consistency)
# Note: pyenv and asdf conflict, using asdf as primary tool

# Node.js version management
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
