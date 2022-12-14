#!/bin/bash
: '
sudo .assets/provision/install_k9s.sh
'
if [[ $EUID -ne 0 ]]; then
  echo -e '\e[91mRun the script as root!\e[0m'
  exit 1
fi

APP='k9s'
REL=$1
# get latest release if not provided as a parameter
while [[ -z "$REL" ]]; do
  REL=$(curl -sk https://api.github.com/repos/derailed/k9s/releases/latest | grep -Po '"tag_name": *"v\K.*?(?=")')
  [[ -n "$REL" ]] || echo 'retrying...' >&2
done
# return latest release
echo $REL

if type $APP &>/dev/null; then
  VER=$(k9s version -s | grep -Po '(?<=v)[\d\.]+$')
  if [ "$REL" = "$VER" ]; then
    echo -e "\e[36m$APP v$VER is already latest\e[0m" >&2
    exit 0
  fi
fi

echo -e "\e[96minstalling $APP v$REL\e[0m" >&2

while [[ ! -f k9s ]]; do
  curl -Lsk "https://github.com/derailed/k9s/releases/download/v${REL}/k9s_Linux_x86_64.tar.gz" | tar -zx k9s
done
mkdir -p /opt/k9s && install -o root -g root -m 0755 k9s /opt/k9s/k9s && rm -f k9s
[ -f /usr/bin/k9s ] || ln -s /opt/k9s/k9s /usr/bin/k9s
