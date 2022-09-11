#!/bin/bash
: '
scripts/provision/setup_pwsh_allusers.sh
'

# install PowerShellGet preview
pwsh -nop -c 'Write-Host "Install PowerShellGet" && Install-Module PowerShellGet -AllowPrerelease -Scope AllUsers -Force -WarningAction SilentlyContinue'
# install modules and setup experimental features
cat <<'EOF' | pwsh -nop -c -
Write-Host 'Set PSGallery Trusted' && Set-PSResourceRepository -Name PSGallery -Trusted;
Write-Host 'Install PSReadLine' && Install-PSResource -Name PSReadLine -Scope AllUsers -Quiet -WarningAction SilentlyContinue;
Write-Host 'Install posh-git' && Install-PSResource -Name posh-git -Scope AllUsers -Quiet -WarningAction SilentlyContinue;
Write-Host 'Enable PSAnsiRenderingFileInfo' && Enable-ExperimentalFeature PSAnsiRenderingFileInfo -WarningAction SilentlyContinue
EOF

# add powershell kubectl autocompletion
if type kubectl &>/dev/null; then
  cat <<'EOF' | pwsh -nop -c -
New-Item (Split-Path $PROFILE) -ItemType Directory -ErrorAction SilentlyContinue | Out-Null;
(kubectl completion powershell).Replace("'kubectl'", "'k'") > $PROFILE.AllUsersCurrentHost
EOF
fi

# modify ls aliases
if [ -f /etc/profile.d/colorls.sh ]; then
  sed -ri "s/(alias.*='ls.*)'/\1 --time-style=long-iso --group-directories-first'/" /etc/profile.d/colorls.sh
fi

cat <<'EOF' >>~/.bashrc
# initialize oh-my-posh prompt
if type oh-my-posh &>/dev/null; then
  [ -f /etc/profile.d/theme.omp.json ] && eval "$(oh-my-posh --init --shell bash --config /etc/profile.d/theme.omp.json)"
fi
EOF
