#!/bin/bash
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
