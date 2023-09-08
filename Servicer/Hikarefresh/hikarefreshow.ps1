# Hikaru-chan on-demand updater - (c) Bionic Butter

$host.UI.RawUI.WindowTitle = "BioniDKU Menus System Updater"
function Show-Branding {
	Clear-Host
	Write-Host "BioniDKU Menus System Updater" -ForegroundColor Black -BackgroundColor White
	Write-Host ' '
}
Show-Branding
Write-Host "An update is available:" -ForegroundColor White; Write-Host " "

function Start-Hikarefreshing($hv) {
	Show-Branding
	Write-Host "Got it, proceeding to update (Stage 1)" -ForegroundColor White; Write-Host " "
	Start-Sleep -Seconds 3
	if ((Test-Path -Path "$env:SYSTEMDRIVE\Bionic\Hikaru.7z.old") -eq $true) {Remove-Item -Path "$env:SYSTEMDRIVE\Bionic\Hikaru.7z.old" -Force}
	if ((Test-Path -Path "$env:SYSTEMDRIVE\Bionic\Hikare.7z.old") -eq $true) {Remove-Item -Path "$env:SYSTEMDRIVE\Bionic\Hikare.7z.old" -Force}
	if ((Test-Path -Path "$env:SYSTEMDRIVE\Bionic\Hikaru.7z") -eq $true) {Rename-Item -Path "$env:SYSTEMDRIVE\Bionic\Hikaru.7z" -NewName Hikaru.7z.old}
	if ((Test-Path -Path "$env:SYSTEMDRIVE\Bionic\Hikare.7z") -eq $true) {Rename-Item -Path "$env:SYSTEMDRIVE\Bionic\Hikare.7z" -NewName Hikare.7z.old}
	while ($true) {
		Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\wget.exe -Wait -NoNewWindow -ArgumentList "https://github.com/Bionic-OSE/BioniDKU-hikaru/releases/latest/download/Hikaru.7z" -WorkingDirectory "$env:SYSTEMDRIVE\Bionic"
		if (Test-Path -Path "$env:SYSTEMDRIVE\Bionic\Hikaru.7z" -PathType Leaf) {break} else {
			Write-Host " "
			Write-Host -ForegroundColor White "Did the transfer fail?" -n; Write-Host " Retrying..."
		}
	}
	Start-Process 7za -Wait -NoNewWindow -ArgumentList "x $env:SYSTEMDRIVE\Bionic\Hikaru.7z -pBioniDKU -o$env:SYSTEMDRIVE\Bionic -aoa"
	while ($hv -eq 1) {
		Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\wget.exe -Wait -NoNewWindow -ArgumentList "https://github.com/Bionic-OSE/BioniDKU-hikaru/releases/latest/download/Hikare.7z" -WorkingDirectory "$env:SYSTEMDRIVE\Bionic"
		if (Test-Path -Path "$env:SYSTEMDRIVE\Bionic\Hikare.7z" -PathType Leaf) {
			Start-Process powershell -ArgumentList "-Command $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshard.ps1"
			break
		} else {
			Write-Host " "
			Write-Host -ForegroundColor White "Did the transfer fail?" -n; Write-Host " Retrying..."
		}
	}
	if ($hv -ne 1) {
		& $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshed.ps1
		Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "UpdateAvailable" -Value 0 -Type DWord -Force
	}
	. $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarinfo.ps1
	Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "Version" -Value "22108.$version" -Force
	Remove-Item -Path "$env:SYSTEMDRIVE\Bionic\Hikarefresh\HikarinFOLD.ps1" -Force
	Rename-Item -Path "$env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarinfo.ps1" -NewName HikarinFOLD.ps1
	exit
}

. $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarinfo.ps1
$versionremote = $version
$minbaseremote = $minbase
. $env:SYSTEMDRIVE\Bionic\Hikarefresh\HikarinFOLD.ps1
Write-Host "Version: " -ForegroundColor White -n; Write-Host "$versionremote" -n; Write-Host " (You have: " -n; Write-Host "$version)"
. $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarinfo.ps1
Write-Host "Package size: " -ForegroundColor White -n; Write-Host "$size"
Write-Host "Update information: " -ForegroundColor White -n; Write-Host "$descr"
. $env:SYSTEMDRIVE\Bionic\Hikarefresh\HikarinFOLD.ps1

Write-Host " "
Write-Host "Select one of the following actions:" -ForegroundColor White
Write-Host "1. Accept update" -ForegroundColor White
Write-Host "0. Cancel and close this window" -ForegroundColor White
Write-Host "> " -n; $act = Read-Host
switch ($act) {
	{$act -like "0"} {exit}
	{$act -like "1"} {
		if ($minbaseremote -notlike $minbase) {$hard = 1} else {$hard = 0}
		Start-Hikarefreshing $hard
	}
}
