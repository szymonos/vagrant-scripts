#!/bin/bash
: '
scripts/provision/install_yq.sh
'

APP='yq'
while [[ -z "$REL" ]]; do
  REL=$(curl -sk https://api.github.com/repos/mikefarah/yq/releases/latest | grep -Po '"tag_name": *"v\K.*?(?=")')
done

if type "$APP" &>/dev/null; then
  VER=$(yq --version | sed -r 's/.* ([0-9\.]+)$/\1/')
  if [ "$REL" == "$VER" ]; then
    echo "The latest $APP v$VER is already installed!"
    exit 0
  fi
fi

echo "Install $APP v$REL"
curl -Lsk "https://github.com/mikefarah/yq/releases/download/v${REL}/yq_linux_amd64.tar.gz" | tar -xz
install -o root -g root -m 0755 yq_linux_amd64 /usr/local/bin/yq && rm -f yq_linux_amd64 yq.1 install-man-page.sh
