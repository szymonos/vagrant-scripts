#!/bin/bash
APP='kubeseal'
while [[ -z $REL ]]; do
  REL=$(curl -sk https://api.github.com/repos/bitnami-labs/sealed-secrets/releases/latest | grep -Po '"tag_name": *"v\K.*?(?=")')
done

if type yq &>/dev/null; then
  VER=$(kubeseal --version | sed -r 's/.* ([0-9\.]+)$/\1/')
  if [ $REL == $VER ]; then
    echo "The latest $APP v$VER is already installed!"
    exit 0
  fi
fi

echo "Install $APP v$REL"
curl -Lsk "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${REL}/kubeseal-${REL}-linux-amd64.tar.gz" | tar -xz
install -m 0755 kubeseal /usr/bin/kubeseal && rm -f kubeseal
