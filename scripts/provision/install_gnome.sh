#!/bin/bash
dnf group install -y gnome-desktop
dnf install -y gnome-tweaks gnome-extensions-app
systemctl set-default graphical.target
