#!/bin/bash
: '
.assets/scripts/install_profile.sh      #* install basic profile
.assets/scripts/install_profile.sh pl   #* install powerline profile
'
if [[ $EUID -eq 0 ]]; then
  echo -e '\e[91mDo not run the script with sudo!\e[0m'
  exit 1
fi

# *Install oh-my-posh and PowerShell
sudo .assets/provision/install_omp.sh
sudo .assets/provision/install_pwsh.sh
sudo .assets/provision/install_exa.sh
sudo .assets/provision/setup_profiles_allusers.sh
.assets/provision/setup_profiles_user.sh

# *Copy config files
# calculate variables
if [[ "$1" = 'pl' ]]; then
  OMP_PROFILE='.config/.assets/theme-pl.omp.json'
else
  OMP_PROFILE='.config/.assets/theme.omp.json'
fi
PROFILE_PATH=$(pwsh -nop -c '[IO.Path]::GetDirectoryName($PROFILE.AllUsersAllHosts)')
SCRIPTS_PATH=$(pwsh -nop -c '$env:PSModulePath.Split(":")[1].Replace("Modules", "Scripts")')

# bash aliases
sudo \cp -f .assets/config/bash_* /etc/profile.d/
# oh-my-posh profile
sudo \cp -f $OMP_PROFILE /etc/profile.d/theme.omp.json
# PowerShell profile
sudo \cp -f .assets/config/profile.ps1 $PROFILE_PATH
# PowerShell functions
sudo \cp -f .assets/config/ps_aliases_common.ps1 $SCRIPTS_PATH
# git functions
if type git &>/dev/null; then
  sudo \cp -f .assets/config/ps_aliases_git.ps1 $SCRIPTS_PATH
fi
# kubectl functions
if type -f kubectl &>/dev/null; then
  sudo \cp -f .assets/config/ps_aliases_kubectl.ps1 $SCRIPTS_PATH
fi
