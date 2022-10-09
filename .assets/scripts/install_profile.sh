#!/bin/bash
: '
.assets/scripts/install_profile.sh      #* install basic profile
.assets/scripts/install_profile.sh pl   #* install powerline profile
'
# get PowerShell profile path
PROFILE_PATH=$(pwsh -nop -c '[IO.Path]::GetDirectoryName($PROFILE.AllUsersAllHosts)')

# *Install oh-my-posh and PowerShell
sudo .assets/provision/install_omp.sh
sudo .assets/provision/install_pwsh.sh
sudo .assets/provision/install_exa.sh
sudo .assets/provision/setup_profiles_allusers.sh
.assets/provision/setup_profiles_user.sh

# *Copy profiles
sudo \cp -f .assets/config/bash_* /etc/profile.d/
sudo \cp -f .assets/config/profile.ps1 $PROFILE_PATH
sudo \cp -f .assets/config/ps_aliases_*.ps1 /usr/local/share/powershell/Scripts/
if [ "$1" = 'pl' ]; then
  sudo \cp -f .assets/config/theme-pl.omp.json /etc/profile.d/theme.omp.json
else
  sudo \cp -f .assets/config/theme.omp.json /etc/profile.d/
fi
