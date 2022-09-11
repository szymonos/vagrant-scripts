<#
.SYNOPSIS
Update ssh config and known_hosts files.
.PARAMETER IpAddress
IP of the host in ssh config file.
.PARAMETER HostName
Name of the host in ssh config file.
.EXAMPLE
$IpAddress = '192.168.121.88'
$HostName = 'fedorahv'
scripts/trigger/set_ssh_config.ps1 $IpAddress $HostName
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory, Position = 0)]
    [string]$IpAddress,

    [Parameter(Mandatory, Position = 1)]
    [string]$HostName
)

$sshConfig = "$HOME/.ssh/config"
$knownHosts = "$HOME/.ssh/known_hosts"
$vagrantConfig = @"
Host $HostName
  HostName $IpAddress
  User vagrant
"@

Write-Host "Adding $HostName to ssh config..."
if (-not (Test-Path $sshConfig)) { New-Item $sshConfig -ItemType File -Force }
if (Select-String -Pattern "HostName $IpAddress" -Path $sshConfig) {
    # update Host if HostName entry already present
    $content = [IO.File]::ReadAllText($sshConfig) -replace "Host[^\n]+\n[^\n]+$IpAddress\n[\s\S]+?(?=(\nHost|\z))", $vagrantConfig
    [IO.File]::WriteAllText($sshConfig, $content)
} elseif (Select-String -Pattern "Host $HostName" -Path $sshConfig) {
    # update HostName if Host entry already present
    $content = [IO.File]::ReadAllText($sshConfig) -replace "Host $HostName[\s\S]+?(?=(\nHost|\z))", $vagrantConfig
    [IO.File]::WriteAllText($sshConfig, $content)
} else {
    Add-Content -Value $vagrantConfig -Path $sshConfig
}

if (Test-Path $knownHosts) {
    Write-Host 'Cleaning ssh known_hosts file...'
    if (Select-String -Pattern "^$IpAddress" -Path $knownHosts) {
        $content = [IO.File]::ReadAllLines($knownHosts) -notmatch "^$IpAddress"
        [IO.File]::WriteAllLines($knownHosts, $content)
    }
}

if (Get-Command ssh-keyscan -ErrorAction SilentlyContinue) {
    Write-Host 'Adding fingerprint to ssh known_hosts file...'
    do {
        $knownIP = ssh-keyscan $IpAddress 2>$null
        if ($knownIP) {
            $knownIP | Add-Content -Path $knownHosts
        }
    } until ($knownIP)
}
