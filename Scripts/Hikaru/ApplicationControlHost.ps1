$action = Get-Content -Path $env:SYSTEMDRIVE\Bionic\Hikaru\ApplicationControlAction.txt

switch ([int32]$action) {
	1 {
		Copy-Item "$env:SYSTEMDRIVE\Bionic\Hikaru\wwahost.QUARANTINE" -Destination "$env:SYSTEMDRIVE\Windows\System32\wwahost.exe"
		Copy-Item "$env:SYSTEMDRIVE\Bionic\Hikaru\ApplicationFrameHost.QUARANTINE" -Destination "$env:SYSTEMDRIVE\Windows\System32\ApplicationFrameHost.exe"
	}
	2 {
		taskkill /f /im wwahost.exe
		Remove-Item "$env:SYSTEMDRIVE\Windows\System32\wwahost.exe"
		taskkill /f /im ApplicationFrameHost.exe
		Remove-Item "$env:SYSTEMDRIVE\Windows\System32\ApplicationFrameHost.exe"
	}
}
