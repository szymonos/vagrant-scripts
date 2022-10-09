#!/bin/bash
: '
.assets/provision/setup_profiles_user.sh
'

# *PowerShell profile
cat <<'EOF' | pwsh -nop -c -
$WarningPreference = 'Ignore';
Set-PSResourceRepository -Name PSGallery -Trusted;
Enable-ExperimentalFeature PSAnsiRenderingFileInfo, PSNativeCommandArgumentPassing
EOF
# add powershell kubectl autocompletion
if type -f kubectl &>/dev/null; then
  cat <<'EOF' | pwsh -nop -c -
(kubectl completion powershell).Replace("'kubectl'", "'k'") >$PROFILE
EOF
fi

# *bash profile
# add common bash aliases
grep -qw 'd/bash_aliases' ~/.bashrc || cat <<'EOF' >>~/.bashrc
# common aliases
[ -f /etc/profile.d/bash_aliases ] && source /etc/profile.d/bash_aliases
EOF
# add oh-my-posh invocation to .bashrc
grep -qw 'oh-my-posh' ~/.bashrc || cat <<'EOF' >>~/.bashrc
# initialize oh-my-posh prompt
if type oh-my-posh &>/dev/null; then
  [ -f /etc/profile.d/theme.omp.json ] && eval "$(oh-my-posh --init --shell bash --config /etc/profile.d/theme.omp.json)"
fi
EOF
