::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAjk
::fBw5plQjdCyDJHuR4FY1OidzRRC+HmK1CLw4w9225+OMo18IaMo2c47Jz4imKesS+Eznepg4xjRTm8Rs
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSDk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+IeA==
::cxY6rQJ7JhzQF1fEqQJieEsaHWQ=
::ZQ05rAF9IBncCkqN+0xwdVsGHFTMbQs=
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDCyLN2qoA7MO7fvz4P3Jp1UYNA==
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQISIRRaRSCpCSuLE7wf46jW6uSS4ngNUOMrfZ27
::dhA7uBVwLU+EWHuN+0w5K1t2WRCWOXna
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATElA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJHuR4FY1OidzRRCOPWmGJLwT5uHfxN/KpF8cWecod53Q5paHL+4azm7ROJ4k3XtIjcYHMDNRdRO5awkmrH1KikyMPMaOtgnzT1uB6Vx+Hn1x5w==
::YB416Ek+ZW8=
::
::
::978f952a14a936cc963da21a135fa983

@echo off

dir %systemdrive%\Bionic\Hikarefresh\hikarefreshow.ps1 > nul
if %errorlevel%==1 exit

powershell -Command "& $env:SYSTEMDRIVE\Bionic\Hikarefresh\hikarefreshow.ps1"
