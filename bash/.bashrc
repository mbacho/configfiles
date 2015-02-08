#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

### start imports

# git stuff
source /usr/share/git/git-prompt.sh


# gcutil stuff
# The next line updates PATH for the Google Cloud SDK.
source '/home/barbossa/r_n_d/gcutils/google-cloud-sdk/path.bash.inc'

# The next line enables bash completion for gcloud.
source '/home/barbossa/r_n_d/gcutils/google-cloud-sdk/completion.bash.inc'
export CLOUDSDK_PYTHON='python2'

### end imports


function shell_opts(){
  #
  # ignorespace  : ignore commands that start with spaces
  # ignoredups   : ignore duplicates
  # Both : use "ignorespace:ignoredups" or "ignoreboth"
  #
  export HISTCONTROL=ignoreboth

  # Don't exit when accidentally pressing ^D
  set -o ignoreeof

  # Append, rather than overwrite history files
  shopt -s histappend

  # Check the window size after each command and, if necessary,
  # update the values of LINES and COLUMNS.
  shopt -s checkwinsize

  # Save all lines of a multiple-line command in the same history entry.
  # This allows easy re-editing of multi-line commands.
  shopt -s cmdhist

  # Includes filenames beginning with a `.' in the results of pathname expansion.
  # shopt -s dotglob
}

function alias_setup(){
  alias ls='ls --color=always -F'
  alias ll='ls -l'
  alias lt='ls -t'
  alias la='ls -A'
  alias l='ls'
  alias cls='clear'
  alias rm='rm -Iv'
  alias mv='mv -iv'
  alias cp='cp -iv'
  alias file='file -i --mime-type'
  alias ping='ping -c5'
  alias exeunt='systemctl poweroff'
  alias pyserver='python2 -m SimpleHTTPServer'
  alias nano_plain='nano -I'
  alias less='less -R'
  alias rsync='rsync -vrhi --progress'
  alias makepkg='makepkg --syncdeps --verifysource'
  alias rmpyc='find -iname "*.pyc" | xargs rm'
  alias rmpycache='find -iname "__pycache__" | xargs rm -rf'
  alias udm='udisksctl mount --block-device'
  alias udum='udisksctl unmount --block-device'
  alias udpo='udisksctl power-off --block-device'
  alias emacs_nw='emacs -nw'
  alias incognito="unset HISTFILE HISTFILESIZE HISTCONTROL HISTSIZE"
}
function env_setup(){
  # skunkworks
  local MY_PATH=/home/barbossa/sys

  if [[ $PATH != *$MY_PATH* ]]; then
    # java stuff
    export JAVA_HOME=/usr/lib/java/jdk1.8.0_11
    export JDK_HOME=$JAVA_HOME

    #pip download cache
    export PIP_DOWNLOAD_CACHE=~/.pip_download_cache

    MY_PATH=$MY_PATH:$JAVA_HOME/bin

    # Scala dev stuff
    MY_PATH=$MY_PATH:/home/barbossa/r_n_d/scala/scala_runtime/bin
    MY_PATH=$MY_PATH:/home/barbossa/r_n_d/scala/sbt/bin

    # heroku
    MY_PATH=$MY_PATH:/usr/local/heroku/bin

    # php composer
    MY_PATH=$MY_PATH:/home/barbossa/r_n_d/composer

    # sml binaries
    MY_PATH=$MY_PATH:/home/barbossa/r_n_d/smlnj/bin

    # ruby gems
    MY_PATH=$MY_PATH:/home/barbossa/.gem/ruby/2.1.0/bin

    # node modules
    MY_PATH=$MY_PATH:/home/barbossa/node_modules/.bin
    export PATH="$PATH:$MY_PATH"

    export WORKON_HOME=$HOME/venvs
  fi
}
function uoncredz(){
  local usr=p15%2F1263%2F2010%40students
  local pwd=6bd%40uon
  local srv=proxy.uonbi.ac.ke
  local port=80
  echo "$srv $port $usr $pwd"
}
function proxyon(){
  # $1 server, $2 port, $3 usr, $4 pwd
  export http_proxy="http://$1:$2"
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "yo...hujanipatia server ama port. nkt"
    return
  fi
  if [ -n "$3" ]; then
    export http_proxy="http://$3:$4@$1:$2"
  fi
  export https_proxy=$http_proxy
  export ftp_proxy=$http_proxy
  export rsync_proxy=$http_proxy
  export HTTP_PROXY=$http_proxy
  export HTTPS_PROXY=$http_proxy
  export FTP_PROXY=$http_proxy
  export RSYNC_PROXY=$http_proxy
  export no_proxy="localhost,127.0.0.1"
  echo -e "Proxy iko kwa env\n"
}
function proxygnomeon(){
  # $1 server, $2 port, $3 usr, $4 pwd
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "nkt...."
    return
  fi
  gsettings set org.gnome.system.proxy ignore-hosts "['localhost', '127.0.0.0/8', '::1', '1.1.1.1']"
  gsettings set org.gnome.system.proxy mode 'manual'

  gsettings set org.gnome.system.proxy.ftp host $1
  gsettings set org.gnome.system.proxy.ftp port $2

  gsettings set org.gnome.system.proxy.http authentication-user $3
  gsettings set org.gnome.system.proxy.http authentication-password $4
  gsettings set org.gnome.system.proxy.http host $1
  gsettings set org.gnome.system.proxy.http port $2
  gsettings set org.gnome.system.proxy.http use-authentication true

  gsettings set org.gnome.system.proxy.https host $1
  gsettings set org.gnome.system.proxy.https port $2

  gsettings set org.gnome.system.proxy.socks host $1
  gsettings set org.gnome.system.proxy.socks port $2
  echo -e "Gnome imesortiwa."
}
function proxyoff(){
  unset HTTP_PROXY http_proxy
  unset HTTPS_PROXY https_proxy
  unset FTP_PROXY ftp_proxy
  unset RSYNC_PROXY rsync_proxy
  echo -e "Proxy imechujwa kutoka env"
}
function proxygnomeoff(){
  local default_port=0
  gsettings set org.gnome.system.proxy ignore-hosts "['localhost', '127.0.0.0/8', '::1']"
  gsettings set org.gnome.system.proxy mode 'none'

  gsettings set org.gnome.system.proxy.ftp host ""
  gsettings set org.gnome.system.proxy.ftp port $default_port

  gsettings set org.gnome.system.proxy.http authentication-password ""
  gsettings set org.gnome.system.proxy.http authentication-user ""
  gsettings set org.gnome.system.proxy.http host ""
  gsettings set org.gnome.system.proxy.http port $default_port
  gsettings set org.gnome.system.proxy.http use-authentication false

  gsettings set org.gnome.system.proxy.https host ""
  gsettings set org.gnome.system.proxy.https port $default_port

  gsettings set org.gnome.system.proxy.socks host ""
  gsettings set org.gnome.system.proxy.socks port $default_port
  echo -e "Proxy imechujwa kutoka gnome"
}
function proxystatus(){
  local status="ha"
  # -n test if non-empty
  # -z empty
  if [ -n "$http_proxy" ]; then
    status=""
  fi
  echo -e Proxy "$status"iko "kwa env\nWacha nicheki gnome..."
  local gproxy=`gsettings get org.gnome.system.proxy mode`
  status=""
  if [ "$gproxy" == "'none'" ]; then
    status="ha"
  fi
  echo -e "Proxy ya gnome" "$status"ik"o."
}

# cmd prompt generation
function set_prompt(){
  local last_cmd_status=$?
  local color_brown='\[\e[01;33m\]'
  local color_red='\[\e[01;31m\]'
  local color_reset='\[\e[00m\]'
  local color_cyan='\[\e[01;32m\]'

  local status=':)'
  local body=''

  if [[ $last_cmd_status != 0 ]]; then
    status="$color_red$last_cmd_status :($color_reset"
  fi

  body="\\u ole \\h \\W"

  # add git prompt
  body+="$color_brown$(__git_ps1 ' (%s)')$color_reset \\\$ "

  # support for virtualenv names
  local env_name=''
  if [ -n "$VIRTUAL_ENV" ]; then
    if [ "`basename \"$VIRTUAL_ENV\"`" = "__" ] ; then
        env_name="[`basename \`dirname \"$VIRTUAL_ENV\"\``]"
    else
        env_name="(`basename \"$VIRTUAL_ENV\"`)"
    fi
  fi
  PS1="$status $color_cyan$env_name$color_reset $body"
}

# failover just incase prompt_command fails
PS1='[\u@\h \W]\$ '

# some 'wise' saying
echo -e "\n$(fortune -aes)\n"

shell_opts
alias_setup
env_setup
PROMPT_COMMAND='set_prompt'
