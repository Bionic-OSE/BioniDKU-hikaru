# BioniDKU Quick Menu (codenamed "HikaruQM") - (c) Bionic Butter
$host.UI.RawUI.WindowTitle = "BioniDKU Quick Menu"

function Show-Branding {
	Clear-Host
	Write-Host "BioniDKU Quick Menu" -ForegroundColor Black -BackgroundColor White
	Write-Host ' '
}
function Show-Menu {
	Show-Branding
	Write-Host "Hi! If you're wondering where did all the options go, try pressing Ctrl+Alt+Shift+A." -ForegroundColor Magenta
	Write-Host "1. Restart Explorer shell"
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

$menu = $true
while($menu -eq $true) {
	Show-Menu
	Write-Host "Your selection: " -n; $unem = Read-Host
	switch ($unem) {
		{$unem -like "0"} {exit}
		{$unem -like "1"} {
			$menu = Confirm-RestartShell
		}
	}
}