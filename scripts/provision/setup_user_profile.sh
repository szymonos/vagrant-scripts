#!/bin/bash
: '
scripts/provision/setup_user_profile.sh
'

# *PowerShell profile
pwsh -nop -c 'Enable-ExperimentalFeature PSAnsiRenderingFileInfo -WarningAction SilentlyContinue'

# *bash profile
# add common bash aliases
grep 'd/bash_aliases' ~/.bashrc >/dev/null || cat <<'EOF' >>~/.bashrc
# common aliases
[ -f /etc/profile.d/bash_aliases ] && source /etc/profile.d/bash_aliases
EOF
# add oh-my-posh invocation to .bashrc
grep 'oh-my-posh' ~/.bashrc >/dev/null || cat <<'EOF' >>~/.bashrc
# initialize oh-my-posh prompt
if type oh-my-posh &>/dev/null; then
  [ -f /etc/profile.d/theme.omp.json ] && eval "$(oh-my-posh --init --shell bash --config /etc/profile.d/theme.omp.json)"
fi
EOF
