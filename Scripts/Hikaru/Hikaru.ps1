# Hikaru-chan 3.2 - (c) Bionic Butter

. $env:SYSTEMDRIVE\Bionic\Hikaru\Hikarestart.ps1
$m = (Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize").AppsUseLightTheme
$hko = Start-Process $env:SYSTEMDRIVE\Windows\System32\scrnsave.scr -PassThru; $hkn = $hko.Id
Start-Sleep -Milliseconds 36
Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\PSSuspend64.exe" -WindowStyle Hidden -ArgumentList "$hkn /accepteula /nobanner"
Start-Sleep -Milliseconds 36
$hks = Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe" -WindowStyle Hidden -PassThru -ArgumentList "-i $env:SYSTEMDRIVE\Bionic\Hikaru\StartupSpinner.mp4 -fs -alwaysontop -noborder -loop 0"; $hkf = $hks.Id
Start-Sleep -Milliseconds 256
$sm = Check-SafeMode
switch ($sm) {
	$false {
		$ssv = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").StartupSoundVariant
		$abr = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").SystemABRState

		if ($abr -eq 1) {Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\AddressBarRemover2.exe"}
		Restart-HikaruShell -NoStop -NoSpin -HKBoot

		taskkill /f /pid $hkn
		taskkill /f /pid $hkf
		Start-Sleep -Milliseconds 128
		Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $env:SYSTEMDRIVE\Bionic\Hikaru\StartupSound${ssv}.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"
		Start-Sleep -Seconds 1
	}
	$true {
		taskkill /f /pid $hkn
		taskkill /f /pid $hkf
		Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\HikaruSM.exe"
	}
}
