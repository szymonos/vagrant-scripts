#!/bin/bash
: '
scripts/provision/install_xrdp.sh
'

SYS_ID=$(grep -oPm1 '^ID(_LIKE)?=\"?\K(fedora|debian|ubuntu|opensuse)' /etc/os-release)
if [ "$SYS_ID" = 'fedora' ]; then
  # Load the Hyper-V kernel module
  if ! [ -f "/etc/modules-load.d/hv_sock.conf" ] || [ "$(cat /etc/modules-load.d/hv_sock.conf | grep hv_sock)" = "" ]; then
    echo "hv_sock" | sudo tee -a /etc/modules-load.d/hv_sock.conf >/dev/null
  fi
  dnf -y install xrdp tigervnc-server
  systemctl enable --now xrdp
  # enable firewall rules
  firewall-cmd --add-port=3389/tcp
  firewall-cmd --runtime-to-permanent
elif [ "$SYS_ID" = 'debian' ] || [ "$SYS_ID" = 'ubuntu' ]; then
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y xrdp tigervnc-standalone-server tigervnc-xorg-extension tigervnc-viewer
  usermod -a -G ssl-cert xrdp
  ufw allow 3389
fi
