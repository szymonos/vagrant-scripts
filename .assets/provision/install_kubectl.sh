#!/bin/bash
: '
.assets/provision/install_kubectl.sh
'

# determine system id
SYS_ID=$(grep -oPm1 '^ID(_LIKE)?=\"?\K(arch|fedora|debian|ubuntu|opensuse)' /etc/os-release)

case $SYS_ID in
arch)
  pacman -Sy --needed --noconfirm kubectl
  ;;
fedora)
  [ -f /etc/yum.repos.d/kubernetes.repo ] || cat <<EOF | tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
  if type kubectl &>/dev/null; then
    dnf update -y kubectl
  else
    dnf install -y kubectl
  fi
  ;;
debian | ubuntu)
  apt-get update
  apt-get install -y apt-transport-https ca-certificates curl
  # download the Google Cloud public signing key
  curl -fsSLok /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
  # add the Kubernetes apt repository
  [ -f /etc/apt/sources.list.d/kubernetes.list ] || echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
  # update apt package index with the new repository and install kubectl
  apt-get update
  apt-get install -y kubectl
  ;;
*)
  curl -LOsk "https://dl.k8s.io/release/$(curl -Lsk https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  # install
  install -o root -g root -m 0755 kubectl /usr/bin/kubectl && rm -f kubectl
  ;;
esac