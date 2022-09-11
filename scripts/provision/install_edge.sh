#!/bin/bash
: '
scripts/provision/install_edge.sh
'

# determine system id
SYS_ID=$(grep -oPm1 '^ID(_LIKE)?=\"?\K(fedora|debian|ubuntu|opensuse)' /etc/os-release)
if [ "$SYS_ID" = 'fedora' ]; then
  rpm --import 'https://packages.microsoft.com/keys/microsoft.asc'
  dnf config-manager --add-repo 'https://packages.microsoft.com/yumrepos/edge'
  mv -f /etc/yum.repos.d/packages.microsoft.com_yumrepos_edge.repo /etc/yum.repos.d/microsoft-edge-stable.repo
  dnf install -y microsoft-edge-stable
elif [ "$SYS_ID" = 'debian' ] || [ "$SYS_ID" = 'ubuntu' ]; then
  [ -f /etc/apt/trusted.gpg.d/microsoft.gpg ] || curl -fsSLk https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/microsoft.gpg
  sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-stable.list'
  sudo apt update
  sudo apt install -y microsoft-edge-stable
elif [ "$SYS_ID" = 'opensuse' ]; then
  sudo zypper addrepo https://packages.microsoft.com/yumrepos/edge edge
  sudo zypper refresh
  sudo zypper install -y microsoft-edge-stable
fi
