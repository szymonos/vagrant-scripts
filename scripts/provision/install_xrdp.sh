#!/bin/bash
: '
scripts/provision/install_xrdp.sh
'

# Load the Hyper-V kernel module
if ! [ -f "/etc/modules-load.d/hv_sock.conf" ] || [ "$(cat /etc/modules-load.d/hv_sock.conf | grep hv_sock)" = ""  ]; then
  echo "hv_sock" | sudo tee -a /etc/modules-load.d/hv_sock.conf > /dev/null
fi
dnf -y install xrdp tigervnc-server
systemctl enable --now xrdp

firewall-cmd --add-port=3389/tcp
firewall-cmd --runtime-to-permanent
