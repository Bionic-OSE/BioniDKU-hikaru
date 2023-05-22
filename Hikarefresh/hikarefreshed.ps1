# Hikaru-chan post-update script - (c) Bionic Butter
# This file contains commands that will be run after you update from an older release to the current release, and will be changed for be empty depending on each releases

$cmd = Test-Path -Path "HKCU:\Software\Microsoft\Command Processor"
if ($cmd -eq $false) {
	New-Item -Path "HKCU:\Software\Microsoft" -Name "Command Processor"
}
$nr = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").DisallowRun
$ncp = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").NoControlPanel
$ntcm = (Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer").NoTrayContextMenu
if ($nr -eq 1 -and $ncp -eq 1 -and $ntcm -eq 1) {
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Command Processor" -Name Autorun -Value "cls" -Type String
}
