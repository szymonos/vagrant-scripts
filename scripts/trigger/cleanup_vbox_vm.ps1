<#
.SYNOPSIS
Script synopsis.
.PARAMETER VMName
Name of the virtual machine.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory, Position = 0)]
    [string]$VMName
)

Remove-Item "$HOME\VirtualBox VMs\$VMName" -Force -Recurse
