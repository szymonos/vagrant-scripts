#!/bin/bash
: '
sudo .assets/provision/install_minikube.sh
'

# determine system id
SYS_ID=$(grep -oPm1 '^ID(_LIKE)?=.*\K(arch|fedora|debian|ubuntu|opensuse)' /etc/os-release)

case $SYS_ID in
arch)
  pacman -Sy --needed --noconfirm minikube
  ;;
fedora)
  dnf install -y "https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm"
  ;;
debian | ubuntu)
  while [[ ! -f minikube_latest_amd64.deb ]]; do
    curl -LOsk "https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb"
  done
  dpkg -i minikube_latest_amd64.deb && rm -f minikube_latest_amd64.deb
  ;;
opensuse)
  zypper in -y --allow-unsigned-rpm "https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm"
  ;;
*)
  while [[ ! -f minikube-linux-amd64 ]]; do
    curl -LOsk "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64"
  done
  install -o root -g root -m 0755 minikube-linux-amd64 /usr/local/bin/minikube
  ;;
esac
