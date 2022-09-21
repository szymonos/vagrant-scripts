#!/bin/bash
: '
.assets/provision/install_argorolloutscli.sh
'

APP='kubectl-argo-rollouts'
while [[ -z $REL ]]; do
  REL=$(curl -sk https://api.github.com/repos/argoproj/argo-rollouts/releases/latest | grep -Po '"tag_name": *"v\K.*?(?=")')
done

if type $APP &>/dev/null; then
  VER=$(kubectl-argo-rollouts version --short | grep -Po '(?<=v)[\d\.]+')
  if [ $REL = $VER ]; then
    echo "The latest $APP v$VER is already installed!"
    exit 0
  fi
fi

echo "Install $APP v$REL"
while [[ ! -f kubectl-argo-rollouts-linux-amd64 ]]; do
  curl -LsOk "https://github.com/argoproj/argo-rollouts/releases/download/v${REL}/kubectl-argo-rollouts-linux-amd64"
done
install -o root -g root -m 0755 kubectl-argo-rollouts-linux-amd64 /usr/local/bin/kubectl-argo-rollouts && rm -f kubectl-argo-rollouts-linux-amd64
