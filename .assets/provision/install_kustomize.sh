#!/usr/bin/env bash
: '
sudo .assets/provision/install_kustomize.sh
'
if [[ $EUID -ne 0 ]]; then
  echo -e '\e[91mRun the script as root!\e[0m'
  exit 1
fi

while [[ ! -f kustomize ]]; do
  curl -sk 'https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh' | bash
done
install -o root -g root -m 0755 kustomize /usr/local/bin/kustomize && rm -f kustomize
