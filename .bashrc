SHELL_SESSION_HISTORY=0
export HEROKU_ORGANIZATION=coffeeandcode

# asdf
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# hack for KP project to use a specific version of elasticsearch to run tests
export PATH="/usr/local/opt/elasticsearch@2.4/bin:$PATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jon/google-cloud-sdk/path.bash.inc' ]; then source '/Users/jon/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/jon/google-cloud-sdk/completion.bash.inc' ]; then source '/Users/jon/google-cloud-sdk/completion.bash.inc'; fi

# bash completion
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
complete -C aws_completer aws

# Android development with Android Studio download on Mac
# export ANDROID_HOME=/Users/jon/Library/Android/sdk

docker-gc() {
	# docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /etc:/etc spotify/docker-gc

	docker container prune --force
	docker image prune --all --force
	docker network prune --force

	if [[ -n $(docker volume ls --filter dangling=true -q | egrep '\w{64}') ]] ; then
		docker volume rm $(docker volume ls --filter dangling=true -q | egrep '\w{64}')
	fi
}

update-mac() {
  brew update && brew upgrade
  asdf update --head
  asdf plugin-update --all
}

# Bash aliases
gh() {
  local git_remote
  git_remote="$(git remote -v 2>&1 | grep origin | grep push | awk '{ print $2 }')"

  if [[ ! -z "$git_remote" ]]; then
    open "$git_remote"
  fi
}
alias c='code-insiders'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias server='python -m SimpleHTTPServer 8000' # http.server in python 3
alias show-hidden-files='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hide-hidden-files='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias chrome-canary="/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary"
alias chromium="/Applications/Chromium.app/Contents/MacOS/Chromium"
alias op="/Users/jon/Applications/1password-cli/op"

# Enable gpg-agent if it is not running
GPG_AGENT_SOCKET="$(gpgconf --list-dirs agent-ssh-socket)"
if [ ! -S $GPG_AGENT_SOCKET ]; then
  gpg-agent --daemon >/dev/null 2>&1
  export GPG_TTY=$(tty)
fi

# Set SSH to use gpg-agent if it is configured to do so
GNUPGCONFIG="${GNUPGHOME:-"$HOME/.gnupg"}/gpg-agent.conf"
if [ -r "$GNUPGCONFIG" ] && grep -q enable-ssh-support "$GNUPGCONFIG"; then
  unset SSH_AGENT_PID
  export SSH_AUTH_SOCK=$GPG_AGENT_SOCKET
fi

function __prompt_command() {
  # /usr/local/etc/bash_completion.d/git-prompt.sh
  local GIT_PS1_SHOWDIRTYSTATE=true
  local GIT_PS1_SHOWSTASHSTATE=true
  local GIT_PS1_SHOWUNTRACKEDFILES=true

  # Prompt colors
  local COLOR_GREEN="\[\033[0;32m\]"
  local COLOR_NORMAL="\[\033[0m\]"
  local COLOR_RED="\[\033[0;31m\]"
  local COLOR_YELLOW="\[\033[0;33m\]"

  PS1="$COLOR_RED\u@\h$COLOR_GREEN:\W\n$COLOR_YELLOW$(__git_ps1 "(%s)")$COLOR_NORMAL\$ "
}

PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }__prompt_command;"
