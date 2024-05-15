# BioniDKU Administrative Menu (codenamed "HikaruAM") - (c) Bionic Butter

. $env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestart.ps1
$prodname = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").ProductName
$update = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").UpdateAvailable
$global:staticspinner = $false

Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $env:SYSTEMDRIVE\Bionic\Hikaru\HikaruAMBeep.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"

function Show-Branding {
	$host.UI.RawUI.WindowTitle = "$prodname Administrative Menu"
	Clear-Host
	Write-Host "$prodname Administrative Menu" -ForegroundColor Black -BackgroundColor Magenta
	Write-Host "Version $hikaru - (c) Bionic Butter`r`n" -ForegroundColor White
}
function Show-Menu {
	Show-Branding
	if ($update -eq 1) {
		$updateopt = "9. View update`r`n "
		Write-Host "An update is available, select option 9 for more information`r`nTo recheck for updates, type `"9R`" and press Enter" -ForegroundColor White
	} else {$updateopt = "9. Check for updates`r`n "}
	Write-Host "Becareful with what you are doing!`r`n" -ForegroundColor Magenta
	$lock, $lockclr = Get-SystemSwitches
	$abrs, $abrsclr = Touch-ABRState 0
	Write-Host " Shell tasks"
	Write-Host " 1. Restart Explorer shell" -ForegroundColor White
	switch ($true) {
		{Check-SafeMode} {Write-Host " 2. Shell restart animation is supressed in Safe Mode*`r`n" -ForegroundColor DarkGray}
		$staticspinner {Write-Host " 2. Shell restart animation is supressed, reopen AM to reenable*`r`n" -ForegroundColor DarkGray}
		default {Write-Host " 2. Supress shell restart animation*`r`n" -ForegroundColor White}
	}
	Write-Host " System tasks"
	Write-Host " 3. Toggle Lockdown (currently " -ForegroundColor White -n; Write-Host "$lock" -ForegroundColor $lockclr -n; Write-Host ")"
	Write-Host " 4. Toggle Explorer Address bar (currently " -ForegroundColor White -n; Write-Host "$abrs" -ForegroundColor $abrsclr -n; Write-Host ")"
	Write-Host " 5. Open a Command Prompt window" -ForegroundColor White
	if ($lock -eq "DISABLED") {Write-Host " 6. Configure list of blocked applications`r`n" -ForegroundColor White} else {Write-Host "`r"}
	Write-Host " Others"
	Write-Host " ${updateopt}0. Close this menu`r`n" -ForegroundColor White
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
function Set-ABRValue($value,$switchrunstate) {
	Set-ItemProperty "HKCU:\Software\Hikaru-chan" -Name SystemABRState -Value $value -Type DWord -Force
	if ($switchrunstate -eq 1) {
		switch ($value) {
			default {Stop-Process -Name "AddressBarRemover2" -Force -ErrorAction SilentlyContinue}
			1 {Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\AddressBarRemover2.exe"}
		}
	}
}
function Touch-ABRState {
	param (
		[Parameter(Mandatory=$True,Position=0)]
		[int32]$action
	)
	$abr = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").SystemABRState
	switch ($action) {
		0 {
			switch ($abr) {
				0 {$abst = 'SHOWN'; $aclr = 'Green'}
				default {$abst = 'HIDDEN'; $aclr = 'Red'}
			}
			return $abst, $aclr
		}
		1 {
			$lock = Get-SystemSwitches
			switch ($abr) {
				0 {if ($lock -eq 'DISABLED') {Set-ABRValue 2} else {Set-ABRValue 1 1}}
				1 {Set-ABRValue 0 1}
				2 {Set-ABRValue 0}
			}
		}
	}
}
function Switch-ShellState {
	param (
		[Parameter(Mandatory=$True,Position=0)]
		[int32]$action
	)
	gpupdate.exe
	$action | Out-File -FilePath $env:SYSTEMDRIVE\Bionic\Hikaru\ApplicationControlAction.txt
	Start-Process powershell -WindowStyle Hidden -ArgumentList "Start-ScheduledTask -TaskName 'BioniDKU UWP Lockdown Controller'"
	Write-Host "Sycning changes to the system... This may take up to 20 seconds." -ForegroundColor White
	if ($action -eq 1) {$actchk = $true} else {$actchk = $false}; $acting = $true
	while ($acting) {
		$actvrf = Test-Path -Path "$env:SYSTEMDRIVE\Windows\System32\ApplicationFrameHost.exe"
		if ($actvrf -eq $actchk) {$acting = $false} else {Start-Sleep -Seconds 5; Start-Process powershell -WindowStyle Hidden -ArgumentList "Start-ScheduledTask -TaskName 'BioniDKU UWP Lockdown Controller'"}
	}
	$actabr = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").SystemABRState 
	switch ($action) {
		1 {if ($actabr -eq 1) {Set-ABRValue 2 1}}
		2 {if ($actabr -eq 2) {Set-ABRValue 1 1}}
	}
	Restart-HikaruShell
}
function Switch-Lockdown {
	Show-Branding
	$lock = Get-SystemSwitches
	if ($lock -eq 'ENABLED') {
		Write-Host "This option will disable all application restrictions, unblock Settings, Control Panel, the taskbar context menu, `r`nand unhide the Windows version from Command Prompt. Use this option if you are the challenge host and want to do `r`nmaintenance on this system without having to go through Group Policy and disable the restrictions one by one, or you `r`nare the contestant preparing to reveal this IDKU."
		Write-Host "The Explorer shell will be restarted to apply changes. Your files windows will not be closed.`r`n"
		Write-Host "If the time has not come yet, please " -n; Write-Host "BE CAREFUL with what you are about to do!" -ForegroundColor White
		Write-Host 'ARE SURE YOU WANT TO DISABLE LOCKDOWN? Answer "yes" to disable, or anything else to go back.' -ForegroundColor Yellow
		Write-Host "> " -n; $back = Read-Host
		if ($back -notlike "yes") {return}

		Show-Branding
		Write-Host "Disabling Lockdown and applying changes..." -ForegroundColor White
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name DisallowRun -Value 0 -Type DWord
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoControlPanel -Value 0 -Type DWord
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoTrayContextMenu -Value 0 -Type DWord
		Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Command Processor" -Name Autorun
		Switch-ShellState 1
		Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\AdvancedRun.exe -ArgumentList "/run $env:SYSTEMDRIVE\Bionic\Hikaru\ApplicationFrameHost.cfg"
	} else {
		Write-Host 'Reenable Lockdown? Answer "yes" and Enter to enable, or anything else to go back.'
		Write-Host "The Explorer shell will be restarted to apply changes. Your files windows will not be closed.`r`n"
		Write-Host "> " -n; $back = Read-Host
		if ($back -notlike "yes") {return}
		
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
	$isuacon = (Get-ItemProperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System').EnableLUA
	Write-Host "Use this option to quickly reach the Command Prompt without having to search though Start folders."
	if ($lock -eq 'ENABLED') {
		$syscmd = "/commandline `"/k cls`""
	} else {
		Write-Host "The build number will be " -n; Write-Host "IMMEDIATELY SHOWN" -ForegroundColor Yellow -n; Write-Host " upon launching this program. It is then " -n; Write-Host "YOUR RESPONSIBILTY to keep `r`nthe secrets!" -ForegroundColor Yellow -n; Write-Host " If you can securely proceed:" -ForegroundColor White
		$syscmd = $null
	}
	if ($isuacon -eq 1) {
		Write-Host " - Hit 1 and Enter to open a normal Command Prompt." -ForegroundColor White
		Write-Host " - Hit 2 and Enter to open an elevated Command Prompt." -ForegroundColor White
	} else {
		Write-Host " - Hit 1 and Enter to open a normal Command Prompt." -ForegroundColor White
	}
	Write-Host " - Hit 3 and Enter to open Command Prompt as SYSTEM." -ForegroundColor White
	Write-Host " - Hit anything else and Enter to go back." -ForegroundColor White
	Write-Host ' '
	Write-Host "> " -n; $back = Read-Host
	switch ($back) {
		1 {Start-Process $env:SYSTEMDRIVE\Windows\System32\cmd.exe}
		2 {Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\AdvancedRun.exe -ArgumentList "/run /exefilename %SystemDrive%\Windows\System32\cmd.exe /runas 3"}
		3 {Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\AdvancedRun.exe -ArgumentList "/run /exefilename %SystemDrive%\Windows\System32\cmd.exe $syscmd /runas 4"}
		8 {Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\AdvancedRun.exe -ArgumentList "/run /exefilename %SystemDrive%\Windows\System32\cmd.exe $syscmd /runas 8"}
		default {return}
	}
}
function Start-EditLockedApps {
	Show-Branding
	Start-Process notepad.exe -Wait -ArgumentList "$env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestrict.reg"
	Remove-Item "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\DisallowRun" -Recurse -Force
	reg import "$env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestrict.reg"
}
function Show-StaticSpinnerInfo {
	Show-Branding
	Write-Host "This will temporarily simplify the shell restart animation for this Administrative Menu instance, which can be helpful `r`nif the full animation is slowing down your weak remote connection."
	Write-Host "This will not apply to other opening AM windows unless if you toggle this same option on each of them, and will have no effect on the Quick Menu (except in Safe Mode)."
	Write-Host "In Safe Mode, this option is always enabled for both menus.`r`n"
	Write-Host "Press Enter to go back." -ForegroundColor White; Read-Host
}

while($true) {
	Show-Menu
	Write-Host "> " -n; $unem = Read-Host
	switch ($unem) {
		"0" {exit}
		"1" {Confirm-RestartShell}
		"2" {if (-not (Check-SafeMode)) {$global:staticspinner = $true}}
		"3" {Switch-Lockdown}
		"4" {Touch-ABRState 1}
		"5" {Start-CommandPrompt}
		"6" {
			$lock = Get-SystemSwitches
			if ($lock -eq "DISABLED") {Start-EditLockedApps}
		}
		{$_ -eq '*'} {Show-StaticSpinnerInfo}
		"9" {
			if ($update -eq 1) {
				Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshow.exe
				exit
			} else {
				Start-UpdateCheckerFM "AM"
			}
		}
		"9R" {
			Start-UpdateCheckerFM "AM"
		}
	}
}
