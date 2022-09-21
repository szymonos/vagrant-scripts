#!/bin/bash
: '
.assets/provision/install_k9s.sh
'

APP='k9s'
while [[ -z $REL ]]; do
  REL=$(curl -sk https://api.github.com/repos/derailed/k9s/releases/latest | grep -Po '"tag_name": *"v\K.*?(?=")')
done

if type $APP &>/dev/null; then
  VER=$(k9s version -s | grep -Po '(?<=v)[\d\.]+$')
  if [ $REL = $VER ]; then
    echo "The latest $APP v$VER is already installed!"
    exit 0
  fi
fi

echo "Install $APP v$REL"
while [[ ! -f k9s ]]; do
  curl -Lsk "https://github.com/derailed/k9s/releases/download/v${REL}/k9s_Linux_x86_64.tar.gz" | tar -xz
done
mkdir -p /opt/k9s && install -o root -g root -m 0755 k9s /opt/k9s/k9s && rm -f k9s LICENSE README.md
[ -f /usr/bin/k9s ] || ln -s /opt/k9s/k9s /usr/bin/k9s
