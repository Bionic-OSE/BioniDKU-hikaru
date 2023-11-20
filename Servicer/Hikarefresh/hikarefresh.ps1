# Hikaru-chan background update checker - (c) Bionic Butter

function Show-NotifyBalloon($status) {
	switch ($status) {
		0 {$title = 'No updates are available'; $text = 'Have a good day!'}
		1 {$title = 'BioniDKU Menus System Update available'; $text = 'For more information, please open Quick Menu/Administrative Menu and select 9'}
	}
	[system.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null
	$Global:Balloon = New-Object System.Windows.Forms.NotifyIcon
	$Balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefresh.exe")
	$Balloon.BalloonTipIcon = 'Info'
	$Balloon.BalloonTipText = $text
	$Balloon.BalloonTipTitle = $title
	$Balloon.Visible = $true
	$Balloon.ShowBalloonTip(7000)
}

if (-not (Test-Path -Path "$PSScriptRoot\Delivery")) {New-Item -Path $PSScriptRoot -Name Delivery -itemType Directory}
$launchedfromxm = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").UpdateCheckerLaunchedFrom
Remove-Item -Path $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshinfo.ps1 -Force
Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\wget.exe -Wait -NoNewWindow -ArgumentList "https://github.com/Bionic-OSE/BioniDKU-hikaru/releases/latest/download/Hikarefreshinfo.ps1 -O Hikarefreshinfo.ps1" -WorkingDirectory "$env:SYSTEMDRIVE\Bionic\Hikarefresh"

# Update the serivcer and restart it first

. $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshinfo.ps1
$serviceremote = $servicer
. $env:SYSTEMDRIVE\Bionic\Hikarefresh\HikarefreshinFOLD.ps1

if ($serviceremote -eq $null) {exit}
elseif ($serviceremote -ne $servicer) {
	if ((Test-Path -Path "$PSScriptRoot\Delivery\Servicer.7z.old") -eq $true) {Remove-Item -Path "$PSScriptRoot\Delivery\Servicer.7z.old" -Force}
	if ((Test-Path -Path "$PSScriptRoot\Delivery\Servicer.7z") -eq $true) {Rename-Item -Path "$PSScriptRoot\Delivery\Servicer.7z" -NewName Servicer.7z.old}
	Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\wget.exe -Wait -NoNewWindow -ArgumentList "https://github.com/Bionic-OSE/BioniDKU-hikaru/releases/latest/download/Servicer.7z" -WorkingDirectory "$PSScriptRoot\Delivery"
		if (Test-Path -Path "$PSScriptRoot\Delivery\Servicer.7z" -PathType Leaf) {
			Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\7za.exe -Wait -NoNewWindow -ArgumentList "x $PSScriptRoot\Delivery\Servicer.7z -pBioniDKU -o$env:SYSTEMDRIVE\Bionic -aoa"
			Remove-Item -Path "$env:SYSTEMDRIVE\Bionic\Hikarefresh\HikarefreshinFOLD.ps1" -Force
			Rename-Item -Path "$env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshinfo.ps1" -NewName HikarefreshinFOLD.ps1
			Start-Sleep -Seconds 1
			Start-Process "$env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefresh.exe"
			exit
		} else {exit}
}

# Then we check for updates for the rest

Remove-Item -Path $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarinfo.ps1 -Force
Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\wget.exe -Wait -NoNewWindow -ArgumentList "https://github.com/Bionic-OSE/BioniDKU-hikaru/releases/latest/download/Hikarinfo.ps1" -WorkingDirectory "$env:SYSTEMDRIVE\Bionic\Hikarefresh"

. $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarinfo.ps1
$versionremote = $version
. $env:SYSTEMDRIVE\Bionic\Hikarefresh\HikarinFOLD.ps1

if ($versionremote -eq $null) {
	Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "UpdateAvailable" -Value 0 -Type DWord -Force
	if (@("QM","AM").Contains($launchedfromxm)) {
		Show-NotifyBalloon 0
		Remove-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "UpdateCheckerLaunchedFrom"
		Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\Hikaru${launchedfromxm}.exe"
	}
}
elseif ($versionremote -ne $version) {
	Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "UpdateAvailable" -Value 1 -Type DWord -Force
	Show-NotifyBalloon 1
	if (@("QM","AM").Contains($launchedfromxm)) {
		Remove-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "UpdateCheckerLaunchedFrom"
		Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\Hikaru${launchedfromxm}.exe"
	}
} else {
	Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "UpdateAvailable" -Value 0 -Type DWord -Force
	if (@("QM","AM").Contains($launchedfromxm)) {
		Show-NotifyBalloon 0
		Remove-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "UpdateCheckerLaunchedFrom"
		Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\Hikaru${launchedfromxm}.exe"
	}
}

Remove-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "UpdateCheckerLaunchedFrom"
Start-Sleep -Seconds 7
$Balloon.Visible = $false
