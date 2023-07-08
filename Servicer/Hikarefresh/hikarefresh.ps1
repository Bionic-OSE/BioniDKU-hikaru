# Hikaru-chan background update checker - (c) Bionic Butter

$prodname = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").ProductName
function Show-NotifyBalloon {
	[system.Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms') | Out-Null
	$Global:Balloon = New-Object System.Windows.Forms.NotifyIcon
	$Balloon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("$env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefresh.exe")
	$Balloon.BalloonTipIcon = 'Info'
	$Balloon.BalloonTipText = 'For more information, please open Quick Menu/Administrative Menu and select 9'
	$Balloon.BalloonTipTitle = '$prodname Quick Menu Update available'
	$Balloon.Visible = $true
	$Balloon.ShowBalloonTip(7000)
}

# Update the servicing compoments first

Remove-Item -Path $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshinfo.ps1 -Force
Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\wget.exe -Wait -NoNewWindow -ArgumentList "https://github.com/Bionic-OSE/BioniDKU-hikaru/releases/latest/download/Hikarefreshinfo.ps1" -WorkingDirectory "$env:SYSTEMDRIVE\Bionic\Hikarefresh"

. $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshinfo.ps1
$serviceremote = $servicer
. $env:SYSTEMDRIVE\Bionic\Hikarefresh\HikarefreshinFOLD.ps1

if ($serviceremote -eq $null) {exit}
elseif ($serviceremote -ne $servicer) {
	if ((Test-Path -Path "$env:SYSTEMDRIVE\Bionic\Hikarup.7z") -eq $true) {Rename-Item -Path "$env:SYSTEMDRIVE\Bionic\Hikarup.7z" -NewName Hikarup.7z.old}
	Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\wget.exe -Wait -NoNewWindow -ArgumentList "https://github.com/Bionic-OSE/BioniDKU-hikaru/releases/latest/download/Hikarup.7z" -WorkingDirectory "$env:SYSTEMDRIVE\Bionic"
		if (Test-Path -Path "$env:SYSTEMDRIVE\Bionic\Hikarup.7z" -PathType Leaf) {
			Start-Process 7za -Wait -NoNewWindow -ArgumentList "x $env:SYSTEMDRIVE\Bionic\Hikarup.7z -pBioniDKU -o$env:SYSTEMDRIVE\Bionic -aoa"
			Remove-Item -Path "$env:SYSTEMDRIVE\Bionic\Hikarefresh\HikarefreshinFOLD.ps1" -Force
			Rename-Item -Path "$env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshinfo.ps1" -NewName HikarefreshinFOLD.ps1
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
}
elseif ($versionremote -ne $version) {
	Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "UpdateAvailable" -Value 1 -Type DWord -Force
	Show-NotifyBalloon
} else {
	Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "UpdateAvailable" -Value 0 -Type DWord -Force
}
