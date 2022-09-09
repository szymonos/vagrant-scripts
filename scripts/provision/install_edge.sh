#!/bin/bash
rpm --import 'https://packages.microsoft.com/keys/microsoft.asc'
dnf config-manager --add-repo 'https://packages.microsoft.com/yumrepos/edge'
mv /etc/yum.repos.d/packages.microsoft.com_yumrepos_edge.repo /etc/yum.repos.d/microsoft-edge-stable.repo
dnf install -y microsoft-edge-stable
