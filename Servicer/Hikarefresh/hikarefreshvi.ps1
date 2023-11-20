& $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshed.ps1
Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "UpdateAvailable" -Value 0 -Type DWord -Force
. $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarinfo.ps1
Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "Version" -Value "22110.$version" -Force
Remove-Item -Path "$env:SYSTEMDRIVE\Bionic\Hikarefresh\HikarinFOLD.ps1" -Force
Rename-Item -Path "$env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarinfo.ps1" -NewName HikarinFOLD.ps1
