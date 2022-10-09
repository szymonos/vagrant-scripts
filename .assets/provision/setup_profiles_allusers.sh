#!/bin/bash
: '
sudo .assets/provision/setup_profiles_allusers.sh
'
# get PowerShell profile path
PROFILE_PATH=$(pwsh -nop -c '[IO.Path]::GetDirectoryName($PROFILE.AllUsersAllHosts)')
SCRIPTS_PATH=$(pwsh -nop -c '$env:PSModulePath.Split(":")[1].Replace("Modules", "Scripts")')
# create scripts folder
mkdir -p $SCRIPTS_PATH

# *Copy global profiles
if [ -d /tmp/config ]; then
  # bash aliases
  \mv -f /tmp/config/bash_* /etc/profile.d/
  # oh-my-posh profile
  \mv -f /tmp/config/theme.omp.json /etc/profile.d/
  # PowerShell profile
  \mv -f /tmp/config/profile.ps1 $PROFILE_PATH
  # PowerShell functions
  \mv -f /tmp/config/ps_aliases_common.ps1 $SCRIPTS_PATH
  # git functions
  if type git &>/dev/null; then
    \mv -f /tmp/config/ps_aliases_git.ps1 $SCRIPTS_PATH
  fi
  # kubectl functions
  if type kubectl &>/dev/null; then
    \mv -f /tmp/config/ps_aliases_kubectl.ps1 $SCRIPTS_PATH
  fi
  # clean config folder
  rm -fr /tmp/config
fi

# *PowerShell profile
pwsh -nop -c 'Write-Host "Install PowerShellGet" && Install-Module PowerShellGet -AllowPrerelease -Scope AllUsers -Force -WarningAction SilentlyContinue'
# install modules and setup experimental features
cat <<'EOF' | pwsh -nop -c -
$WarningPreference = 'Ignore';
Write-Host 'Set PSGallery Trusted' && Set-PSResourceRepository -Name PSGallery -Trusted;
Write-Host 'Install PSReadLine' && Install-PSResource -Name PSReadLine -Scope AllUsers -Quiet;
Write-Host 'Install posh-git' && Install-PSResource -Name posh-git -Scope AllUsers -Quiet;
Write-Host 'Enable ExperimentalFeature' && Enable-ExperimentalFeature PSAnsiRenderingFileInfo, PSNativeCommandArgumentPassing
EOF

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
# make path autocompletion case insensitive
grep -qw 'completion-ignore-case' /etc/inputrc || echo 'set completion-ignore-case on' >>/etc/inputrc

# *set localtime to UTC
[ -f /etc/localtime ] || ln -s /usr/share/zoneinfo/UTC /etc/localtime
