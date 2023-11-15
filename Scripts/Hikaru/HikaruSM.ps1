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
	Write-Host " 1. Start Explorer shell" -ForegroundColor White -n; Write-Host " (and close this menu)"
	Write-Host " 2. Restart device`r`n" -ForegroundColor White
	Write-Host " Or quickly access some troubleshooting tools"
	Write-Host " 3. Open Command Prompt" -ForegroundColor White -n; Write-Host " (build info will be hidden)"
	Write-Host " 4. Open Device Manager" -ForegroundColor White
	Write-Host " 5. Open Disk Management`r`n" -ForegroundColor White
}
function Restart-OutOfSM {
	Show-Branding
	Write-Host "Press 1 and Enter to restart your device." -ForegroundColor White
	Write-Host " - If you have entered Safe Mode (SM) via Startup Options, the device will restart to Normal Mode."
	Write-Host " - If you entered using MSCONFIG or BCDEDIT however, you will have to uncheck/remove the SM boot flag`r`n   before you can boot back to Normal Mode. For the BCD method you can run `r`n   `"bcdedit /deletevalue {current} safeboot`" in an Elevated Command Prompt to do that.`r`n"
	Write-Host "> " -n; $re = Read-Host
	
	if ($re -like "1") {shutdown -r -t 0}
}

while ($true) {
	Show-Menu
	Write-Host "> " -n; $unem = Read-Host
	switch ($unem) {
		{$_ -like "1"} {
			Show-Branding
			Write-Host "NOTE:" -ForegroundColor White -n; Write-Host "  The BioniDKU Menu Tray icon will not appear, but the key combo will still work."
			Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\HikaruQML.exe"
			Start-Process "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\AddressBarRemover2.exe"
			Restart-HikaruShell -NoStop -NoSpin -HKBoot
			exit
		}
		{$_ -like "2"} {Restart-OutOfSM}
		{$_ -like "3"} {Start-Process cmd.exe -ArgumentList "/k cls"}
		{$_ -like "4"} {Start-Process devmgmt.msc}
		{$_ -like "5"} {Start-Process diskmgmt.msc}
	}
}
