# Hikaru-chan for BioniDKU OSTE - (c) Bionic Butter

. $env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestart.ps1
$ssv = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").StartupSoundVariant

Restart-HikaruShell -NoStop -NoSpin

taskkill /f /im FFPlay.exe
Start-Sleep -Seconds 1
Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $env:SYSTEMDRIVE\Bionic\Hikaru\StartupSound${ssv}.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"
