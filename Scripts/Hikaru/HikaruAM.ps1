# BioniDKU Administrative Menu (codenamed "HikaruAM") - (c) Bionic Butter

$prodname = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").ProductName
$update = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").UpdateAvailable
. $env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestart.ps1

Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $env:SYSTEMDRIVE\Bionic\Hikaru\HikaruQMBeep.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"

function Show-Branding {
	$host.UI.RawUI.WindowTitle = "$prodname Administrative Menu"
	Clear-Host
	Write-Host "$prodname Administrative Menu" -ForegroundColor Black -BackgroundColor Magenta
	Write-Host ' '
}
function Get-SystemSwitches {
	$nr = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").DisallowRun
	$ncp = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").NoControlPanel
	$ntcm = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").NoTrayContextMenu
	if ($nr -eq 1 -and $ncp -eq 1 -and $ntcm -eq 1) {
		$nall = 'ENABLED'
		$nclr = 'Green'
	} elseif ($nr -eq 0 -and $ncp -eq 0 -and $ntcm -eq 0) {
		$nall = 'DISABLED'
		$nclr = 'Red'
	} else {
		$nall = 'UNKNOWN - select this to enable'
		$nclr = 'Yellow'
	}
	return $nall, $nclr
}
function Show-Menu {
	Show-Branding
	if ($update -eq 1) {
		$updateopt = "9. View update`r`n "
		Write-Host "An update is available, select option 9 for more information`r`n" -ForegroundColor White
	} else {$updateopt = "9. Check for updates`r`n "}
	Write-Host "Becareful with what you are doing!`r`n" -ForegroundColor Magenta
	$lock, $lockclr = Get-SystemSwitches
	Write-Host " Shell tasks"
	Write-Host " 1. Restart Explorer shell`r`n" -ForegroundColor White
	Write-Host " System tasks"
	Write-Host " 2. Enable/Disable Lockdown (currently " -ForegroundColor White -n; Write-Host "$lock" -ForegroundColor $lockclr -n; Write-Host ")"
	Write-Host " 3. Open a Command Prompt window" -ForegroundColor White
	if ($lock -eq "DISABLED") {Write-Host " 4. Configure list of blocked applications`r`n" -ForegroundColor White} else {Write-Host "`r"}
	Write-Host " Others"
	Write-Host " ${updateopt}0. Close this menu`r`n" -ForegroundColor White
}
function Switch-ShellState($action) {
	gpupdate.exe
	$action | Out-File -FilePath $env:SYSTEMDRIVE\Bionic\Hikaru\ApplicationControlAction.txt
	Start-ScheduledTask -TaskName 'BioniDKU UWP Lockdown Controller'
	if ($action -eq 1) {$actchk = $true} else {$actchk = $false}; $acting = $true
	while ($acting) {
		$actvrf = Test-Path -Path "$env:SYSTEMDRIVE\Windows\System32\ApplicationFrameHost.exe"
		if ($actvrf -eq $actchk) {$acting = $false} else {Start-Sleep -Seconds 1; Start-ScheduledTask -TaskName 'BioniDKU UWP Lockdown Controller'}
	}
	Restart-HikaruShell
}
function Switch-Lockdown {
	Show-Branding
	$lock = Get-SystemSwitches
	if ($lock -eq 'ENABLED') {
		Write-Host "This option will disable all application restrictions, unblock Settings, Control Panel, the taskbar context menu, `r`nand unhide the Windows version from Command Prompt. Use this option if you are the challenge host and want to do `r`nmaintenance on this system without having to go through Group Policy and disable the restrictions one by one."
		Write-Host "Disabling Lockdown means " -n; Write-Host "the RESPONSIBILTY of keeping the secrets will be YOURS " -ForegroundColor White -n; Write-Host "until you enable them again. If you `r`ncan securely proceed, hit 1 and Enter to disable, or hit anything and Enter to go back."
		Write-Host "Proceeding will also restart Explorer, which closes all opening Explorer windows.`r`n"
		Write-Host "> " -n; $back = Read-Host
		if ($back -ne 1) {return}

		Show-Branding
		Write-Host "Disabling Lockdown and applying changes..." -ForegroundColor White
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name DisallowRun -Value 0 -Type DWord
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoControlPanel -Value 0 -Type DWord
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoTrayContextMenu -Value 0 -Type DWord
		Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Command Processor" -Name Autorun
		Switch-ShellState 1
		Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\AdvancedRun.exe -ArgumentList "/run $env:SYSTEMDRIVE\Bionic\Hikaru\ApplicationFrameHost.cfg"
	} else {
		Write-Host "Reenable Lockdown? Hit 1 and Enter to enable, or hit anything and Enter to go back."
		Write-Host "Proceeding will also restart Explorer, which closes all opening Explorer windows.`r`n"
		Write-Host "> " -n; $back = Read-Host
		if ($back -ne 1) {return}
		
		Show-Branding
		Write-Host "Enabling Lockdown and applying changes..." -ForegroundColor White
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name DisallowRun -Value 1 -Type DWord
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoControlPanel -Value 1 -Type DWord
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoTrayContextMenu -Value 1 -Type DWord
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Command Processor" -Name Autorun -Value "cls" -Type String
		Switch-ShellState 2
	}
}
function Start-CommandPrompt {
	Show-Branding
	$lock = Get-SystemSwitches
	Write-Host "Use this option to quickly reach the Command Prompt without having to search though Start folders."
	if ($lock -eq 'ENABLED') {
		Write-Host "Hit 1 and Enter to open, or hit anything and Enter to go back."
	} else {
		Write-Host "The build number will be " -n; Write-Host "IMMEDIATELY SHOWN" -ForegroundColor White -n; Write-Host " upon launching this program. It is then " -n; Write-Host "YOUR RESPONSIBILTY to keep the secrets!" -ForegroundColor White; Write-Host "If you can securely proceed, hit 1 and Enter to open, or hit anything and Enter to go back."
	}
	Write-Host ' '
	Write-Host "> " -n; $back = Read-Host
	if ($back -ne 1) {return}
	
	Start-Process $env:SYSTEMDRIVE\Windows\System32\cmd.exe
}
function Start-EditLockedApps {
	Show-Branding
	Start-Process notepad.exe -Wait -ArgumentList "$env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestrict.reg"
	reg import "$env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestrict.reg"
}

while($true) {
	Show-Menu
	Write-Host "> " -n; $unem = Read-Host
	switch ($unem) {
		{$_ -like "0"} {exit}
		{$_ -like "1"} {Confirm-RestartShell}
		{$_ -like "2"} {Switch-Lockdown}
		{$_ -like "3"} {Start-CommandPrompt}
		{$_ -like "4"} {
			$lock = Get-SystemSwitches
			if ($lock -eq "DISABLED") {Start-EditLockedApps}
		}
		{$_ -like "9"} {
			if ($update -eq 1) {
				Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshow.exe
				exit
			} else {
				Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "UpdateCheckerLaunchedFrom" -Value "AM" -Type String -Force
				Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefresh.exe
				exit
			}
		}
	}
}
