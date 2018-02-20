#ZDOTDIR=$HOME/.zsh
export PYENV_ROOT=$HOME/.pyenv
export PATH="$PYENV_ROOT/bin:/opt/local/libexec/gnubin:/opt/local/bin:/usr/local/bin:/opt/local/sbin:/usr/local/lib:$PATH"
export LANG="ja_JP.UTF-8"
#export PYTHONPATH='/Library/Python/2.7/site-packages:$PYTHONPATH'
export PYTHONPATH='/opt/local/libexec/gnubin:/opt/local/bin:$PYTHONPATH'
export EDITOR='emacs' #-nw
export LESS='-R'
export LESSOPEN='| /opt/local/bin/src-hilite-lesspipe.sh %s'
# disturb path_helper
setopt no_global_rcs