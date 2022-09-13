#!/bin/bash
: '
.assets/scripts/install_profile.sh      #* install basic profile
.assets/scripts/install_profile.sh pl   #* install powerline profile
'

# *Install oh-my-posh and PowerShell
sudo .assets/provision/install_omp.sh
sudo .assets/provision/install_pwsh.sh
sudo .assets/provision/setup_pwsh_allusers.sh
.assets/provision/setup_user_profile.sh

# *Copy profiles
yes | sudo cp -f .assets/config/bash_* /etc/profile.d/
yes | sudo cp -f .assets/config/profile.ps1 /opt/microsoft/powershell/7/
yes | sudo cp -f .assets/config/ps_aliases_*.ps1 /usr/local/share/powershell/.assets/
if [ "$1" == 'pl' ]; then
  yes | sudo cp -f .assets/config/theme-pl.omp.json /etc/profile.d/theme.omp.json
else
  yes | sudo cp -f .assets/config/theme.omp.json /etc/profile.d/
fi
