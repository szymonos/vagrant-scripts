#!/bin/bash
: '
scripts/provision/install_gnome.sh
'

# determine system id
SYS_ID=$(grep -oPm1 '^ID(_LIKE)?=\"?\K(fedora|debian|ubuntu|opensuse)' /etc/os-release)
if [ "$SYS_ID" = 'fedora' ]; then
  dnf group install -y gnome-desktop
  dnf install -y gnome-tweaks gnome-extensions-app
elif [ "$SYS_ID" = 'debian' ] || [ "$SYS_ID" = 'ubuntu' ]; then
  DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y ubuntu-desktop-minimal gnome-tweaks gnome-shell-extensions
fi
systemctl set-default graphical.target
