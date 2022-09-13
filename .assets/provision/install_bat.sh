#!/bin/bash
: '
.assets/provision/install_bat.sh
'

APP='bat'
while [[ -z "$REL" ]]; do
  REL=$(curl -sk https://api.github.com/repos/sharkdp/bat/releases/latest | grep -Po '"tag_name": *"v\K.*?(?=")')
done

if type "$APP" &>/dev/null; then
  VER=$(bat --version | grep -oP '\b\d+\.\d+\.\d+\b')
  if [ "$REL" = "$VER" ]; then
    echo "The latest $APP v$VER is already installed!"
    exit 0
  fi
fi

echo "Install $APP v$REL"
# determine system id
SYS_ID=$(grep -oPm1 '^ID(_LIKE)?=\"?\K(arch|fedora|debian|ubuntu|opensuse)' /etc/os-release)

case $SYS_ID in
arch)
  pacman -Sy --needed --noconfirm bat
  ;;
fedora)
  dnf install -y bat
  ;;
debian | ubuntu)
  curl -Lsk "https://github.com/sharkdp/bat/releases/download/v${REL}/bat_${REL}_amd64.deb" -o bat.deb
  dpkg -i bat.deb && rm -f bat.deb
  ;;
opensuse)
  zypper in -y bat
  ;;
esac
