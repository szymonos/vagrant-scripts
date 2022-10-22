<#
.SYNOPSIS
Setting up fresh WSL distro.
.EXAMPLE
$distro = 'fedoraremix'
$gh_user = 'szymonos'
$repos = 'devops-scripts,powershell-scripts,ps-szymonos,vagrant'
$scope = 'k8s_basic'
$theme_font = 'powerline'
.assets/scripts/setup_wsl.ps1 -d $distro -g $gh_user -r $repos -s $scope -f $theme_font
#>
[CmdletBinding()]
param (
    [Alias('d')]
    [Parameter(Mandatory, Position = 0)]
    [string]$distro,

    [Alias('g')]
    [Parameter(Mandatory, Position = 1)]
    [string]$gh_user,

    [Alias('r')]
    [Parameter(Mandatory, Position = 2)]
    [string]$repos,

    [Alias('s')]
    [Parameter(Mandatory, Position = 3)]
    [ValidateSet('base', 'k8s_basic', 'k8s_full')]
    [string]$scope = 'base',

    [Alias('f')]
    [Parameter(Mandatory, Position = 4)]
    [ValidateSet('base', 'powerline')]
    [string]$theme_font = 'base'
)

# *install packages
wsl.exe --distribution $distro --user root --exec .assets/provision/install_base.sh
wsl.exe --distribution $distro --user root --exec .assets/provision/install_omp.sh
wsl.exe --distribution $distro --user root --exec .assets/provision/install_pwsh.sh
wsl.exe --distribution $distro --user root --exec .assets/provision/install_bat.sh
wsl.exe --distribution $distro --user root --exec .assets/provision/install_exa.sh
wsl.exe --distribution $distro --user root --exec .assets/provision/install_ripgrep.sh
if ($scope -in @('k8s_basic', 'k8s_full')) {
    wsl.exe --distribution $distro --user root --exec .assets/provision/install_kubectl.sh
    wsl.exe --distribution $distro --user root --exec .assets/provision/install_helm.sh
    wsl.exe --distribution $distro --user root --exec .assets/provision/install_minikube.sh
    wsl.exe --distribution $distro --user root --exec .assets/provision/install_k3d.sh
    wsl.exe --distribution $distro --user root --exec .assets/provision/install_k9s.sh
    wsl.exe --distribution $distro --user root --exec .assets/provision/install_yq.sh
}
if ($scope -eq 'k8s_full') {
    wsl.exe --distribution $distro --user root --exec .assets/provision/install_flux.sh
    wsl.exe --distribution $distro --user root --exec .assets/provision/install_kubeseal.sh
    wsl.exe --distribution $distro --user root --exec .assets/provision/install_kustomize.sh
    wsl.exe --distribution $distro --user root --exec .assets/provision/install_argorolloutscli.sh
}

# *copy files
# calculate variables
$OMP_THEME = switch ($theme_font) {
    'base' {
        '.assets/config/theme.omp.json'
    }
    'powerline' {
        '.assets/config/theme-pl.omp.json'
    }
}
$SH_PROFILE_PATH = '/etc/profile.d'
$PS_PROFILE_PATH = wsl.exe --distribution $distro --exec pwsh -nop -c '[IO.Path]::GetDirectoryName($PROFILE.AllUsersAllHosts)'
$PS_SCRIPTS_PATH = '/usr/local/share/powershell/Scripts'
$OH_MY_POSH_PATH = '/usr/local/share/oh-my-posh'

# bash aliases
wsl.exe --distribution $distro --user root --exec cp .assets/config/bash_aliases $SH_PROFILE_PATH
wsl.exe --distribution $distro --user root --exec chmod 644 $SH_PROFILE_PATH/bash_aliases
# oh-my-posh theme
wsl.exe --distribution $distro --user root --exec mkdir -p $OH_MY_POSH_PATH
wsl.exe --distribution $distro --user root --exec cp -f $OMP_THEME "$OH_MY_POSH_PATH/theme.omp.json"
wsl.exe --distribution $distro --user root --exec chmod 644 "$OH_MY_POSH_PATH/theme.omp.json"
# PowerShell profile
wsl.exe --distribution $distro --user root --exec cp -f .assets/config/profile.ps1 $PS_PROFILE_PATH
wsl.exe --distribution $distro --user root --exec chmod 644 "$PS_PROFILE_PATH/profile.ps1"
# PowerShell functions
wsl.exe --distribution $distro --user root --exec mkdir -p $PS_SCRIPTS_PATH
wsl.exe --distribution $distro --user root --exec cp -f .assets/config/ps_aliases_common.ps1 $PS_SCRIPTS_PATH
wsl.exe --distribution $distro --user root --exec chmod 644 "$PS_SCRIPTS_PATH/ps_aliases_common.ps1"
# git functions
wsl.exe --distribution $distro --user root --exec cp -f .assets/config/bash_aliases_git $SH_PROFILE_PATH
wsl.exe --distribution $distro --user root --exec chmod 644 "$SH_PROFILE_PATH/bash_aliases_git"
wsl.exe --distribution $distro --user root --exec cp -f .assets/config/ps_aliases_git.ps1 $PS_SCRIPTS_PATH
wsl.exe --distribution $distro --user root --exec chmod 644 "$PS_SCRIPTS_PATH/ps_aliases_git.ps1"
# kubectl functions
if ($scope -in @('k8s_basic', 'k8s_full')) {
    wsl.exe --distribution $distro --user root --exec cp -f .assets/config/bash_aliases_kubectl $SH_PROFILE_PATH
    wsl.exe --distribution $distro --user root --exec chmod 644 "$SH_PROFILE_PATH/bash_aliases_kubectl"
    wsl.exe --distribution $distro --user root --exec cp -f .assets/config/ps_aliases_kubectl.ps1 $PS_SCRIPTS_PATH
    wsl.exe --distribution $distro --user root --exec chmod 644 "$PS_SCRIPTS_PATH/ps_aliases_kubectl.ps1"
}

# *setup profiles
wsl.exe --distribution $distro --user root --exec .assets/provision/setup_profiles_allusers.sh
wsl.exe --distribution $distro --exec .assets/provision/setup_profiles_user.sh

# *setup git repositories
wsl.exe --distribution $distro --exec .assets/scripts/setup_wsl.sh "$distro" "$env:USERNAME" "$gh_user" "$repos"
