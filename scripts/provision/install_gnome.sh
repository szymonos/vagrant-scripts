#!/bin/bash
: '
scripts/provision/install_gnome.sh
'

dnf group install -y gnome-desktop
dnf install -y gnome-tweaks gnome-extensions-app
systemctl set-default graphical.target
