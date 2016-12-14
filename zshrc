fpath=(/usr/local/share/zsh-completions(N-/) $fpath)
autoload -Uz add-zsh-hook
autoload -Uz compinit && compinit

export EDITOR=vim
export LANG=ja_JP.UTF-8
export LS_COLORS='di=36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;46'
export GOPATH=${HOME}/.go

bindkey -d # キーバインドリセット
bindkey -e # emacsモード

alias be='bundle exec'
alias pag='ps aux | grep'
alias rake='noglob rake'
alias vg='vagrant'

setopt correct         # typo補完
setopt nobeep          # beep音鳴らさない
setopt no_flow_control # Ctrl+S / Ctrl+Q によるフロー制御を使わない
setopt ignoreeof       # Ctrl+D でログアウトしない

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 大文字小文字を区別しない
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} # 色付き補完

# 関数やコマンドが存在するかどうか
function executable {
  whence $@ &> /dev/null
}


# パスを読み込み

[ -f ~/.zshrc_path.local ] && source ~/.zshrc_path.local


# 移動

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias pd='popd'
alias cdgr='cd $(git rev-parse --show-toplevel)' # リポジトリのルートに移動

setopt auto_cd           # ディレクトリ名だけで移動
setopt auto_pushd        # pushdで移動
setopt pushd_ignore_dups # pushdの履歴は残さない


# 履歴
# zsh の history は fc -l のエイリアス

[ -z $HISTFILE ] && HISTFILE=$HOME/.zsh_history

HISTSIZE=10000 # メモリへの保存件数
SAVEHIST=10000 # ファイルへの保存件数

setopt extended_history       # タイムスタンプと実行時間を記録
setopt hist_expire_dups_first # 削除時に重複する履歴から削除
setopt hist_ignore_dups       # 直前の重複するコマンドは無視
setopt hist_ignore_space      # スペースから始まるコマンドは無視
setopt hist_verify            # 補完時に編集可能にする
setopt inc_append_history     # インクリメンタルサーチに追加
setopt share_history          # 端末間で履歴を共有


# Git

alias g='git'
compdef g=git

function inside-git-work-tree {
  git rev-parse --is-inside-work-tree &> /dev/null
}

alias gpl='git pull origin $(git current-branch)'
alias gps='git push origin $(git current-branch)'


# プロンプト

function prompt-git-status {
  local branch st color
  inside-git-work-tree || return

  branch=$(basename `git current-branch`)

  st=`git status 2> /dev/null`
  if [[ $st =~ 'nothing to commit' ]]; then
    color=%f
  elif [[ $st =~ 'untracked files present' ]]; then
    color=%F{yellow}
  else
    color=%F{red}
  fi

  echo "$color($branch)%f%b"
}

local face="%(?:%F{green}(^_^):%F{red}(>_<%)%s)%f"
PROMPT='${face}%M:%c$(prompt-git-status)$ '
SPROMPT='%F{yellow}(?_?)%fもしかして: %B%r%b [y/N/a/e]? '
RPROMPT='`date +"%Y/%m/%d(%a) %k:%M:%S"`'

setopt prompt_subst      # プロンプト文字列を評価する
setopt transient_rprompt # 古い右プロンプトを消す


# anyenv

if [[ -d "$HOME/.anyenv" ]]; then
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init -)"
fi


# peco

executable peco && source $HOME/.zshrc.peco


# OS固有設定

case "${OSTYPE}" in
darwin*)
  source $HOME/.zshrc.osx
  ;;
linux*)
  alias v='vim'
  alias l='ls -Flah --color'
  ;;
esac


# マシン固有設定

[ -f $HOME/.zshrc.local ] && source $HOME/.zshrc.local


true