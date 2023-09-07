# BioniDKU Quick/Administrative Menu Explorer restarting functions hive

$shhk = "$env:SYSTEMDRIVE\Bionic\Hikaru\AdvancedRun.exe /run $env:SYSTEMDRIVE\Bionic\Hikaru\Hikaru.cfg"

function Start-ShellSpinner {
	$global:SuwakoSpinner = Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe -WindowStyle Hidden -ArgumentList "-i $env:SYSTEMDRIVE\Bionic\Hikaru\ShellSpinner.mp4 -fs -alwaysontop -noborder" -PassThru
	Start-Sleep -Seconds 1
}
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
function Exit-HikaruShell {
	# Using taskkill for now. Work on an improved mechanism is coming soon!
	taskkill /f /im explorer.exe
}
function Restart-HikaruShell {
	param (
		#[switch]$Force,
		[switch]$NoStop,
		[switch]$NoSpin
	)
	if (-not $NoSpin) {Start-ShellSpinner}
	Write-Host "Now restarting Explorer..." -ForegroundColor White -n; Write-Host " DO NOT POWER OFF YOUR SYSTEM OR CLOSE THIS WINDOW!" -ForegroundColor White
	if (-not $NoStop) {Exit-HikaruShell}
	Set-BootMessage
	Start-Sleep -Seconds 2
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value 'explorer.exe' -Type String
	Start-Process $env:SYSTEMDRIVE\Windows\explorer.exe
	Start-Sleep -Seconds 4
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "Shell" -Value $shhk -Type String
	Clear-BootMessage
	if (-not $NoSpin) {Stop-Process $SuwakoSpinner.Id}
}
function Confirm-RestartShell {
	Show-Branding
	Write-Host "The Windows Explorer shell on a $prodname system works a bit differently, and thus restarting by normal means `r`nwill result in an Explorer window opening instead of the shell restarting. Use this option to restart the shell `r`nproperly."
	Write-Host "This option will close all opening Explorer windows. Save your work, then hit 1 and Enter to restart, or hit anything `r`nand Enter to go back." -ForegroundColor White
	Write-Host ' '
	Write-Host "> " -n; $back = Read-Host
	if ($back -eq 1) {
		Show-Branding
		Restart-HikaruShell
	}
}
