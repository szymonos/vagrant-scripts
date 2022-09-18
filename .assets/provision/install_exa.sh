#!/bin/bash
: '
.assets/provision/install_exa.sh
'

APP='exa'
while [[ -z $REL ]]; do
  REL=$(curl -sk https://api.github.com/repos/ogham/exa/releases/latest | grep -Po '"tag_name": *"v\K.*?(?=")')
done

if type $APP &>/dev/null; then
  VER=$(exa --version | grep -oP '^v[\d\.]+')
  if [ $REL = $VER ]; then
    echo "The latest $APP v$VER is already installed!"
    exit 0
  fi
fi

echo "Install $APP v$REL"
# determine system id
SYS_ID=$(grep -oPm1 '^ID(_LIKE)?=\"?\K(arch|centos|fedora|debian|ubuntu|opensuse)' /etc/os-release)

case $SYS_ID in
arch)
  pacman -Sy --needed --noconfirm exa
  ;;
fedora)
  dnf install -y exa
  ;;
debian | ubuntu)
  apt install -y exa
  ;;
opensuse)
  zypper in -y exa
  ;;
*)
  curl -Lsk "https://github.com/ogham/exa/releases/download/v${REL}/exa-linux-x86_64-v${REL}.zip" -o exa-linux-x86_64.zip
  unzip exa-linux-x86_64.zip
  mv -f bin/exa /usr/bin/exa
  mv -f man/* $(manpath | cut -d : -f 1)/man1
  mv -f completions/exa.bash /etc/bash_completion.d
  rm -fr bin completions man exa-linux-x86_64.zip
  ;;
esac
