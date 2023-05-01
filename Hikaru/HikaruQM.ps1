# BioniDKU Quick Menu (codenamed "HikaruQM") - (c) Bionic Butter

$host.UI.RawUI.WindowTitle = "BioniDKU Quick Menu"
$update = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").UpdateAvailable
$ittt = "Uh oh..."
$imsgt = (Get-ItemProperty -Path "HKCU:\Control Panel\Desktop").PaintDesktopVersion
if ($imsgt -eq 1) {
	$imsg = "If you are seeing this message, the OS might have been improperly shut down or the Quick Menu window was closed while Explorer was restarting. As a result, your desktop's bottom right corner will reveal the build string. Please contact your challenge host to resolve this issue, and until then, do not sign in (or you will regret what you may see)."
} else {
	$imsg = "If you are seeing this message, the OS might have been improperly shut down, or the Quick Menu window was closed while Explorer was restarting. Your system may continue to load properly despite the issue, but it is recommended to contact your challenge host as soon as possible."
}

function Show-Branding {
	Clear-Host
	Write-Host "BioniDKU Quick Menu" -ForegroundColor Black -BackgroundColor White
	Write-Host ' '
}
function Show-Menu {
	Show-Branding
	if ($update -eq 1) {
		Write-Host "9. An update is available, select this option for more information" -ForegroundColor White
		Write-Host " "
	}
	Write-Host "What do you want to do?" -ForegroundColor White
	Write-Host "1. Restart Explorer shell" -ForegroundColor White
	Write-Host "0. Close this menu" -ForegroundColor White
	Write-Host ' '
}
function Set-BootMessage($title, $message) {
	Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name 'legalnoticecaption' -Value $title -Type String -Force
	Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name 'legalnoticetext' -Value $message -Type String -Force
}
function Clear-BootMessage {
	Remove-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name 'legalnoticecaption' -Force -ErrorAction SilentlyContinue
	Remove-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name 'legalnoticetext' -Force -ErrorAction SilentlyContinue
}
function Restart-HikaruShell {
	Write-Host "Now restarting Explorer..." -ForegroundColor White -n; Write-Host " DO NOT POWER OFF YOUR SYSTEM UNTIL THE MAIN MENU APPEARS!" -ForegroundColor White
	$shhk = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon").Shell
	taskkill /f /im explorer.exe
	Set-BootMessage $ittt $imsg
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value 'explorer.exe' -Type String
	Start-Process $env:SYSTEMDRIVE\Windows\explorer.exe
	Start-Sleep -Seconds 5
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value $shhk -Type String
	Clear-BootMessage
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

$menu = $true
while($menu -eq $true) {
	Show-Menu
	Write-Host "Your selection: " -n; $unem = Read-Host
	switch ($unem) {
		{$unem -like "0"} {exit}
		{$unem -like "1"} {
			$menu = Confirm-RestartShell
		}
		{$unem -like "9"} {
			if ($update -eq 1) {
				Start-Process $env:SYSTEMDRIVE\Bionic\Hikarefresh\Hikarefreshow.exe
				exit
			}
		}
	}
}
