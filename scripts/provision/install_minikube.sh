#!/bin/bash
: '
scripts/provision/install_minikube.sh
'

# determine system id
SYS_ID=$(grep -oPm1 '^ID(_LIKE)?=\"?\K(fedora|debian|ubuntu|opensuse)' /etc/os-release)
if [ "$SYS_ID" == "debian" ] || [ "$SYS_ID" = "ubuntu" ]; then
  # ~Debian-based
  curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
  dpkg -i minikube_latest_amd64.deb && rm -f minikube_latest_amd64.deb
elif [ "$SYS_ID" == "fedora" ]; then
  # ~RedHat-based
  dnf install https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
else
  # ~binary install
  curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  install -o root -g root -m 0755 minikube-linux-amd64 /usr/local/bin/minikube
fi
