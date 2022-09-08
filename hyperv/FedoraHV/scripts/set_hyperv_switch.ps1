<#
.SYNOPSIS
Script synopsis.
.PARAMETER NatNetwork
NAT network CIDR range.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory, Position = 0)]
    [string]$VMName
)

Get-VM $VMName | Get-VMNetworkAdapter | Connect-VMNetworkAdapter -SwitchName 'NATSwitch'
