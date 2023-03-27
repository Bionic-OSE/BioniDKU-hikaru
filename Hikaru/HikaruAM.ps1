# BioniDKU Administrative Menu (codenamed "HikaruAM") - (c) Bionic Butter
$host.UI.RawUI.WindowTitle = "BioniDKU Administrative Menu"

function Show-Branding {
	Clear-Host
	Write-Host "BioniDKU Administrative Menu" -ForegroundColor Black -BackgroundColor Magenta
	Write-Host ' '
}
function Get-SystemSwitches {
	$nr = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").DisallowRun
	$ncp = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").NoControlPanel
	$ntcm = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").NoTrayContextMenu
	$nlck = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\SessionData").AllowLockScreen
	if ($nr -eq 1 -and $ncp -eq 1 -and $ntcm -eq 1 -and $nlck -eq 1) {
		$nall = 'ENABLED'
	} elseif ($nr -eq 0 -and $ncp -eq 0 -and $ntcm -eq 0 -and $nlck -eq 0) {
		$nall = 'DISABLED'
	} else {
		$nall = 'UNKNOWN - select this to enable'
	}
	return $nall
}
function Show-Menu {
	Show-Branding
	Write-Host "Becareful with what you are doing!" -ForegroundColor Magenta
	$lock = Get-SystemSwitches
	Write-Host "1. Restart Explorer shell"
	Write-Host "2. Enable/Disable Lockdown (currently " -n; Write-Host "$lock" -ForegroundColor White -n; Write-Host ")"
	Write-Host "3. Open a Command Prompt window"
	if ($lock -eq "DISABLED") {Write-Host "4. Configure list of blocked applications"}
	Write-Host "0. Close this menu"
	Write-Host ' '
}
function Restart-HikaruShell {	
	Write-Host "Now restarting Explorer..." -ForegroundColor White
	$shhk = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon").Shell
	taskkill /f /im explorer.exe
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value 'explorer.exe' -Type String
	Start-Process $env:SYSTEMDRIVE\Windows\explorer.exe
	Start-Sleep -Seconds 5
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value $shhk -Type String
}
function Confirm-RestartShell {
	Show-Branding
	Write-Host "The Windows Explorer shell on a BioniDKU enabled system works a bit differently, and thus restarting by normal means `r`nwill result in an Explorer window opening instead of the shell restarting. Use this option to restart the shell `r`nproperly."
	Write-Host "This option will close all opening Explorer windows. Save your work, then hit 1 and Enter to restart, or hit anything `r`nand Enter to go back."
	Write-Host ' '
	Write-Host "Your answer: " -n; $back = Read-Host
	if ($back -ne 1) {return $true}
	
	Show-Branding
	Restart-HikaruShell
	return $true
}
function Switch-Lockdown {
	Show-Branding
	$lock = Get-SystemSwitches
	if ($lock -eq 'ENABLED') {
		Write-Host "This option will disable all application restrictions, unblock Settings, Control Panel and the taskbar context menu. `r`nUse this option if you are the challenge host and want to do maintenance on this system without having to go through `r`nGroup Policy and disable the restrictions one by one."
		Write-Host "Disabling Lockdown means " -n; Write-Host "the RESPONSIBILTY of keeping the secrets will be YOURS " -ForegroundColor White -n; Write-Host "until you enable them again. If you `r`ncan securely proceed, hit 1 and Enter to disable, or hit anything and Enter to go back."
		Write-Host "Proceeding will also restart Explorer, which closes all opening Explorer windows."
		Write-Host ' '
		Write-Host "Your answer: " -n; $back = Read-Host
		if ($back -ne 1) {return $true}
		
		Show-Branding
		Write-Host "Disabling Lockdown and applying changes..." -ForegroundColor White
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name DisallowRun -Value 0 -Type DWord
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoControlPanel -Value 0 -Type DWord
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoTrayContextMenu -Value 0 -Type DWord
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\SessionData" -Name AllowLockScreen -Value 0 -Type DWord
		gpupdate.exe
		Copy-Item "$env:SYSTEMDRIVE\Bionic\Hikaru\ApplicationFrameHost.exe" -Destination "$env:SYSTEMDRIVE\Windows\System32"
		Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\AdvancedRun.exe -ArgumentList "/run $env:SYSTEMDRIVE\Bionic\Hikaru\ApplicationFrameHost.cfg"
		Restart-HikaruShell
		return $true
	} else {
		Write-Host "Reenable Lockdown? Hit 1 and Enter to enable, or hit anything and Enter to go back."
		Write-Host "Proceeding will also restart Explorer, which closes all opening Explorer windows."
		Write-Host ' '
		Write-Host "Your answer: " -n; $back = Read-Host
		if ($back -ne 1) {return $true}
		
		Show-Branding
		Write-Host "Enabling Lockdown and applying changes..." -ForegroundColor White
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name DisallowRun -Value 1 -Type DWord
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoControlPanel -Value 1 -Type DWord
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name NoTrayContextMenu -Value 1 -Type DWord
		Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\SessionData" -Name AllowLockScreen -Value 1 -Type DWord
		gpupdate.exe
		taskkill /f /im ApplicationFrameHost.exe
		takeown /f "$env:SYSTEMDRIVE\Windows\System32\ApplicationFrameHost.exe"
		icacls "$env:SYSTEMDRIVE\Windows\System32\ApplicationFrameHost.exe" /grant Administrators:F
		Remove-Item "$env:SYSTEMDRIVE\Windows\System32\ApplicationFrameHost.exe"
		Restart-HikaruShell
		return $true
	}
}
function Start-CommandPrompt {
	Show-Branding
	Write-Host "Use this option if you want to quickly reach the Command Prompt without having to search though Start folders."
	Write-Host "The build number will be " -n; Write-Host "IMMEDIATELY SHOWN" -ForegroundColor White -n; Write-Host " upon launching CMD. It is then " -n; Write-Host "YOUR RESPONSIBILTY to keep the secrets!" -ForegroundColor White; Write-Host "If you can securely proceed, hit 1 and Enter to open, or hit anything and Enter to go back."
	Write-Host ' '
	Write-Host "Your answer: " -n; $back = Read-Host
	if ($back -ne 1) {return $true}
	
	Start-Process $env:SYSTEMDRIVE\Windows\System32\cmd.exe
	return $true
}

$menu = $true
while($menu -eq $true) {
	Show-Menu
	Write-Host "Your selection: " -n; $unem = Read-Host
	switch ($unem) {
		{$unem -like "0"} {exit}
		{$unem -like "1"} {
			$menu = Confirm-RestartShell
		}
		{$unem -like "2"} {
			$menu = Switch-Lockdown
		}
		{$unem -like "3"} {
			$menu = Start-CommandPrompt
		}
		{$unem -like "4"} {
			$lock = Get-SystemSwitches
			if ($lock -eq "DISABLED") {
				Show-Branding
				Write-Host "This feature is currently in development. Press Enter to return to the menu."
				Read-Host
			}
		}
	}
}
