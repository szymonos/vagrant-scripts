# Other WSL scripts

There are other WSL managements scripts, some of them used by the wsl_setup.ps1 script that some might find useful.  
All scripts should be executed on Windows.

## [wsl_certs_add](../.assets/scripts/wsl_certs_add.ps1)

Script intercepts root and intermediate certificates in chain and installs them in the specified WSL distro.  
You can also provide custom URL to intercept certificates in chain against it.

``` powershell
# install certificates in chain, intercepted when sending a request to www.google.com.
.assets/scripts/wsl_certs_add.ps1 'Ubuntu'
# install certificates in chain, intercepted when sending a request to custom URL.
.assets/scripts/wsl_certs_add.ps1 'Ubuntu' -Uri 'www.powershellgallery.com'
```

## [wsl_distro_move](../.assets/scripts/wsl_distro_move.ps1)

Script allows moving WSL distro from the default location e.g. to another disk. If you specify `-NewName` parameter, it will also rename the  distribution - it allows to conveniently *multiply* existing distros.  
Imagine, that you have Ubuntu distro installed, but you want to have another, fresh one. You can use the script to move distro to existing location with the new name, and then you can type `ubuntu.exe` in therminal and it will setup new, fresh Ubuntu distro.

``` powershell
# Copy existing WSL distro to new location
.assets/scripts/wsl_distro_move.ps1 'Ubuntu' -Destination 'D:\WSL'
# Copy existing WSL distro to new location and rename it
.assets/scripts/wsl_distro_move.ps1 'Ubuntu' -Destination 'D:\WSL' -NewName 'Ubuntu2'
```

## [wsl_files_copy](../.assets/scripts/wsl_files_copy.ps1)

Copy files between WSL distributions. It mounts source distro and copy files from the mount to destination distro.
It is much faster than copying files in the Windows Explorer and preserves Linux files attributes and links.

``` powershell
# Copy files as default user between distros
.assets/scripts/wsl_files_copy.ps1 -Source 'Ubuntu:~/source/repos' -Destination 'Debian'
# Copy files as root between distros
.assets/scripts/wsl_files_copy.ps1 -Source 'Ubuntu:~/source/repos' -Destination 'Debian' -Root
```

## [wsl_flags_manage](../.assets/scripts/wsl_flags_manage.ps1)

Allows modify WSL distro flags for interop, appending Windows paths and mounting Windows drives inside WSL.

``` powershell
# Disable WSL_DISTRIBUTION_FLAGS_APPEND_NT_PATH flag inside WSL distro. Speeds up finding applications in PATH.
.assets/scripts/wsl_flags_manage.ps1 'Ubuntu' -AppendWindowsPath $false
```

## [wsl_network_fix](../.assets/scripts/wsl_network_fix.ps1)

Copies existing Windows network interface properties to `resolv.conf` inside WSL distro, and some other tricks, to fix network connectivity inside WSL. Useful with some VPN solutions which messes up WSL networking.

``` powershell
# copy Windows network interface properties to WSL
.assets/scripts/wsl_network_fix.ps1 'Ubuntu'
# copy Windows network interface properties to WSL and disables WSL swap
.assets/scripts/wsl_network_fix.ps1 'Ubuntu' -DisableSwap
# copy Windows network interface properties to WSL, disables WSL swap and shuts down distro
.assets/scripts/wsl_network_fix.ps1 'Ubuntu' -Shutdown -DisableSwap
```

## [wsl_restart](../.assets/scripts/wsl_restart.ps1)

Restarts WSL. Useful when WSL distro hangs.

``` powershell
.assets/scripts/wsl_restart.ps1
```

## [wsl_systemd](../.assets/scripts/wsl_systemd.ps1)

Enables/disables systemd in the specified distro.

``` powershell
# enable systemd
.assets/scripts/wsl_systemd.ps1 'Ubuntu' -Systemd 'true'
# disable systemd
.assets/scripts/wsl_systemd.ps1 'Ubuntu' -Systemd 'false'
```

## [wsl_win_path](../.assets/scripts/wsl_win_path.ps1)

> OBSOLETE script, the functionality has been replaced with the `wsl_flags_manage.ps1` script.
