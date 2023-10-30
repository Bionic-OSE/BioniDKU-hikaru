# BioniDKU Quick Menu (codenamed "HikaruQM") - (c) Bionic Butter

$prodname = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").ProductName
$update = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").UpdateAvailable
. $env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestart.ps1

Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $env:SYSTEMDRIVE\Bionic\Hikaru\HikaruQMBeep.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"

function Show-Branding {
	$host.UI.RawUI.WindowTitle = "$prodname Quick Menu"
	Clear-Host
	Write-Host "$prodname Quick Menu" -ForegroundColor Black -BackgroundColor White
	Write-Host ' '
}
function Show-Menu {
	Show-Branding
	if ($update -eq 1) {
		$updateopt = "9. View update`r`n "
		Write-Host "An update is available, select option 9 for more information`r`n" -ForegroundColor White
	} else {$updateopt = "9. Check for updates`r`n "}
	Write-Host "What do you want to do?`r`n" -ForegroundColor White
	Write-Host " Shell tasks"
	Write-Host " 1. Restart Explorer shell" -ForegroundColor White
	Write-Host " 2. Change taskbar location" -ForegroundColor White
	Write-Host " 3. Change sign-in sound`r`n" -ForegroundColor White
	Write-Host " Configure your device"
	Write-Host " 4. Adjust time settings" -ForegroundColor White
	Write-Host " 5. Adjust power settings`r`n" -ForegroundColor White
	Write-Host " Others"
	Write-Host " ${updateopt}0. Close this menu`r`n" -ForegroundColor White
}
function Set-TaskbarLocation {
	# Sourced from https://blog.ironmansoftware.com/daily-powershell/windows-11-taskbar-location/
	param(
		[Parameter(Mandatory)]
		[ValidateSet("3", "4", "1", "2")] # Left, Right, Top, Bottom
		$Location
	)
	
	Write-Host "Changing taskbar location" -ForegroundColor White
	
	if (-not (Check-SafeMode)) {Start-ShellSpinner}
	Exit-HikaruShell -Method 0
	$bit = 0;
	switch ($Location) {
		"3" { $bit = 0x00 }
		"4" { $bit = 0x02 }
		"1" { $bit = 0x01 }
		"2" { $bit = 0x03 }
	}
	$Settings = (Get-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3 -Name Settings).Settings
	$Settings[12] = $bit
	Set-ItemProperty HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3 -Name Settings -Value $Settings
	
	Restart-HikaruShell -NoStop -NoSpin
}
function Input-TaskbarLocation {
	while ($true) {
		Show-Branding
		Write-Host "Move your taskbar without disabling lockdown using this option. The Explorer shell will be restarted for changes `r`nto take effect, which will close all of its windows.`r`n" -ForegroundColor White
		Write-Host " Select a taskbar location"
		Write-Host " 1. Top" -ForegroundColor White
		Write-Host " 2. Bottom" -ForegroundColor White -n; Write-Host " (Windows default)"
		Write-Host " 3. Left" -ForegroundColor White
		Write-Host " 4. Right`r`n" -ForegroundColor White
		Write-Host " 0. Cancel`r`n" -ForegroundColor White
		Write-Host "> " -n; $tskbl = Read-Host
		$tskbv = "1","2","3","4"
		if ($tskbl -like "0") {break}
		if (-not [string]::IsNullOrWhiteSpace($tskbl) -and $tskbv.Contains($tskbl)) {
			Write-Host "`r`nConfirm changing taskbar location? (1): " -ForegroundColor White -n; $bruu = Read-Host
			if ($bruu -like "1") {Set-TaskbarLocation -Location $tskbl}
		}
	}
}
function Start-RunDllCpl($param) {
	$ncp = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").NoControlPanel
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoControlPanel -Value 0 -Type DWord
	Start-Process rundll32.exe -ArgumentList "$param"
	Start-Sleep -Seconds 1
	if ($ncp -eq 1) {Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoControlPanel -Value 1 -Type DWord}
}

while ($true) {
	Show-Menu
	Write-Host "> " -n; $unem = Read-Host
	switch ($unem) {
		{$_ -like "0"} {exit}
		{$_ -like "1"} {Confirm-RestartShell}
		{$_ -like "2"} {Input-TaskbarLocation}
		{$_ -like "3"} {& $env:SYSTEMDRIVE\Bionic\Hikaru\SoundWizard.ps1}
		{$_ -like "4"} {Start-RunDllCpl "shell32.dll,Control_RunDLL TimeDate.cpl,,0"}
		{$_ -like "5"} {Start-RunDllCpl "shell32.dll,Control_RunDLL PowerCfg.cpl @0,/editplan:381b4222-f694-41f0-9685-ff5bb260df2e"}
		{$_ -like "("} { # Hikaru beta, correct it back in Final please
			if ($update -eq 1) {
				Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshow.exe
				exit
			} else {
				Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "UpdateCheckerLaunchedFrom" -Value "QM" -Type String -Force
				Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefresh.exe
				exit
			}
		}
	}
}
