#!/bin/bash
: '
scripts/provision/install_kustomize.sh
'

curl -LOsk "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"
chmod 700 install_kustomize.sh
rm -f /usr/local/bin/kustomize
./install_kustomize.sh && mv kustomize /usr/bin/kustomize && rm -f install_kustomize.sh
