#alias
#source $ZDOTDIR/.zshaliases
#alias
alias gcc='gcc -Wall -g'
alias ls='ls -FCGBa --color'
alias ll='ls -la --color'
alias less='less -sIx4FRM'
#alias less='less -sIx4XFR'

function memogrep(){
    $HOME/git/memogrep/memogrep.py -i -q "$HOME/Library/Containers/com.happenapps.Quiver/Data/Library/Application Support/Quiver/Quiver.qvlibrary" $@ | less
}

function cdls(){
    \cd $1
    ls;
}
alias cd='cdls'
alias makec='make clean all'
alias grep='grep -i --color'
alias df='df -h'
alias ipy='ipython --pylab'
alias ps='ps auxw'
function del () {
    mv $* ~/.Trash/
}
alias poi='del'
#alias ps='ps --sort==start_time'
#alias rm='rm -i'
#unalias rm
#emacs
#alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs -nw'
#vim
#alias vim='/opt/local/bin/vim'
#alias vi='/opt/local/bin/vim'

#alias cleardesktop='defaults write com.apple.finder CreateDesktop -boolean false'
#alias appeardesktop='defaults write com.apple.finder CreateDesktop -boolean true'


SAVEHIST=100000       #ヒストリ数
HISTSIZE=100000
#HISTFILE=~$ZDOTDIR/.zhistory
#HISTFILE=~/.zhistory:.
HISTFILE=~/.zhistory

WORDCHARS=']$'             #/を区切り文字として設定

autoload -U colors      #プロンプトの色
colors
PS1="%{${reset_color}%}%{${fg[green]}%}tokkuman%{${reset_color}%}%# "
RPS1="%{${reset_color}%}[%{${fg[green]}%}%/%{${reset_color}%}][%{${fg[green]}%}%*%{${reset_color}%}]"
autoload -U compinit promptinit
#補完機能
compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  #大文字と小文字の区別をなくす

setopt IGNORE_EOF          #ignore logout when C-d
setopt SHARE_HISTORY       #share history
setopt HIST_NO_STORE       #exclude history from saving in zhistory
setopt HIST_IGNORE_DUPS    #exclude previous same command from saving in zhistory
setopt HIST_IGNORE_SPACE   #exclude command starts from blank space from saving in zhistory
setopt CHECK_JOBS          #check jobs at shell of the end
setopt AUTO_RESUME         #Letter specifying the job of running
setopt NO_CLOBBER          #overwrite warning of file
setopt AUTO_CD             #auto-cd
setopt BG_NICE             #lower the priority of BG
setopt ALL_EXPORT          #auto export shell valiable to environment valiable
setopt NO_HUP              #nohup
cdpath=(.. ~ ~/src)

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
#eval $(gdircolors)
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}for f in `jot - 60 0 -1`;do printf "Please Wait:%8d" $f;sleep 1;done


function getDefaultBrowser() {
  preffile=$HOME/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure
  if [ ! -f ${preffile}.plist ]; then
    preffile=$HOME/Library/Preferences/com.apple.LaunchServices
  fi
  # browser might be "com.apple.safari", "org.mozilla.firefox" or "com.google.chrome".
  browser=$(defaults read ${preffile} | grep -B 1 "https" | awk '/LSHandlerRoleAll/{ print $NF }' | sed -e 's/"//g;s/;//')
  echo $browser
}

function gitblit() {
  nsip=$(host fun.bio.keio.ac.jp | head -1 | awk '{print $4}')
  browser=$(getDefaultBrowser)
  if [ ${browser} = "com.google.chrome" ]; then
    browser="org.mozilla.firefox"
  fi
  if [ ${nsip} = 192.168.11.2 ]; then
    # in FUNALAB private network
    open -b ${browser} http://fun.bio.keio.ac.jp:8080
  else
    # outside FUNALAB
    open -b org.mozilla.firefox https://fun.bio.keio.ac.jp:8443
  fi
  unset nsip
  unset browser
}
