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

# Tool-specific environment variables (conditionally loaded)
if command -v tesseract >/dev/null 2>&1; then
  export TESSDATA_PREFIX=/opt/homebrew/share/
fi

# Build environment for Python compilation (asdf python builds)
if [[ $(uname -m) == "arm64" ]]; then
  export LDFLAGS="-L/opt/homebrew/opt/zlib/lib -L/opt/homebrew/opt/sqlite/lib -L/opt/homebrew/opt/openssl/lib -L/opt/homebrew/opt/readline/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/zlib/include -I/opt/homebrew/opt/sqlite/include -I/opt/homebrew/opt/openssl/include -I/opt/homebrew/opt/readline/include"
  export PKG_CONFIG_PATH="/opt/homebrew/opt/zlib/lib/pkgconfig:/opt/homebrew/opt/sqlite/lib/pkgconfig:/opt/homebrew/opt/openssl/lib/pkgconfig:/opt/homebrew/opt/readline/lib"
fi
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
# 補完設定
autoload -Uz compinit

# Completion cache optimization
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Completion paths
fpath=(~/.zfunc $fpath)
if [[ $(uname -m) == "arm64" ]]; then
  fpath+=("/opt/homebrew/share/zsh/site-functions")
else
  fpath+=("/usr/local/share/zsh/site-functions")
fi

# Completion styles
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

# Simple two-line prompt with git info
PROMPT='%F{cyan}%n@%m%f %F{blue}%~%f
%F{green}❯%f '

# Git branch display on right side
function git_branch_name() {
  local branch
  if branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null); then
    if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
      echo "%F{red}⚡ $branch%f"
    else
      echo "%F{green}✓ $branch%f"
    fi
  fi
}

RPROMPT='$(git_branch_name)'

########################################
# エイリアス
# File operations
alias ls='ls -G -F'
alias la='ls -la'
alias ll='ls -l'
alias l='ls -CF'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'

# Git shortcuts
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull --prune'
alias glog='git log --oneline --graph'
alias glogr='git log --oneline --graph --remotes'
alias gd='git diff'
alias gb='git branch'

# Docker shortcuts
alias d='docker'
alias dc='docker-compose'
alias dcb='docker-compose build'
alias dcu='docker-compose up'
alias dcd='docker-compose down'

# Python/Conda shortcuts
alias py='python3'
alias pip='pip3'
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
