# BioniDKU Safe Mode Menu (codenamed "HikaruSM") - (c) Bionic Butter

$prodname = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").ProductName
$sm = (gwmi win32_computersystem -Property BootupState).BootupState
switch ($sm) {
	"Normal boot" {exit}
	"Fail-safe boot" {$smname = "Safe Mode"}
	"Fail-safe with network boot" {$smname = "Safe Mode with Networking"}
}
. $env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestart.ps1

function Show-Branding {
	$host.UI.RawUI.WindowTitle = "$prodname Safe Mode Menu"
	Clear-Host
	Write-Host "$prodname Safe Mode Menu" -ForegroundColor Black -BackgroundColor White
	Write-Host "Your device is currently in $smname`r`n" -ForegroundColor White
}
function Show-Menu {
	Show-Branding
	Write-Host " Select an action"
	Write-Host " 1. Start Explorer shell (and close this menu)" -ForegroundColor White
	Write-Host " 2. Exit Safe Mode and restart`r`n" -ForegroundColor White
	Write-Host " Or quickly access some troubleshooting tools"
	Write-Host " 3. Open Device Manager" -ForegroundColor White
	Write-Host " 4. Open Disk Management`r`n" -ForegroundColor White
}
function Restart-OutOfSM {
	Write-Host "Press 1 and Enter to exit Safe Mode and restart." -ForegroundColor White
	Write-Host "> " -n; $re = Read-Host
	
	if ($re -like "1") {shutdown -r -t 0}
}

while ($true) {
	Show-Menu
	Write-Host "> " -n; $unem = Read-Host
	switch ($unem) {
		{$_ -like "1"} {Show-Branding; Restart-HikaruShell -NoStop -NoSpin; exit}
		{$_ -like "2"} {Restart-OutOfSM}
		{$_ -like "3"} {Start-Process devmgmt.msc}
		{$_ -like "4"} {Start-Process diskmgmt.msc}
	}
}
