# BioniDKU Administrative Menu (codenamed "HikaruAM") - (c) Bionic Butter

$host.UI.RawUI.WindowTitle = "BioniDKU Administrative Menu"
$update = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").UpdateAvailable
. $env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestart.ps1

function Show-Branding {
	Clear-Host
	Write-Host "BioniDKU Administrative Menu" -ForegroundColor Black -BackgroundColor Magenta
	Write-Host ' '
}
function Get-SystemSwitches {
	$nr = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").DisallowRun
	$ncp = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").NoControlPanel
	$ntcm = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").NoTrayContextMenu
	if ($nr -eq 1 -and $ncp -eq 1 -and $ntcm -eq 1) {
		$nall = 'ENABLED'
	} elseif ($nr -eq 0 -and $ncp -eq 0 -and $ntcm -eq 0) {
		$nall = 'DISABLED'
	} else {
		$nall = 'UNKNOWN - select this to enable'
	}
	return $nall
}
function Show-Menu {
	Show-Branding
	if ($update -eq 1) {
		Write-Host "9. An update is available, select this option for more information" -ForegroundColor Yellow
		Write-Host " "
	}
	Write-Host "Becareful with what you are doing!" -ForegroundColor Magenta
	$lock = Get-SystemSwitches
	Write-Host "1. Restart Explorer shell" -ForegroundColor White
	Write-Host "2. Enable/Disable Lockdown (currently " -ForegroundColor White -n; Write-Host "$lock" -ForegroundColor Cyan -n; Write-Host ")"
	Write-Host "3. Open a Command Prompt window" -ForegroundColor White
	if ($lock -eq "DISABLED") {Write-Host "4. Configure list of blocked applications" -ForegroundColor White}
	Write-Host "0. Close this menu" -ForegroundColor White
	Write-Host ' '
}
function Switch-Lockdown {
	Show-Branding
	$lock = Get-SystemSwitches
	if ($lock -eq 'ENABLED') {
		Write-Host "This option will disable all application restrictions, unblock Settings, Control Panel, the taskbar context menu, `r`nand unhide the Windows version from Command Prompt. Use this option if you are the challenge host and want to do `r`nmaintenance on this system without having to go through Group Policy and disable the restrictions one by one."
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
		Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Command Processor" -Name Autorun
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
		Set-ItemProperty -Path "HKCU:\Software\Microsoft\Command Processor" -Name Autorun -Value "cls" -Type String
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
	$lock = Get-SystemSwitches
	Write-Host "Use this option to quickly reach the Command Prompt without having to search though Start folders."
	if ($lock -eq 'ENABLED') {
		Write-Host "Hit 1 and Enter to open, or hit anything and Enter to go back."
	} else {
		Write-Host "The build number will be " -n; Write-Host "IMMEDIATELY SHOWN" -ForegroundColor White -n; Write-Host " upon launching this program. It is then " -n; Write-Host "YOUR RESPONSIBILTY to keep the secrets!" -ForegroundColor White; Write-Host "If you can securely proceed, hit 1 and Enter to open, or hit anything and Enter to go back."
	}
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
		{$unem -like "9"} {
			if ($update -eq 1) {
				Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshow.exe
				exit
			}
		}
	}
}
