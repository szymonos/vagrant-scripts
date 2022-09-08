#!/bin/bash

# kubectl autocompletion and aliases
if type kubectl &>/dev/null; then
  source <(kubectl completion bash)
  complete -o default -F __start_kubectl k
  function kubectl() {
    echo "$(tput setaf 5)$(tput bold)kubectl $@$(tput sgr0)" >&2
    command kubectl $@
  }
  [ -f /etc/profile.d/kubectl_aliases ] && source /etc/profile.d/kubectl_aliases
fi

# environment variables
export SWD=$(pwd)
# aliases
alias cds="cd $SWD"

# initialize oh-my-posh prompt
if type oh-my-posh &>/dev/null; then
  [ -f /etc/profile.d/theme.omp.json ] && eval "$(oh-my-posh --init --shell bash --config /etc/profile.d/theme.omp.json)"
fi
