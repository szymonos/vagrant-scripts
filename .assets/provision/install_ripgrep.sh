#!/bin/bash
: '
sudo .assets/provision/install_ripgrep.sh
'

APP='rg'
while [[ -z $REL ]]; do
  REL=$(curl -sk https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | grep -Po '"tag_name": *"\K.*?(?=")')
done

if type $APP &>/dev/null; then
  VER=$(rg --version | grep -Po '(?<=ripgrep )[\d\.]+$')
  if [ $REL = $VER ]; then
    echo "$APP v$VER is already latest"
    exit 0
  fi
fi

echo "Install $APP v$REL"
# determine system id
SYS_ID=$(grep -oPm1 '^ID(_LIKE)?=.*\K(arch|centos|fedora|debian|ubuntu|opensuse)' /etc/os-release)

case $SYS_ID in
arch)
  pacman -Sy --needed --noconfirm ripgrep
  ;;
fedora)
  dnf install -y ripgrep
  ;;
debian | ubuntu)
  apt-get update && apt-get install -y ripgrep
  ;;
opensuse)
  zypper in -y ripgrep
  ;;
*)
  echo 'ripgrep not available...'
  ;;
esac
