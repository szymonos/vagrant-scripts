#!/bin/bash
APP='oh-my-posh'
while [[ -z $REL ]]; do
  REL=$(curl -sk https://api.github.com/repos/JanDeDobbeleer/oh-my-posh/releases/latest | grep -Po '"tag_name": *"v\K.*?(?=")')
done

if type oh-my-posh &>/dev/null; then
  VER=$(oh-my-posh version)
  if [ $REL == $VER ]; then
    echo "The latest $APP v$VER is already installed!"
    exit 0
  fi
fi

echo "Install $APP v$REL"
curl -Lsk 'https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64' -o /usr/bin/oh-my-posh
chmod +x /usr/bin/oh-my-posh
