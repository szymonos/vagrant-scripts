#!/bin/bash
: '
scripts/other/install_profile.sh      #* install basic profile
scripts/other/install_profile.sh pl   #* install powerline profile
'

# *Install oh-my-posh and PowerShell
sudo scripts/provision/install_omp.sh
sudo scripts/provision/install_pwsh.sh
sudo scripts/provision/setup_pwsh_allusers.sh
scripts/provision/setup_user_profile.sh

# *Copy profiles
yes | sudo cp -f scripts/config/bash_* /etc/profile.d/
yes | sudo cp -f scripts/config/profile.ps1 /opt/microsoft/powershell/7/
yes | sudo cp -f scripts/config/ps_aliases_*.ps1 /usr/local/share/powershell/Scripts/
if [ "$1" == 'pl' ]; then
  yes | sudo cp -f scripts/config/theme-pl.omp.json /etc/profile.d/theme.omp.json
else
  yes | sudo cp -f scripts/config/theme.omp.json /etc/profile.d/
fi
