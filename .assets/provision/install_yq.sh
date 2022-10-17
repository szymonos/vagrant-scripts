#!/bin/bash
: '
sudo .assets/provision/install_yq.sh
'

APP='yq'
while [[ -z $REL ]]; do
  REL=$(curl -sk https://api.github.com/repos/mikefarah/yq/releases/latest | grep -Po '"tag_name": *"v\K.*?(?=")')
done

if type $APP &>/dev/null; then
  VER=$(yq --version | grep -Po '(?<=version )[\d\.]+$')
  if [ "$REL" = "$VER" ]; then
    echo "$APP v$VER is already latest"
    exit 0
  fi
fi

echo "Install $APP v$REL"
while [[ ! -f yq_linux_amd64 ]]; do
  curl -Lsk "https://github.com/mikefarah/yq/releases/download/v${REL}/yq_linux_amd64.tar.gz" | tar -xz
done
install -o root -g root -m 0755 yq_linux_amd64 /usr/local/bin/yq && rm -f yq_linux_amd64 yq.1 install-man-page.sh
