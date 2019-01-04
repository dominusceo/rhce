# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=
# User specific aliases and functions
# User specific environment and startup programs
if [ -f `which powerline-daemon` ]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  . /usr/share/powerline/bash/powerline.sh
fi
alias desktop="ssh -YC student@desktop.example.com"
alias server="ssh -YC student@server.example.com"
alias intruder="ssh -YC student@intruder.example.com"
alias provider="ssh -YC student@provider.example.com"
alias guest="ssh -YC student@guest.example.com"
xhost si:localuser:root
