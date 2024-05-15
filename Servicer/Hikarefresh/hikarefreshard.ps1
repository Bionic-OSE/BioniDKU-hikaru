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
$tempuid = -join ((48..57) + (97..122) | Get-Random -Count 32 | % {[char]$_})
New-Item -Path $env:TEMP -Name $tempuid -itemType Directory
Copy-Item -Path  $env:SYSTEMDRIVE\Bionic\Hikarefresh\* -Include 7z*.* -Destination $env:TEMP\$tempuid
if (Check-SafeMode) {
	Stop-Process -Name "HikaruQML" -Force
	Stop-Process -Name "HikaruBuildMod" -Force
} else {
	Stop-Process -Name "HikaruQMLu" -Force -ErrorAction SilentlyContinue
	Stop-ScheduledTask -TaskName 'BioniDKU Hot Keys Service' -ErrorAction SilentlyContinue
	Stop-ScheduledTask -TaskName 'BioniDKU Windows Build String Modifier' -ErrorAction SilentlyContinue
	Start-Sleep -Seconds 1
	$qmlchk = Get-Process -Name "HikaruQML" -ErrorAction SilentlyContinue
	$bmdchk = Get-Process -Name "HikaruBuildMod" -ErrorAction SilentlyContinue
	if ($qmlchk -ne $null) {Stop-Process -Name "HikaruQML" -Force}
	if ($bmdchk -ne $null) {Stop-Process -Name "HikaruBuildMod" -Force}
}
Start-Sleep -Seconds 2
Start-Process $env:TEMP\$tempuid\7za.exe -Wait -NoNewWindow -ArgumentList "x $env:SYSTEMDRIVE\Bionic\Executables.7z -pBioniDKU -o$env:SYSTEMDRIVE\Bionic -aoa"
Remove-Item -Path $env:TEMP\$tempuid -Recurse -Force

& $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshvi.ps1
Restart-HikaruShell
if (Check-SafeMode) {
	Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\HikaruQML.exe
	Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\HikaruBuildMod.exe
} else {
	Start-ScheduledTask -TaskName 'BioniDKU Hot Keys Service' -ErrorAction SilentlyContinue
	Start-ScheduledTask -TaskName 'BioniDKU Windows Build String Modifier' -ErrorAction SilentlyContinue
}
Write-Host " "; Write-Host "Update completed" -ForegroundColor Black -BackgroundColor White
Start-Sleep -Seconds 5
