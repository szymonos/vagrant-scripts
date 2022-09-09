<#
.SYNOPSIS
Script for saving root and intermediate certificates from certificate chain.
.EXAMPLE
scripts/get_certificate_chain.ps1
$Path = '.tmp'; scripts/get_certificate_chain.ps1 -p $Path
#>
[CmdletBinding()]
[OutputType([Collections.Generic.List[string]])]
param (
    [Alias('p')]
    [ValidateNotNullorEmpty()]
    [string]$Path = '.'
)

# create destination path if not exists
if (-not (Test-Path $Path -PathType Container)) {
    New-Item $Path -ItemType Directory | Out-Null
}

# get full certificate chain
$chain = (Out-Null | openssl s_client -showcerts -connect www.google.com:443) -join "`n"
$certs = ($chain | Select-String '-{5}BEGIN [\S\n]+ CERTIFICATE-{5}' -AllMatches).Matches.Value

$result = [Collections.Generic.List[string]]::new()
# save root and intermediate certificates
for ($i = 1; $i -lt $certs.Count; $i++) {
    $certRawData = [Convert]::FromBase64String(($certs[$i] -replace ('-.*-')).Trim())
    $cert = [Security.Cryptography.X509Certificates.X509Certificate]::new($certRawData)
    $cn = $cert.Subject.Split(',')[0].Split('=')[1].Replace(' ', '_').ToLower()
    $result.Add([System.IO.Path]::Join((Resolve-Path $Path).Path, "$cn.crt"))
    Set-Content -Path $result[$i - 1] -Value $certs[$i]
}

return $result
