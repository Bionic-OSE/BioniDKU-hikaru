# BioniDKU/YuumeiDKU Quick Menu (codenamed "HikaruQM") - (c) Bionic Butter

$prodname = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").ProductName
$update = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").UpdateAvailable
$host.UI.RawUI.WindowTitle = "$prodname Quick Menu"
. $env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestart.ps1

function Show-Branding {
	Clear-Host
	Write-Host "$prodname Quick Menu" -ForegroundColor Black -BackgroundColor White
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
