# BioniDKU Quick/Administrative Menu Explorer restarting functions hive

function Start-ShellSpinner {
	$global:SuwakoSpinner = Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe -WindowStyle Hidden -ArgumentList "-i $env:SYSTEMDRIVE\Bionic\Hikaru\ShellSpinner.mp4 -fs -alwaysontop -noborder -autoexit" -PassThru
	Start-Sleep -Seconds 1
}
function Exit-HikaruShell($type) {
	$sid = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").ShellID
	switch ($type) {
		default {Start-Process $env:SYSTEMDRIVE\Bionic\Hikaru\ExitExplorer.exe -WindowStyle Hidden; Wait-Process -Id $sid}
		1 {taskkill /f /pid $sid}
		2 {taskkill /f /im explorer.exe}
	}
}
function Restart-HikaruShell {
	[CmdletBinding()]
	param (
		[string]$Method,
		[switch]$NoStop,
		[switch]$NoSpin
	)
	if (-not $NoSpin) {Start-ShellSpinner}
	if (-not $NoStop) {Write-Host "Now restarting Explorer..." -ForegroundColor White; Exit-HikaruShell $Method}
	
	Start-ScheduledTask -TaskName 'BioniDKU Windows Build String Modifier'
	$eid = Start-Process $env:SYSTEMROOT\explorer.exe -PassThru
	Start-Sleep -Seconds 2
	Set-ItemProperty "HKCU:\Software\Hikaru-chan" -Name ShellID -Value $eid.Id -Type String -Force
}
function Confirm-RestartShell {
	Show-Branding
	Write-Host "The Windows Explorer shell on a $prodname system works a bit differently, and thus restarting by normal means `r`nwill result in an Explorer window opening instead of the shell restarting. Use this option to restart the shell `r`nproperly."
	Write-Host "This option will close all opening Explorer windows. Save your work, then hit 1 and Enter to restart, or hit anything `r`nand Enter to go back." -ForegroundColor White
	Write-Host ' '
	Write-Host "> " -n; $back = Read-Host
	
	switch ($back) {
		{$_ -like "1"} {Show-Branding; Restart-HikaruShell -Method 0}
		{$_ -like "8"} {Show-Branding; Restart-HikaruShell -Method 1}
		{$_ -like "9"} {Show-Branding; Restart-HikaruShell -Method 2}
	}
}
