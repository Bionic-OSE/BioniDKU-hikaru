$eid = Start-Process $env:SYSTEMROOT\explorer.exe -PassThru
if (-not $NoStop) {Start-Process "$env:SYSTEMDRIVE\Program Files\DesktopInfo\DesktopInfo.exe"}
Start-Sleep -Seconds 1
Set-ItemProperty "HKCU:\Software\Hikaru-chan" -Name ShellID -Value $eid.Id -Type String -Force
exit
