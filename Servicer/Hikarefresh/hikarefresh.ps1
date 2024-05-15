# Hikaru-chan background update checker - (c) Bionic Butter

$hkv = "31"

function Show-NotifyBalloon {
	param (
		[Parameter(Mandatory=$True,Position=0)]
		[int32]$status
	)
	switch ($status) {
		0 {$title = 'No updates are available'; $text = 'Have a good day!'}
		1 {$title = 'BioniDKU Menus System Update available'; $text = 'For more information, please open any BioniDKU Menus and select 9'}
		2 {$title = 'Could not check for updates'; $text = 'Either there is no internet or GitHub servers could not be reached'}
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
function Push-CheckResults {
	param (
		[Parameter(Mandatory=$True,Position=0)]
		[int32]$Status
	)
	if ($Status -eq 1) {Show-NotifyBalloon 1}
	if ($Status -eq 2) {$Statuv = 0} else {$Statuv = $Status}
	Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "UpdateAvailable" -Value $Statuv -Type DWord -Force
	$launchedfromxm = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").UpdateCheckerLaunchedFrom
	if (@("QM","AM").Contains($launchedfromxm)) {
		if ($Status -ne 1) {Show-NotifyBalloon $Status}
		Remove-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "UpdateCheckerLaunchedFrom"
		Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\Hikaru${launchedfromxm}.exe"
	}
}

if (-not (Test-Path -Path "$PSScriptRoot\Delivery")) {New-Item -Path $PSScriptRoot -Name Delivery -itemType Directory}
$launchedfromxm = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").UpdateCheckerLaunchedFrom
Remove-Item -Path $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshinfo.ps1 -Force
Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\wget.exe -Wait -NoNewWindow -ArgumentList "https://github.com/Bionic-OSE/BioniDKU-hikaru/releases/latest/download/Servicinfo.${hkv}.ps1 -O Servicinfo.ps1" -WorkingDirectory "$env:SYSTEMDRIVE\Bionic\Hikarefresh"

# Update the serivcer and restart it first

. $env:SYSTEMDRIVE\Bionic\Hikarefresh\Servicinfo.ps1
$serviceremote = $servicer
. $env:SYSTEMDRIVE\Bionic\Hikarefresh\ServicinFOLD.ps1

if ($serviceremote -eq $null) {
	Push-CheckResults 2
	exit
}
elseif ($serviceremote -ne $servicer) {
	if ((Test-Path -Path "$PSScriptRoot\Delivery\Servicer.7z.old") -eq $true) {Remove-Item -Path "$PSScriptRoot\Delivery\Servicer.7z.old" -Force}
	if ((Test-Path -Path "$PSScriptRoot\Delivery\Servicer.7z") -eq $true) {Rename-Item -Path "$PSScriptRoot\Delivery\Servicer.7z" -NewName Servicer.7z.old}
	Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\wget.exe -Wait -NoNewWindow -ArgumentList "https://github.com/Bionic-OSE/BioniDKU-hikaru/releases/latest/download/Servicer.7z" -WorkingDirectory "$PSScriptRoot\Delivery"
		if (Test-Path -Path "$PSScriptRoot\Delivery\Servicer.7z" -PathType Leaf) {
			Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\7za.exe -Wait -NoNewWindow -ArgumentList "x $PSScriptRoot\Delivery\Servicer.7z -pBioniDKU -o$env:SYSTEMDRIVE\Bionic -aoa"
			Remove-Item -Path "$env:SYSTEMDRIVE\Bionic\Hikarefresh\ServicinFOLD.ps1" -Force
			Rename-Item -Path "$env:SYSTEMDRIVE\Bionic\Hikarefresh\Servicinfo.ps1" -NewName ServicinFOLD.ps1
			Start-Sleep -Seconds 1
			Start-Process "$env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefresh.exe"
			exit
		} else {exit}
}

# Then we check for updates for the rest

Remove-Item -Path $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarinfo.ps1 -Force
Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\wget.exe -Wait -NoNewWindow -ArgumentList "https://github.com/Bionic-OSE/BioniDKU-hikaru/releases/latest/download/Hikarinfo.${hkv}.ps1 -O Hikarinfo.ps1" -WorkingDirectory "$env:SYSTEMDRIVE\Bionic\Hikarefresh"

. $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarinfo.ps1
$versionremote = $version
. $env:SYSTEMDRIVE\Bionic\Hikarefresh\HikarinFOLD.ps1

if ($versionremote -eq $null) {
	Push-CheckResults 2
} elseif ($versionremote -ne $version) {
	Push-CheckResults 1
} else {
	Push-CheckResults 0
}

Start-Sleep -Seconds 7
$Balloon.Visible = $false
