# BioniDKU Quick/Administrative Menu Explorer restarting functions loader

function Set-BootMessage {
	Set-ItemProperty "HKLM:\SYSTEM\Setup" -Name CmdLine -Value "cmd.exe /c C:\Bionic\Hikaru\Hikarepair.bat" -Type String -Force
	Set-ItemProperty "HKLM:\SYSTEM\Setup" -Name SystemSetupInProgress -Value 1 -Type DWord -Force
	Set-ItemProperty "HKLM:\SYSTEM\Setup" -Name SetupType -Value 2 -Type DWord -Force
}
function Clear-BootMessage {
	Set-ItemProperty "HKLM:\SYSTEM\Setup" -Name CmdLine -Value "" -Type String -Force
	Set-ItemProperty "HKLM:\SYSTEM\Setup" -Name SystemSetupInProgress -Value 0 -Type DWord -Force
	Set-ItemProperty "HKLM:\SYSTEM\Setup" -Name SetupType -Value 0 -Type DWord -Force
}
function Restart-HikaruShell {
	Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe -WindowStyle Hidden -ArgumentList "-i $env:SYSTEMDRIVE\Bionic\Hikaru\ShellSpinner.mp4 -fs -alwaysontop -noborder -autoexit"
	Start-Sleep -Seconds 2
	Write-Host "Now restarting Explorer..." -ForegroundColor White -n; Write-Host " DO NOT POWER OFF YOUR SYSTEM UNTIL THE MAIN MENU APPEARS!" -ForegroundColor White
	$shhk = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon").Shell
	taskkill /f /im explorer.exe
	Set-BootMessage $ittt $imsg
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value 'explorer.exe' -Type String
	Start-Process $env:SYSTEMDRIVE\Windows\explorer.exe
	Start-Sleep -Seconds 3
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
