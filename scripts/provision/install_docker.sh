#!/bin/bash
dnf config-manager --add-repo 'https://download.docker.com/linux/fedora/docker-ce.repo'
dnf install -y docker-ce docker-ce-cli containerd.io
usermod -a -G docker vagrant
systemctl enable --now docker.service
systemctl enable --now containerd.service
