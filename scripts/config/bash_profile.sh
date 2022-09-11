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
