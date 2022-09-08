#Requires -Version 7.2
#Requires -Modules PSReadLine

#region startup settings
if (Get-Command git -ErrorAction SilentlyContinue) {
    # import posh-git module for git autocompletion.
    Import-Module posh-git; $GitPromptSettings.EnablePromptStatus = $false
}
# make PowerShell console Unicode (UTF-8) aware
$OutputEncoding = [Console]::InputEncoding = [Console]::OutputEncoding = [Text.UTF8Encoding]::new()
# set culture to English Sweden for ISO-8601 datetime settings
[Threading.Thread]::CurrentThread.CurrentCulture = 'en-SE'
# Change PSStyle for directory coloring.
$PSStyle.FileInfo.Directory = "$($PSStyle.Bold)$($PSStyle.Foreground.Blue)"
# Configure PSReadLine setting.
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -PredictionSource History -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Chord F2 -Function SwitchPredictionView
Set-PSReadLineKeyHandler -Chord Shift+Tab -Function AcceptSuggestion
Set-PSReadLineKeyHandler -Chord Alt+j -Function NextHistory
Set-PSReadLineKeyHandler -Chord Alt+k -Function PreviousHistory
# set Startup Working Directory variable
$SWD = $PWD.Path
#endregion

#region functions
# navigation functions
function cds { Set-Location $SWD }
function .. { Set-Location .. }
function ... { Set-Location ../.. }
function .... { Set-Location ../../.. }
function ..... { Set-Location ../../../.. }

# ls functions
function ll {
    $arguments = $args.ForEach({ $_ -match ' ' ? "'$_'" : $_ })
    Invoke-Expression "Get-ChildItem $arguments -Force"
}
function ls { & /usr/bin/env ls --color=auto --time-style=long-iso --group-directories-first $args }
function l { ls -1 }
function la { ls -lAh }
function lsa { ls -lah }

# other functions
function src { . $PROFILE.CurrentUserAllHosts }
function Invoke-Sudo { & /usr/bin/env pwsh -NoProfile -Command "& $args" }
function grep { $input | & /usr/bin/env grep --color=auto $args }
#endregion

# import kubectl functions
if ((Get-Command kubectl -ErrorAction SilentlyContinue) -and (Test-Path '/opt/microsoft/powershell/7/kubectl_functions.ps1')) {
    . '/opt/microsoft/powershell/7/kubectl_functions.ps1'
}
#endregion

#region aliases
Set-Alias _ Invoke-Sudo
#endregion

#region PATH
@("$HOME/.local/bin") | ForEach-Object {
    if ((Test-Path $_) -and $env:PATH -NotMatch $_) {
        $env:PATH = [string]::Join(':', $_, $env:PATH)
    }
}
#endregion

#region startup information
Write-Host ("$($PSStyle.Foreground.BrightWhite){0} | PowerShell $($PSVersionTable.PSVersion)$($PSStyle.Reset)" `
        -f (Select-String -Pattern '^PRETTY_NAME=(.*)' -Path /etc/os-release).Matches.Groups[1].Value.Trim("`"|'"))
#endregion

if ((Get-Command oh-my-posh -ErrorAction SilentlyContinue) -and (Test-Path '/etc/profile.d/theme.omp.json')) {
    oh-my-posh --init --shell pwsh --config /etc/profile.d/theme.omp.json | Invoke-Expression
}
