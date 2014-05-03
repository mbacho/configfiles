#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '


#
# ignorespace  : ignore commands that start with spaces
# ignoredups   : ignore duplicates
# Specify both : Concatenate and separate the values with a colon ignorespace:ignoredups or specify ignoreboth.
#
export HISTCONTROL=ignoreboth


# Settings
# Don't exit when accidentally pressing ^D
set -o ignoreeof

# Append, rather than overwrite history files
# Useful for when multiple bash sessions are running
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize



#some quote
echo -e "\n"
fortune -aes
echo -e "\n"

#git stuff
source  /usr/share/git/git-prompt.sh

#aliases
alias ls='ls --color=always -F'
alias ll='ls -l'
alias la='ls -a'
alias l='ls'
alias cls='clear'
alias rm='rm -Iv'
alias mv='mv -iv'
alias cp='cp -iv'
alias file='file -i --mime-type'
alias ping='ping -c5'
alias exaunt='systemctl poweroff'
alias pyserver='python -m SimpleHTTPServer'
alias nano_plain='nano -I'
alias less='less -R'

#skunkworks
MY_PATH=/home/barbossa/sys

#java stuff
export JAVA_HOME=/usr/lib/java/jdk1.7.0_45/bin
export JDK_HOME=$JAVA_HOME
MY_PATH=$MY_PATH:$JAVA_HOME

#Scala dev stuff
MY_PATH=$MY_PATH:/home/barbossa/r_n_d/scala/scala_runtime/bin
MY_PATH=$MY_PATH:/home/barbossa/r_n_d/scala/sbt/bin

#heroku
MY_PATH=$MY_PATH:/usr/local/heroku/bin

#php composer
MY_PATH=$MY_PATH:/home/barbossa/r_n_d/composer

#sml binaries
MY_PATH=$MY_PATH:/home/barbossa/r_n_d/smlnj/bin

#ruby gems
MY_PATH=$MY_PATH:/home/barbossa/.gem/ruby/2.1.0/bin

#node modules
MY_PATH=$MY_PATH:/home/barbossa/node_modules/.bin

export PATH=$PATH:$MY_PATH


#proxy stuff
function uoncredz(){
  usr=p15%2F1263%2F2010%40students
  pwd=6bd%40uon
  srv=proxy.uonbi.ac.ke
  port=80
  echo "$srv $port $usr $pwd"
}
function proxyon(){
  #$1 server, $2 port, $3 usr, $4 pwd
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
  #$1 server, $2 port, $3 usr, $4 pwd
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
  unset HTTP_PROXY
  unset http_proxy
  unset HTTPS_PROXY
  unset https_proxy
  unset FTP_PROXY
  unset ftp_proxy
  unset RSYNC_PROXY
  unset rsync_proxy
  echo -e "Proxy imechujwa kutoka env"
}
function proxygnomeoff(){
  default_port=0
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
  status="ha"
  # -n test if non-empty
  # -z empty
  if [ -n "$http_proxy" ]; then
    status=""
  fi
  echo -e Proxy "$status"iko "kwa env\nWacha nicheki gnome..."
  gproxy=`gsettings get org.gnome.system.proxy mode`
  status=""
  if [ "$gproxy" == "'none'" ]; then
    status="ha"
  fi
  echo -e "Proxy ya gnome" "$status"ik"o."
}

#prompt generation
function set_prompt(){
  last_cmd_status=$?
  color_brown='\[\e[01;33m\]'
  color_red='\[\e[01;31m\]'
  color_reset='\[\e[00m\]'
  color_cyan='\[\e[01;32m\]'
  
  status=':)'
  body=''
  
  if [[ $last_cmd_status != 0 ]]; then
    status="$color_red$last_cmd_status :($color_reset"
  fi
  
  body="\\u@\\h \\W"
  
  #add git prompt
  body+="$color_brown$(__git_ps1 ' (%s)')$color_reset \\\$ "
  
  #support for virtualenv names
  env_name=''
  if [ -n "$VIRTUAL_ENV" ]; then
    if [ "`basename \"$VIRTUAL_ENV\"`" = "__" ] ; then
        env_name="[`basename \`dirname \"$VIRTUAL_ENV\"\``]"
    else
        env_name="(`basename \"$VIRTUAL_ENV\"`)"
    fi
  fi
  PS1="$status $color_cyan$env_name$color_reset $body"
}
PROMPT_COMMAND='set_prompt'
