#!/bin/bash
APP='PowerShell'
while [[ -z $REL ]]; do
  REL=$(curl -sk https://api.github.com/repos/PowerShell/PowerShell/releases/latest | grep -Po '"tag_name": *"v\K.*?(?=")')
done

if type pwsh &>/dev/null; then
  VER=$(pwsh -nop -c '$PSVersionTable.PSVersion.ToString()')
  if [ $REL == $VER ]; then
    echo "The latest $APP v$VER is already installed!"
    exit 0
  fi
fi

echo "Install $APP v$REL"
dnf install -y "https://github.com/PowerShell/PowerShell/releases/download/v$REL/powershell-$REL-1.rh.x86_64.rpm"
