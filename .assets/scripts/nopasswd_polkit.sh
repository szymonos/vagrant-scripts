#!/usr/bin/env bash
: '
.assets/scripts/nopasswd_polkit.sh
.assets/scripts/nopasswd_polkit.sh revert
'
if [ $EUID -eq 0 ]; then
  printf '\e[31;1mDo not run the script as root.\e[0m\n'
  exit 1
fi

if [ "$1" = 'revert' ]; then
  sudo rm -f /usr/share/polkit-1/rules.d/49-nopasswd_global.rules
elif id -Gn | grep -qw 'wheel'; then
  # disable password in desktop environment
  [ -d /usr/share/polkit-1/rules.d ] && cat <<EOF | sudo tee /usr/share/polkit-1/rules.d/49-nopasswd_global.rules >/dev/null
/* Allow members of the wheel group to execute any actions
 * without password authentication, similar to "sudo NOPASSWD:"
 */
polkit.addRule(function(action, subject) {
    if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
    }
});
EOF
else
  printf "\e[33mUser \e[1m${USER}\e[22m is not in the \e[1mwheel\e[22m group\e[0m\n"
fi
