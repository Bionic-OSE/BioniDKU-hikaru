$az = [char[]]('a'[0]..'z'[0])
function Show-StateColor($variant) {
	$varireg = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").StartupSoundVariant
	if ($variant -eq $varireg) {$varicfg = "Black"; $varicbg = "White"} else {$varicfg = "White"; $varicbg = "Black"}
	return $varicfg, $varicbg
}
function Start-PlaySound($variant) {
		Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $env:SYSTEMDRIVE\Bionic\Hikaru\StartupSound${variant}.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"
}
function Show-IPrompt($maxvars) {
	while ($true) {
		Show-Branding
		Write-Host "Choose your desired sign-in sound:" -ForegroundColor White
		Write-Host "Select a sound by typing its number, and play that sound by typing the letter next to that number."
		Write-Host "Type '0' to go back.`r`n"
		for ($v = 1; $v -le $maxvars; $v++) {
			$l = $az[$v-1]; $vfg, $vbg = Show-StateColor $v
			Write-Host "    " -n; Write-Host "$v.$l"  -ForegroundColor $vfg -BackgroundColor $vbg -n
		}
		Write-Host "`r`n"
		Write-Host "> " -n; $inp = Read-Host
		if (-not [string]::IsNullOrWhiteSpace($inp)) {
			if ($inp -like "0") {break}

			$inpvld = (1..$maxvars); $inpint = -1
			$inpcnv = [System.Int32]::TryParse($inp,[ref]$inpint)
			switch ($true) {
				{$inpint.GetType().Name -like "Int32" -and $inpvld.Contains($inpint)} {
					Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "StartupSoundVariant" -Value $inpint -Type DWord -Force
				}
				{$az.Contains([char]$inp)} {
					$inpidx = $az.IndexOf([char]$inp)+1
					Start-PlaySound $inpidx
				}
			}
		}
	}
}

Show-IPrompt 3
