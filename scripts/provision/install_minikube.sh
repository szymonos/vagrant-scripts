#!/bin/bash
: '
scripts/provision/install_minikube.sh
'

# determine system id
SYS_ID=$(grep -oPm1 '^ID(_LIKE)?=\"?\K(arch|fedora|debian|ubuntu|opensuse)' /etc/os-release)

case $SYS_ID in
arch)
  pacman -S --noconfirm minikube
  ;;
fedora)
  dnf install -y https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
  ;;
debian | ubuntu)
  curl -LOsk https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
  dpkg -i minikube_latest_amd64.deb && rm -f minikube_latest_amd64.deb
  ;;
opensuse)
  zypper in -y --allow-unsigned-rpm https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
  ;;
*)
  curl -LOsk https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
  install -o root -g root -m 0755 minikube-linux-amd64 /usr/local/bin/minikube
  ;;
esac
