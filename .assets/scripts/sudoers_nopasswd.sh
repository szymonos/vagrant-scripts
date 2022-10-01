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

if [[ "$1" = 'remove' ]]; then
  sudo rm -f /usr/share/polkit-1/rules.d/49-nopasswd_global.rules
else
[[ -d /usr/share/polkit-1/rules.d ]] && cat <<EOF | sudo tee /usr/share/polkit-1/rules.d/49-nopasswd_global.rules >/dev/null
/* Allow members of the wheel group to execute any actions
 * without password authentication, similar to "sudo NOPASSWD:"
 */
polkit.addRule(function(action, subject) {
    if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
    }
});
EOF
fi
