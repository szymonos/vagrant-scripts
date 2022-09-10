#!/bin/bash
: '
scripts/provision/install_pwsh.sh
'

APP='pwsh'
while [[ -z "$REL" ]]; do
  REL=$(curl -sk https://api.github.com/repos/PowerShell/PowerShell/releases/latest | grep -Po '"tag_name": *"v\K.*?(?=")')
done

if type "$APP" &>/dev/null; then
  VER=$(pwsh -nop -c '$PSVersionTable.PSVersion.ToString()')
  if [ "$REL" == "$VER" ]; then
    echo "The latest $APP v$VER is already installed!"
    exit 0
  fi
fi

echo "Install $APP v$REL"
# determine system id
SYS_ID=$(grep -oPm1 '^ID(_LIKE)?=\"?\K(fedora|debian|ubuntu|opensuse)' /etc/os-release)
if [ "$SYS_ID" == "fedora" ]; then
  dnf install -y "https://github.com/PowerShell/PowerShell/releases/download/v$REL/powershell-$REL-1.rh.x86_64.rpm"
elif [ "$SYS_ID" == "debian" ] || [ "$SYS_ID" = "ubuntu" ]; then
  curl -Ls "https://github.com/PowerShell/PowerShell/releases/download/v$REL/powershell_$REL-1.deb_amd64.deb" -o /tmp/powershell.deb
  apt install -fy /tmp/powershell.deb && rm -f /tmp/powershell.deb
else
  [ "$SYS_ID" == "opensuse" ] && zypper in -y libicu
  curl -Ls https://github.com/PowerShell/PowerShell/releases/download/v$REL/powershell-$REL-linux-x64.tar.gz -o /tmp/powershell.tar.gz
  mkdir -p /opt/microsoft/powershell/7
  tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7 && rm -f /tmp/powershell.tar.gz
  chmod +x /opt/microsoft/powershell/7/pwsh
  ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh
fi
