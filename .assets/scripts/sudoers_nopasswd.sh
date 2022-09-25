#!/bin/bash
: '
.assets/scripts/sudoers_nopasswd.sh
.assets/scripts/sudoers_nopasswd.sh remove
'
if [[ $(id -u) -eq 0 ]]; then
  echo -e '\e[91mDo not run the script with sudo!'
  exit 1
fi

user=$USER

if [[ "$1" = 'remove' ]]; then
  sudo rm -f "/etc/sudoers.d/$USER"
else
  cat <<EOF | sudo tee /etc/sudoers.d/$user >/dev/null
$user ALL=(root) NOPASSWD: ALL
EOF
fi
