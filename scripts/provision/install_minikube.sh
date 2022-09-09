#!/bin/bash
: '
scripts/provision/install_minikube.sh
'

dnf install -y https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
