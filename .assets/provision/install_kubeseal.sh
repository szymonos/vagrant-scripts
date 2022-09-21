#!/bin/bash
: '
.assets/provision/install_kubeseal.sh
'

APP='kubeseal'
while [[ -z $REL ]]; do
  REL=$(curl -sk https://api.github.com/repos/bitnami-labs/sealed-secrets/releases/latest | grep -Po '"tag_name": *"v\K.*?(?=")')
done

if type $APP &>/dev/null; then
  VER=$(kubeseal --version | grep -Po '[\d\.]+$')
  if [ $REL = $VER ]; then
    echo "The latest $APP v$VER is already installed!"
    exit 0
  fi
fi

echo "Install $APP v$REL"
while [[ ! -f kubeseal ]]; do
  curl -Lsk "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${REL}/kubeseal-${REL}-linux-amd64.tar.gz" | tar -xz
done
install -o root -g root -m 0755 kubeseal /usr/local/bin/kubeseal && rm -f kubeseal LICENSE README.md
