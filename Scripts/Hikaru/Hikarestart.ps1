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
	$build = [System.Environment]::OSVersion.Version | Select-Object -ExpandProperty "Build"
	if ($build -le 10586) {$hkrbuildkey = "CurrentBuildNumber"} else {$hkrbuildkey = "BuildLab"}
	while ($true) {
		$hkrbchkvar = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").$hkrbuildkey
		if ($hkrbchkvar -eq "?????.????_release.??????-????") {break}
	}
	$eid = Start-Process $env:SYSTEMROOT\explorer.exe -PassThru
	Start-Sleep -Seconds 2
	Set-ItemProperty "HKCU:\Software\Hikaru-chan" -Name ShellID -Value $eid.Id -Type String -Force
}
function Confirm-RestartShell {
	Show-Branding
	Write-Host "The Windows Explorer shell on a $prodname system works a bit differently. Use this option to restart the shell properly."
	Write-Host " - To gracefully restart the shell, hit 1 and Enter. This will not close your Explorer windows." -ForegroundColor White
	Write-Host " - To forcefully restart the shell, hit 8 and Enter. This, again, won't close your windows." -ForegroundColor White
	Write-Host " - To forcefully restart Explorer as a whole, hit 9 and Enter. This WILL CLOSE all Explorer windows." -ForegroundColor White
	Write-Host " - To go back to the main menu, hit anything else and Enter." -ForegroundColor White
	Write-Host "Forcefully restarting may cause your desktop layout to reset. Please be careful.`r`n"
	Write-Host "> " -n; $back = Read-Host
	
	switch ($back) {
		{$_ -like "1"} {Show-Branding; Restart-HikaruShell -Method 0}
		{$_ -like "8"} {Show-Branding; Restart-HikaruShell -Method 1}
		{$_ -like "9"} {Show-Branding; Restart-HikaruShell -Method 2}
	}
}
