#!/bin/bash
: '
scripts/provision/install_k3d.sh
'

curl -sk https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
