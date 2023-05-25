@echo off
rem ####### Hikaru self-startup-repair script #######

net start Audiosrv
reg import C:\Bionic\Hikaru\ShellHikaru.reg
reg add HKLM\SYSTEM\Setup /v CmdLine /t REG_SZ /d "oobe\windeploy" /f
reg add HKLM\SYSTEM\Setup /v SystemSetupInProgress /t REG_DWORD /d 0 /f
reg add HKLM\SYSTEM\Setup /v SetupType /t REG_DWORD /d 0 /f
shutdown -r -t 5
%systemdrive%\Bionic\Hikaru\FFPlay.exe -i %systemdrive%\Bionic\Hikaru\ShellSpinner.mp4 -fs -alwaysontop -noborder
