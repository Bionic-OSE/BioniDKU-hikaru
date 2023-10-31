Param(
	[Parameter(Mandatory=$true,Position=0)]
	[int32]$action
)

function Show-StateColor($type,$variant) {
	$varireg = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan")."${type}SoundVariant"
	if ($variant -eq $varireg) {$varicfg = "Black"; $varicbg = "White"} else {$varicfg = "White"; $varicbg = "Black"}
	return $varicfg, $varicbg
}
function Start-PlaySound($type,$variant) {
	Start-Process "$env:SYSTEMDRIVE\Bionic\Hikaru\FFPlay.exe" -WindowStyle Hidden -ArgumentList "-i $env:SYSTEMDRIVE\Bionic\Hikaru\${type}Sound${variant}.mp3 -nodisp -hide_banner -autoexit -loglevel quiet"
}
function Set-SystemSound($variantno) {
	switch ($variantno) {
		1 {$variant = "9200"}
		2 {$variant = "1k74"}
	}
	Write-Host "Changing sounds..." -ForegroundColor White
	while ($true) {
		Start-Sleep -Seconds 1
		$testmedia = (Test-Path -Path "$env:SYSTEMDRIVE\Windows\Media\*")
		if ($testmedia) {Remove-Item -Path $env:SYSTEMDRIVE\Windows\Media\* -Force -Recurse -ErrorAction SilentlyContinue} else {break}
	}
	Start-Process 7za -Wait -WindowStyle Hidden -ArgumentList "x $env:SYSTEMDRIVE\Windows\Media${variant}.zip -o$env:SYSTEMDRIVE\Windows\Media -aoa"
}
function Show-IPrompt($typeno,$maxvars,$typedisp) {
	switch ($typeno) {
		1 {$type = "Startup"}
		2 {$type = "System"}
	}
	while ($true) {
		Show-Branding
		Write-Host "Choose your desired ${typedisp}:" -ForegroundColor White
		Write-Host "Select a variant by typing its number, and preview that variant by typing the letter next to that number."
		Write-Host "Type '0' to go back.`r`n"
		for ($v = 1; $v -le $maxvars; $v++) {
			$l = $az[$v-1]; $vfg, $vbg = Show-StateColor $type $v
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
					if ($typeno -eq 2) {Set-SystemSound $inpint}
					Set-ItemProperty -Path "HKCU:\Software\Hikaru-chan" -Name "${type}SoundVariant" -Value $inpint -Type DWord -Force
				}
				{$az.Contains([char]$inp)} {
					$inpidx = $az.IndexOf([char]$inp)+1
					Start-PlaySound $type $inpidx
				}
			}
		}
	}
}

$az = [char[]]('a'[0]..'z'[0])
switch ($action) {
	1 {$actioname = "sign-in sound"; $actionmax = 3}
	2 {$actioname = "system sounds pack"; $actionmax = 2}
}

Show-IPrompt $action $actionmax $actioname
