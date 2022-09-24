#!/usr/bin/pwsh -nop
<#
.SYNOPSIS
Script synopsis.
.EXAMPLE
.assets/trigger/create_ssh_keypair.ps1
#>

if (-not (Test-Path "$HOME/.ssh/id_rsa")) {
    ssh-keygen -b 4096 -t rsa -f "$HOME/.ssh/id_rsa" -q -N ''
}
