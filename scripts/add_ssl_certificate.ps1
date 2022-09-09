#!/usr/bin/pwsh -nop
<#
.SYNOPSIS
Script synopsis.
.EXAMPLE
$Path = 'hyperv/CentOS8HV/Vagrantfile'
scripts\add_ssl_certificate.ps1 -p $Path
#>

[CmdletBinding()]
[OutputType([System.Void])]
param (
    [Parameter()]
    [string]$Path
)

# get the root certificate in certificate chain
$certPath = (scripts/get_certificate_chain.ps1 -Path '.tmp').Where({ $_ -match 'root\w+\.crt' })
# get root certificate content
$crt = [IO.File]::ReadAllText($certPath)

$scriptInstallRootCA = @"
script_install_root_ca = <<-SCRIPT
cat <<EOF >/etc/pki/ca-trust/source/anchors/pg_root_ca.crt
${crt}EOF
update-ca-trust
SCRIPT`n`n
"@

# update content of the specified Vagrantfile with certificate installation
$content = [IO.File]::ReadAllText($Path) `
    -replace '(?<=# \*Scripts)\n', "`n$scriptInstallRootCA" `
    -replace '(?<=# install packages)\n', "`n    node.vm.provision 'shell', name: 'install Root CA...', inline: script_install_root_ca`n"

# save updated Vagrantfile
[IO.File]::WriteAllText($Path, $content)
