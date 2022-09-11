function _ { & /usr/bin/env sudo pwsh -NoProfile -Command "& $args" }
function alias ([string]$CmdletName) {
    Get-Alias | `
        Where-Object -FilterScript { $_.Definition -match $CmdletName } | `
        Sort-Object -Property Definition, Name | `
        Select-Object -Property Definition, Name
}
function .. { Set-Location ../ }
function ... { Set-Location ../../ }
function cd.. { Set-Location ../ }
function grep { $input | & /usr/bin/env grep --color=auto $args }
function less { $input | & /usr/bin/env less -FSRXc $args }
function ll {
    $arguments = $args.ForEach({ $_ -match ' ' ? "'$_'" : $_ })
    Invoke-Expression "Get-ChildItem $arguments -Force"
}
function ls { & /usr/bin/env ls --color=auto --group-directories-first $args }
function l { & /usr/bin/env ls -1 --color=auto --group-directories-first $args }
function la { & /usr/bin/env ls -lAh --color=auto --time-style=long-iso --group-directories-first $args }
function lsa { & /usr/bin/env ls -lah --color=auto --time-style=long-iso --group-directories-first $args }
function md { mkdir -p $args }
function mkdir { & /usr/bin/env mkdir -pv $args }
function mv { & /usr/bin/env mv -iv $args }
function nano { & /usr/bin/env nano -W $args }
function pwsh { & /usr/bin/env pwsh -nol $args }
function p { & /usr/bin/env pwsh -nol $args }
function src { . $PROFILE.CurrentUserAllHosts }
function wget { & /usr/bin/env wget -c $args }
