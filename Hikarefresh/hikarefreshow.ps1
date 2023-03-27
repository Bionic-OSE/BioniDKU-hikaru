# Hikaru-chan on-demand updater - (c) Bionic Butter

$host.UI.RawUI.WindowTitle = "BioniDKU Quick Menu Updater"
function Show-Branding {
	Clear-Host
	Write-Host "BioniDKU Quick Menu Updater" -ForegroundColor Black -BackgroundColor White
	Write-Host ' '
}
Show-Branding
Write-Host "An update is available:" -ForegroundColor White; Write-Host " "

function Start-Hikarefreshing {
	Show-Branding
	Write-Host "Got it, proceeding to update" -ForegroundColor White; Write-Host " "
	if ((Test-Path -Path "$env:SYSTEMDRIVE\Bionic\Hikaru.7z.old") -eq $true) {Remove-Item -Path "$env:SYSTEMDRIVE\Bionic\Hikaru.7z.old" -Force}
	if ((Test-Path -Path "$env:SYSTEMDRIVE\Bionic\Hikare.7z.old") -eq $true) {Remove-Item -Path "$env:SYSTEMDRIVE\Bionic\Hikare.7z.old" -Force}
	if ((Test-Path -Path "$env:SYSTEMDRIVE\Bionic\Hikaru.7z") -eq $true) {Rename-Item -Path "$env:SYSTEMDRIVE\Bionic\Hikaru.7z" -NewName Hikaru.7z.old}
	if ((Test-Path -Path "$env:SYSTEMDRIVE\Bionic\Hikare.7z") -eq $true) {Rename-Item -Path "$env:SYSTEMDRIVE\Bionic\Hikare.7z" -NewName Hikare.7z.old}
	while ($true) {
		Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\wget.exe -Wait -ArgumentList "https://github.com/Bionic-OSE/BioniDKU-utils/releases/latest/download/Hikaru.7z" -WorkingDirectory "$env:SYSTEMDRIVE\Bionic"
		if (Test-Path -Path "$env:SYSTEMDRIVE\Bionic\Hikaru.7z" -PathType Leaf) {break} else {
			Write-Host " "
			Write-Host -ForegroundColor White "Did the transfer fail?" -n; Write-Host " Retrying..."
		}
	}
	Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\7za.exe -Wait -NoNewWindow -ArgumentList "e $env:SYSTEMDRIVE\Bionic\Hikaru.7z -pBioniDKU -o$env:SYSTEMDRIVE\Bionic -aoa"
	& $env:SYSTEMDRIVE\Bionic\Hikaru\Hikarefreshed.ps1
	if ($hardupdate) {
		while ($true) {
			Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\wget.exe -Wait -ArgumentList "https://github.com/Bionic-OSE/BioniDKU-utils/releases/latest/download/Hikare.7z" -WorkingDirectory "$env:SYSTEMDRIVE\Bionic"
			if (Test-Path -Path "$env:SYSTEMDRIVE\Bionic\Hikare.7z" -PathType Leaf) {break} else {
				Write-Host " "
				Write-Host -ForegroundColor White "Did the transfer fail?" -n; Write-Host " Retrying..."
			}
		}
		Start-Process powershell -ArgumentList "-Command `"Start-Sleep -Seconds 5; Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\7za.exe -ArgumentList `"e $env:SYSTEMDRIVE\Bionic\Hikare.7z -pBioniDKU -o$env:SYSTEMDRIVE\Bionic -aoa`"; Write-Host `" `"; Write-Host `"Update complete`" -ForegroundColor Black -BackgroundColor White; Start-Sleep -Seconds 5`""
		exit
	}
	Write-Host " "; Write-Host "Update complete" -ForegroundColor Black -BackgroundColor White
	Start-Sleep -Seconds 5
}

. $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarinfo.ps1
$versionremote = $version
. $env:SYSTEMDRIVE\Bionic\Hikarefresh\HikarinFOLD.ps1
Write-Host "Version: " -ForegroundColor White -n; Write-Host "$versionremote" -n; Write-Host " (You have: " -n; Write-Host "$version)"
. $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarinfo.ps1
Write-Host "Package size: $size"
Write-Host "Update information: $descr"

Write-Host " "
Write-Host "Select one of the following actions:" -ForegroundColor White
Write-Host "1. Accept update" -ForegroundColor White
Write-Host "0. Cancel and close this window" -ForegroundColor White
Write-Host "Your selection: " -n; $act = Read-Host
switch ($act) {
	{$act -like "0"} {exit}
	{$act -like "1"} {Start-Hikarefreshing}
}