#!/bin/bash
: '
.assets/provision/install_pwsh.sh
'

APP='pwsh'
while [[ -z $REL ]]; do
  REL=$(curl -sk https://api.github.com/repos/PowerShell/PowerShell/releases/latest | grep -Po '"tag_name": *"v\K.*?(?=")')
done

if type $APP &>/dev/null; then
  VER=$(pwsh -nop -c '$PSVersionTable.PSVersion.ToString()')
  if [ $REL = $VER ]; then
    echo "The latest $APP v$VER is already installed!"
    exit 0
  fi
fi

echo "Install $APP v$REL"
# determine system id
SYS_ID=$(grep -oPm1 '^ID(_LIKE)?=\"?\K(arch|fedora|debian|ubuntu|opensuse)' /etc/os-release)

case $SYS_ID in
fedora)
  dnf install -y "https://github.com/PowerShell/PowerShell/releases/download/v${REL}/powershell-${REL}-1.rh.x86_64.rpm"
  ;;
debian | ubuntu)
  curl -Lsk "https://github.com/PowerShell/PowerShell/releases/download/v${REL}/powershell_${REL}-1.deb_amd64.deb" -o powershell.deb
  dpkg -i powershell.deb && rm -f powershell.deb
  ;;
*)
  [ "$SYS_ID" = 'opensuse' ] && zypper in -y libicu
  curl -Lsk "https://github.com/PowerShell/PowerShell/releases/download/v${REL}/powershell-${REL}-linux-x64.tar.gz" -o powershell.tar.gz
  mkdir -p /opt/microsoft/powershell/7
  tar zxf powershell.tar.gz -C /opt/microsoft/powershell/7 && rm -f powershell.tar.gz
  chmod +x /opt/microsoft/powershell/7/pwsh
  [ -f /usr/bin/pwsh ] || ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh
  ;;
esac
