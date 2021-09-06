alias gcc='gcc -Wall -g'
alias ls='ls -FCGBa'
alias ll='ls -FCGla'


eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

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
alias gst='git status'
alias gl='git log --oneline --graph --decorate'
#alias cleardesktop='defaults write com.apple.finder CreateDesktop -boolean false'
#alias appeardesktop='defaults write com.apple.finder CreateDesktop -boolean true'


SAVEHIST=100000
HISTSIZE=100000
HISTFILE=~/.zhistory

WORDCHARS=']$'

autoload -U colors
colors
PS1="%{${reset_color}%}%{${fg[green]}%}tokkuman%{${reset_color}%}%# "
RPS1="%{${reset_color}%}[%{${fg[green]}%}%/%{${reset_color}%}][%{${fg[green]}%}%*%{${reset_color}%}]"
autoload -U compinit promptinit
compinit -u

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

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


function getDefaultBrowser() {
  preffile=$HOME/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure
  if [ ! -f ${preffile}.plist ]; then
    preffile=$HOME/Library/Preferences/com.apple.LaunchServices
  fi
  # browser might be "com.apple.safari", "org.mozilla.firefox" or "com.google.chrome".
  browser=$(defaults read ${preffile} | grep -B 1 "https" | awk '/LSHandlerRoleAll/{ print $NF }' | sed -e 's/"//g;s/;//')
  echo $browser
}

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


# A zsh function which will check my proxy configuration.
# Runs only on macOS.
proxycheck() {
  local red=`tput setaf 1; tput bold`
  local green=`tput setaf 2; tput bold`
  local cyan=`tput setaf 6; tput bold`
  local reset=`tput sgr0`
  local systemflag=0
  networksetup -listallnetworkservices | while read line
  do
    if [[ $line != *"An asterisk"* ]]; then
      local systemproxy=$(networksetup -getwebproxy $line | /usr/bin/grep -e '^Enabled:' | awk '{print $2}')
      if [ $systemproxy = "Yes" ]; then
        echo "System:  [${green}ON${reset}] $line"
        systemflag=1
      fi
    fi
  done
  if [ $systemflag = 0 ]; then
    echo "System:  [${cyan}No proxy${reset}]"
  fi

  local count=$(/usr/bin/grep -c 'network.proxy.type' $HOME/Library/Application\ Support/Firefox/Profiles/*/prefs.js)
  echo -n "Firefox: "
  if [ $count -gt 1 ]; then
    echo "Found more than one prefs.js"
    return -1
  elif [ $count -eq 0 ]; then
    if [ $systemflag = 1 ]; then
      echo "[${green}Use system proxy settings${reset}]"
      return 1
    else
      echo "[${cyan}Use system proxy settings${reset}]"
      return 0
    fi
  else
    local proxytype=$(/usr/bin/grep 'network.proxy.type' $HOME/Library/Application\ Support/Firefox/Profiles/*/prefs.js | sed 's/[^0-9]//g')
    # ref. https://developer.mozilla.org/ja/docs/Mozilla_Networking_Preferences
    case "$proxytype" in
      0) echo "[${cyan}No proxy${reset}]"; return 0 ;;
      1) echo "[${green}ON${reset}] Manual proxy configuration" ; return 1 ;;
      2) echo "[${green}ON${reset}] Automatic proxy configuration URL (PAC)" ; return 1 ;;
      4) echo "[${green}ON${reset}] Auto-detect proxy settings for this network" ; return 1 ;;
      *) echo "[${red}UNKNOWN${reset}]" ; return -1 ;;
    esac
  fi
}


ffmp4-height () {
        local h=$1
        shift
        red=`tput setaf 1; tput bold`
        green=`tput setaf 2; tput bold`
        blue=`tput setaf 4; tput bold`
        cyan=`tput setaf 6; tput bold`
        reset=`tput sgr0`
        while [[ "$1" != "" && -f $1 ]]
        do
                out=$1:r-s.mp4
                array=(`ffsize $1`)
                if [[ $(( $array[2] <= $h )) == 1 ]]
                then
                        echo "${cyan}Skip${reset}: $array[1] x $array[2] : $1"
                else
                        echo -n "${cyan}Converting${reset} $1 to hight=$h as $out ... "
                        ffmpeg -threads $(ncpu) -v 0 -i $1 -vf scale=-2:$h -c:v libx264 -crf 23 -c:a aac -strict -2 $out
                        if [[ $? = 0 ]]
                        then
                                echo "${green}OK${reset}"
                                copylabel $1 $out
                                copydate $1 $out
                        else
                                echo "${red}Failed${reset}"
                        fi
                fi
                shift
        done
}


ffsize () {
        while [[ "$1" != "" && -f $1 ]]
        do
                local w=`ffprobe -v error -select_streams v:0 -show_entries stream=width  -of csv=p=0 $1`
                local h=`ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=p=0 $1`
                echo "$w $h $1"
                shift
        done
}


ncpu () {
        if [[ "$OSTYPE" == "linux-gnu" ]]
        then
                getconf _NPROCESSORS_ONLN
        elif _has sysctl
        then
                sysctl -n hw.ncpu
        else
                echo "1"
        fi
}


_has() {
  return $( whence $1 &>/dev/null )
}


copylabel () {
        if [ $# -lt 2 ]
        then
                echo "$0 file1 file2"
                echo "  will add color label of file1 to file2."
        else
                if [[ -f $1 && -f $2 ]]
                then
                        local color=`getlabelnum $1`
                        if [[ "$color" != "0" ]]
                        then
                                label $color $2
                        fi
                fi
        fi
}


copydate () {
        if [ $# -lt 2 ]
        then
                echo "$0 file1 file2"
                echo "  will copy modified date of file1 to file2."
        else
                if [[ -f $1 && -f $2 ]]
                then
                        local yymmdd=`GetFileInfo $1 | grep modified | awk '{ print $2 }' | perl -lane 'print "$3$1$2" if /(\d+)\/(\d+)\/(\d+)/'`
                        local hhmm=`GetFileInfo   $1 | grep modified | awk '{ print $3 }' | perl -lane 'print "$1$2\.$3" if /(\d+):(\d+):(\d+)/'`
                        touch -t ${yymmdd}${hhmm} $2
                fi
        fi
}
