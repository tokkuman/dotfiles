alias gcc='gcc -Wall -g'
alias ls='ls -FCGBa'
alias ll='ls -FCGla'
#alias less='less -sx4XR'
#alias less='less -sIx4FRM'

function memogrep() {
  if hash mdv >/dev/null 2>&1; then
    memogrep.py -i -n 0 -b '#' $@ | mdv -t 881.4906 - | less -sIx4XF
  else
    memogrep.py -i $@ | less -sIx4XF
  fi
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
alias ipyn='ipython notebook'
alias ps='ps auxw'
alias psh='pyenv shell'
alias d='cd ~/Downloads'
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

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

function saveenv() {
    dir=$(pyenv version | awk '{ print $1 }')
    reqname="/requirements-${dir}.txt"
    whlname="/wheelhouse-${dir}"
    absdir="$HOME/Dropbox/SaveVirtualEnv/${dir}"
    if [ -e ${absdir} ]; then
	echo "Already exist! Overwrite? [y/n]"
	read rep
	if [ ! $rep = 'y' ]; then
	    return 0
	fi
	poi $absdir
    fi
    mkdir $absdir
    pyenv exec pip freeze > ${absdir}${reqname}
    pyenv exec pip wheel --wheel-dir=${absdir}${whlname} -r ${absdir}${reqname}
}

function loadenv() {
    if [ $1 = "" ]; then
	echo "Specify Argument [env name]"
    else
	env=$1
	absdir="$HOME/Dropbox/SaveVirtualEnv/${env}"
	reqname="/requirements-${env}.txt"
	whlname="/wheelhouse-${env}"
	pyenv exec pip install -r ${absdir}${reqname} --use-wheel --no-index --find-links=${absdir}${whlname}
    fi
}

ffmp4-speedup-filter () {
  readonly local speed=$1
  local v="[0:v]setpts=PTS/${speed}[v]"
  if [ $speed -le 2 ]; then
    local a="[0:a]atempo=${speed}[a]"
  elif [ $speed -le 4 ]; then
    local a="[0:a]atempo=2,atempo=$speed/2[a]"
  elif [ $speed -le 8 ]; then
    local a="[0:a]atempo=2,atempo=2,atempo=$speed/4[a]"
  fi
  noglob echo -filter_complex "$v;$a" -map [v] -map [a]
}

ffmp4-speedup () {
  if [ $# -lt 2 ]; then
    echo "Usage: $0 file speed"
    echo "Convert movie(file) to nx playback mp4 file."
    echo "(ex.) $0 input.mov 2"
    echo "      will generate 2x playback mp4 file (input_x2.mp4)"
    return
  fi
  red=`tput setaf 1; tput bold`
  green=`tput setaf 2; tput bold`
  reset=`tput sgr0`
  readonly local src=$1
  readonly local speed=$2
  dst=${src:r}_x${speed}.mp4
  readonly local config="-crf 23 -c:a aac -ar 44100 -b:a 64k -c:v libx264 -qcomp 0.9 -preset slow -tune film -threads auto -strict -2"
  readonly local args="-v 0 -i $src $config $(ffmp4-speedup-filter $speed) $dst"
  echo -n "Converting $src to ${speed}x playback as $dst ... "
  ffmpeg `echo $args`
  if [[ $? = 0 ]]; then
    echo "${green}OK${reset}"
  else
    echo "${red}Failed${reset}"
  fi
}

elatexmk() {
  if [ $# -lt 1 ]; then
    echo "Usage: $0 tex_file"
    echo "Call latexmk with pdflatex. This function might be useful when you want to typeset TeX files in English."
  else
    latexmk -pvc -pdf -pdflatex="pdflatex -interaction=nonstopmode" $1
  fi
}


function gi() { curl -fL https://www.gitignore.io/api/${(j:,:)@} }

_gitignoreio_get_command_list() {
  curl -sfL https://www.gitignore.io/api/list | tr "," "\n"
}

_gitignoreio () {
  compset -P '*,'
  compadd -S '' `_gitignoreio_get_command_list`
}

compdef _gitignoreio gi