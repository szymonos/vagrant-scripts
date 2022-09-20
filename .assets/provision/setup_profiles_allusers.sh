#!/bin/bash
: '
.assets/provision/setup_profiles_allusers.sh
'
# *Copy global profiles
if [ -d /tmp/config ]; then
  mv -f /tmp/config/bash_* /etc/profile.d/
  mv -f /tmp/config/theme.omp.json /etc/profile.d/
  mv -f /tmp/config/profile.ps1 /opt/microsoft/powershell/7/
  mkdir -p /usr/local/share/powershell/Scripts/ && mv -f /tmp/config/ps_aliases_*.ps1 /usr/local/share/powershell/Scripts/
  rm -fr /tmp/config
fi

# *PowerShell profile
pwsh -nop -c 'Write-Host "Install PowerShellGet" && Install-Module PowerShellGet -AllowPrerelease -Scope AllUsers -Force -WarningAction SilentlyContinue'
# install modules and setup experimental features
cat <<'EOF' | sudo pwsh -nop -c -
$WarningPreference = 'Ignore';
Write-Host 'Set PSGallery Trusted' && Set-PSResourceRepository -Name PSGallery -Trusted;
Write-Host 'Install PSReadLine' && Install-PSResource -Name PSReadLine -Scope AllUsers -Quiet;
Write-Host 'Install posh-git' && Install-PSResource -Name posh-git -Scope AllUsers -Quiet;
Write-Host 'Enable ExperimentalFeature' && Enable-ExperimentalFeature PSAnsiRenderingFileInfo, PSNativeCommandArgumentPassing
EOF
# add powershell kubectl autocompletion
if type kubectl &>/dev/null; then
  cat <<'EOF' | pwsh -nop -c -
New-Item (Split-Path $PROFILE) -ItemType Directory -ErrorAction SilentlyContinue | Out-Null;
(kubectl completion powershell).Replace("'kubectl'", "'k'") > $PROFILE.AllUsersCurrentHost
EOF
fi

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
# make path autocompletion case insensitive
grep 'ignore-case on' /etc/inputrc &>/dev/null || echo 'set completion-ignore-case on' >>/etc/inputrc

# *set localtime to UTC
[ -f /etc/localtime ] || ln -s /usr/share/zoneinfo/UTC /etc/localtime
