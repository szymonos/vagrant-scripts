#!/bin/bash
: '
scripts/provision/install_edge.sh
'

# determine system id
SYS_ID=$(grep -oPm1 '^ID(_LIKE)?=\"?\K(arch|fedora|debian|ubuntu|opensuse)' /etc/os-release)

case $SYS_ID in
arch)
  su - vagrant -c 'paru -S --noconfirm microsoft-edge-stable-bin'
  ;;
fedora)
  rpm --import 'https://packages.microsoft.com/keys/microsoft.asc'
  dnf config-manager --add-repo 'https://packages.microsoft.com/yumrepos/edge'
  mv -f /etc/yum.repos.d/packages.microsoft.com_yumrepos_edge.repo /etc/yum.repos.d/microsoft-edge-stable.repo
  dnf install -y microsoft-edge-stable
  ;;
debian | ubuntu)
  [ -f /etc/apt/trusted.gpg.d/microsoft.gpg ] || curl -fsSLk https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/microsoft.gpg
  sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-stable.list'
  sudo apt update
  sudo apt install -y microsoft-edge-stable
  ;;
opensuse)
  sudo zypper addrepo https://packages.microsoft.com/yumrepos/edge edge
  sudo zypper refresh
  sudo zypper install -y microsoft-edge-stable
  ;;
esac
