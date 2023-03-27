::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCyDJHuR4FY1OidzRRCOPWmGJLwT5uHfxN/KrkIeVe4DXIrNyaSPI+Ve/kD3YZ8j0UZykcANHhJbcRyXRgY/qHxLtWuLec6fvG8=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSTk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+JeA==
::cxY6rQJ7JhzQF1fEqQJQ
::ZQ05rAF9IBncCkqN+0xwdVs0
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJHuR4FY1OidzRRCOPWmGJLwT5uHfxN/KrkIeVe4DXIrNyaSPI+Ve/kD3YZ8j0UZykcANHg5kVhugbx0h52taswQ=
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
rem ####### Hikaru-chan by Bionic Butter #######

rem Pre-Explorer command section
rem --------------------------------------------
call %systemdrive%\Bionic\Hikaru\Hikarun.bat
rem --------------------------------------------

rem Hikaru section
:StartupBegin
reg import %systemdrive%\Bionic\Hikaru\ShellDefault.reg
start %windir%\Explorer.exe
timeout /t 3 /nobreak
for /f "tokens=3" %%a in ('reg query "HKCU\Software\Hikaru-chan" /v StartupSoundVariant  ^|findstr /ri "REG_DWORD"') do set "ssv=%%a"
if %ssv%==0x1 goto StartupSoundDefault
if %ssv%==0x2 goto StartupSoundOSSE
if %ssv%==0x3 goto StartupSoundOSTE
goto StartupSoundNone

:StartupSoundDefault
%systemdrive%\Bionic\Hikaru\FFPlay.exe -i %systemdrive%\Bionic\Hikaru\StartupSound1.mp3 -nodisp -hide_banner -autoexit 
goto StartupDone

:StartupSoundOSSE
%systemdrive%\Bionic\Hikaru\FFPlay.exe -i %systemdrive%\Bionic\Hikaru\StartupSound2.mp3 -nodisp -hide_banner -autoexit 
goto StartupDone

:StartupSoundOSTE
%systemdrive%\Bionic\Hikaru\FFPlay.exe -i %systemdrive%\Bionic\Hikaru\StartupSound3.mp3 -nodisp -hide_banner -autoexit 
timeout /t 3 /nobreak
goto StartupDone

:StartupSoundNone
timeout /t 7 /nobreak
goto StartupDone

:StartupDone
reg import %systemdrive%\Bionic\Hikaru\ShellHikaru.reg
exit