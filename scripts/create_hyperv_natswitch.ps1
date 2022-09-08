<#
.SYNOPSIS
Script synopsis.
.PARAMETER NatNetwork
NAT network CIDR range.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory, Position = 0)]
    [string]$NatNetwork,

    [Parameter(Mandatory, Position = 1)]
    [string]$VMName
)

# calculate IP address and prefix
$ipAddress, $prefix = $NatNetwork.Split('/') -replace '0$', '1'

if ('NATSwitch' -notin (Get-VMSwitch | Select-Object -ExpandProperty Name)) {
    Write-Host "Creating Internal-only switch named 'NATSwitch' on Windows Hyper-V host..."
    New-VMSwitch -SwitchName 'NATSwitch' -SwitchType Internal
    New-NetIPAddress -IPAddress $ipAddress -PrefixLength $prefix -InterfaceAlias 'vEthernet (NATSwitch)'
    New-NetNat -Name 'NATNetwork' -InternalIPInterfaceAddressPrefix $NatNetwork
} else {
    Write-Host "'NATSwitch' for static IP configuration already exists; skipping"
}

if ($ipAddress -notin (Get-NetIPAddress -InterfaceAlias 'vEthernet (NATSwitch)' | Select-Object -ExpandProperty IPAddress)) {
    Write-Host "Registering new IP address '$ipAddress' on Windows Hyper-V host..."
    New-NetIPAddress -IPAddress $ipAddress -PrefixLength $prefix -InterfaceAlias 'vEthernet (NATSwitch)'
} else {
    Write-Host "'$ipAddress' for static IP configuration already registered; skipping"
}

if ($NatNetwork -notin (Get-NetNat | Select-Object -ExpandProperty InternalIPInterfaceAddressPrefix)) {
    Write-Host "Registering new NAT adapter for '$NatNetwork' on Windows Hyper-V host..."
    New-NetNat -Name 'NATNetwork' -InternalIPInterfaceAddressPrefix $NatNetwork
} else {
    Write-Host "'$NatNetwork' for static IP configuration already registered; skipping"
}

Write-Host "Update configuration version"
Update-VMVersion -Name $VMName
