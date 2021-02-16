export PATH="/opt/local/libexec/gnubin:/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/local/lib:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"
#export PATH="$PYENV_ROOT/bin:$PATH"

export LANG="ja_JP.UTF-8"
export EDITOR='emacs' #-nw

export LESS='-R'
export LESSOPEN='|lessfilter.sh %s'
export BAT_THEME="OneHalfDark"
export GIT_PAGER='bat --style=plain'

# disturb path_helper
setopt no_global_rcs
