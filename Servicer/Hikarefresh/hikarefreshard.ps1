# Hikaru-chan hard files updater - (c) Bionic Butter

$host.UI.RawUI.WindowTitle = "BioniDKU Menus System Updater | DO NOT CLOSE THIS WINDOW"
function Show-Branding {
	Clear-Host
	Write-Host "BioniDKU Menus System Updater" -ForegroundColor Black -BackgroundColor White
	Write-Host "Executables layer updater`r`n"
}

Show-Branding
Write-Host "Updating hard (executables) layer" -ForegroundColor White; Write-Host " "

. $env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestart.ps1
Stop-Process -Name HikaruQML
if (Check-SafeMode) {Stop-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\HikaruBuildMod.exe" -Force} else {Stop-ScheduledTask -TaskName 'BioniDKU Windows Build String Modifier'}
Start-Sleep -Seconds 3
Start-Process 7za -Wait -NoNewWindow -ArgumentList "x $env:SYSTEMDRIVE\Bionic\Executables.7z -pBioniDKU -o$env:SYSTEMDRIVE\Bionic -aoa"
& $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshed.ps1
Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "UpdateAvailable" -Value 0 -Type DWord -Force
Restart-HikaruShell
Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\HikaruQML.exe
Write-Host " "; Write-Host "Update completed" -ForegroundColor Black -BackgroundColor White
Write-Host "Press Enter to exit."; Read-Host
