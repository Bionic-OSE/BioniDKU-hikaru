# BioniDKU Windows Build String Modifier - (c) Bionic Butter
# This app is a direct fork of SuwakoFeeds in terms of structure

$build = [System.Environment]::OSVersion.Version | Select-Object -ExpandProperty "Build"
if ($build -le 10586) {$hkrbuildkey = "CurrentBuildNumber"} else {$hkrbuildkey = "BuildLab"}

function Start-BuildStringMod {
	$hkrbuildose = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").BuildLabOSE
	if ($hkrbuildose -eq $null) {Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "BuildLabOSE" -Value "1????.????_release.??????-????" -Type String -Force}
	Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name $hkrbuildkey -Value $hkrbuildose -Type String -Force
}
function Get-Explorer {
	$sid = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").ShellID
	$sehost = Get-Process -Id $sid -ErrorAction SilentlyContinue
	if ($sehost) {return $true} else {return $false}
}
function Wait-Explorer {
	$sid = (Get-ItemProperty -Path "HKCU:\Software\Hikaru-chan").ShellID
	Wait-Process -Id $sid
}

while ($true) {
	while ($sadied -le 60) {
		Start-BuildStringMod
		if ((Get-Explorer)) {
			$sedied = 0
			break
		}
		Start-Sleep -Seconds 1
		$sedied++
	}
	while ($sadied -gt 60) {
		Start-BuildStringMod
		if ((Get-Explorer)) {
			$sedied = 0
			break
		}
		Start-Sleep -Seconds 10
	}
	Wait-Explorer
}
