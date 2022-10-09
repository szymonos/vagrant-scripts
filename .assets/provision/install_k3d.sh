#!/bin/bash
: '
sudo .assets/provision/install_k3d.sh
'

APP='k3d'
while [[ -z $REL ]]; do
  REL=$(curl -sk https://api.github.com/repos/k3d-io/k3d/releases/latest | grep -Po '"tag_name": *"v\K.*?(?=")')
done

if type $APP &>/dev/null; then
  VER=$(k3d --version | grep -Po '(?<=v)[\d\.]+$')
  if [ $REL = $VER ]; then
    echo "$APP v$VER is already latest"
    exit 0
  fi
fi

echo "Install $APP v$REL"
while
  curl -sk 'https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh' | bash
  [[ $(k3d --version | grep -Po '(?<=v)[\d\.]+$') != $REL ]]
do :; done
