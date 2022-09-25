<#
.SYNOPSIS
Clean up ssh config and remove entries from known_hosts on destroy.
.PARAMETER IpAddress
IP of the host in ssh config file.
.PARAMETER HostName
Name of the host in ssh config file.
.EXAMPLE
$IpAddress = '192.168.121.88'
$HostName = 'fedorahv'
.assets/trigger/delete_ssh_config.ps1 $IpAddress $HostName
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory, Position = 0)]
    [string]$IpAddress,

    [Parameter(Mandatory, Position = 1)]
    [string]$HostName
)

$sshConfig = "$HOME/.ssh/config"
if (Test-Path $sshConfig -PathType Leaf) {
    Write-Host "Removing $HostName from ssh config..."
    $content = [IO.File]::ReadAllText($sshConfig).TrimEnd()
    if (Select-String -Pattern "HostName $IpAddress" -Path $sshConfig) {
        # update Host if HostName entry already present
        $content = $content -replace "Host[^\n]+\n[^\n]+$IpAddress\n[\s\S]+?(?=(\nHost|\z))"
        [IO.File]::WriteAllText($sshConfig, $content)
    } elseif (Select-String -Pattern "Host $HostName" -Path $sshConfig) {
        # update HostName if Host entry already present
        $content = $content -replace "Host $HostName[\s\S]+?(?=(\nHost|\z))"
        [IO.File]::WriteAllText($sshConfig, $content)
    }
}

$knownHosts = "$HOME/.ssh/known_hosts"
if (Test-Path $knownHosts -PathType Leaf) {
    Write-Host 'Cleaning ssh known_hosts file...'
    if (Select-String -Pattern "^$IpAddress" -Path $knownHosts) {
        $content = [IO.File]::ReadAllLines($knownHosts) -notmatch "^$IpAddress"
        [IO.File]::WriteAllLines($knownHosts, $content)
    }
}
