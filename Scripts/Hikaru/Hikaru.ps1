# Hikaru-chan 3.0 - (c) Bionic Butter

. $env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestart.ps1
$sm = Check-SafeMode
switch ($sm) {
	$false {
		$ssv = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").StartupSoundVariant
		$abr = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").SystemABRState

		if ($abr -eq 1) {Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\AddressBarRemover2.exe"}
		Restart-HikaruShell -NoStop -NoSpin -HKBoot

		taskkill /f /im FFPlay.exe
		Start-Sleep -Seconds 1
		Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\HikaruQML.exe"
		Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $env:SYSTEMDRIVE\Bionic\Hikaru\StartupSound${ssv}.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"
	}
	$true {
		taskkill /f /im FFPlay.exe
		Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\HikaruSM.exe"
	}
}
