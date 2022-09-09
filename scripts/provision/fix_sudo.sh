#!/bin/bash
cp /etc/sudoers /etc/sudoers.bck
sed -e 's%secure_path = /sbin%secure_path = /usr/local/sbin:/usr/local/bin:%' /etc/sudoers.bck >/etc/sudoers
