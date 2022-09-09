#!/bin/bash
# enable powershell experimental features
pwsh -nop -c 'Enable-ExperimentalFeature PSAnsiRenderingFileInfo -WarningAction SilentlyContinue'

# add oh-my-posh invocation to .bashrc
cat <<'EOF' >>~/.bashrc
# initialize oh-my-posh prompt
if type oh-my-posh &>/dev/null; then
  [ -f /etc/profile.d/theme.omp.json ] && eval "$(oh-my-posh --init --shell bash --config /etc/profile.d/theme.omp.json)"
fi
EOF
