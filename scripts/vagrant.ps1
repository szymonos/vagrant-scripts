#!/usr/bin/pwsh -nop
<#
.LINK
https://app.vagrantup.com/generic/boxes/fedora36
https://superuser.com/questions/1354658/hyperv-static-ip-with-vagrant
https://github.com/Shinzu/vagrant-hyperv
https://github.com/ShaunLawrie/vagrant-hyperv-v2/pull/1
https://technology.amis.nl/tech/vagrant-and-hyper-v-dont-do-it/
https://github.com/HonkinWaffles/Public-Guides/blob/main/Vagrant+WSL2+Hyper-V.md
https://github.com/secana/EnhancedSessionMode/blob/master/install_esm_fedora3x.sh
.EXAMPLE
.tools\vagrant\vagrant.ps1
#>

# change vagrant.d location
[System.Environment]::GetEnvironmentVariable('VAGRANT_HOME')
[System.Environment]::SetEnvironmentVariable('VAGRANT_HOME', 'F:\Virtual Machines\.vagrant.d', 'Machine')
$env:VAGRANT_HOME

vagrant init hashicorp/bionic64
vagrant up --provider=hyperv

vagrant plugin install vagrant-reload
vagrant init generic/fedora36
# vagrant up --provider=hyperv
vagrant up

# Change switch in all existing VMs
Get-VM | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -SwitchName "NatSwitch"
