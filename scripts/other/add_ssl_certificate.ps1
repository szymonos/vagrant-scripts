#!/usr/bin/pwsh -nop
<#
.SYNOPSIS
Script synopsis.
.EXAMPLE
$Path = 'hyperv/CentOS8HV/Vagrantfile'
scripts/other/add_ssl_certificate.ps1 -p $Path
#>

[CmdletBinding()]
[OutputType([System.Void])]
param (
    [Parameter()]
    [string]$Path
)

$scriptInstallRootCA = '.tmp/script_install_root_ca.sh'
# *Content of specified Vagrantfile
$content = [IO.File]::ReadAllText($Path)

# create installation script
if (-not (Test-Path $scriptInstallRootCA -PathType Leaf)) {
    New-Item (Split-Path $scriptInstallRootCA) -ItemType Directory -ErrorAction SilentlyContinue
    $chain = (Out-Null | openssl s_client -showcerts -connect www.google.com:443) -join "`n"
    $crt = ($chain | Select-String '-{5}BEGIN [\S\n]+ CERTIFICATE-{5}' -AllMatches).Matches.Value[-1]
    # save certificate installation file
    [IO.File]::WriteAllText($scriptInstallRootCA, "cat <<'EOF' >/etc/pki/ca-trust/source/anchors/pg_root_ca.crt`n${crt}`nEOF`nupdate-ca-trust")
}

# add cert installation shell command to Vagrantfile
if (-not ($content | Select-String $scriptInstallRootCA)) {
    $content = $content -replace '(?<=# install packages)\n', "`n    node.vm.provision 'shell', name: 'install Root CA...', path: '../../.tmp/script_install_root_ca.sh'`n"
    # save updated Vagrantfile
    [IO.File]::WriteAllText($Path, $content)
}
