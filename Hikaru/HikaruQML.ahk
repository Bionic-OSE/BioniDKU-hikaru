#SingleInstance, Force
#ErrorStdOut
Menu, Tray, Tip, BioniDKU Quick Menu`n(Double-click or Ctrl+Shift+Alt+Q to open)
Menu, Tray, NoStandard
Menu, Tray, NoMainWindow
Menu, Tray, Add, Open, HikaruQM
Menu, Tray, Default, Open
Menu, Tray, Click, 2

^!+q::
HikaruQM:
Try {
Run, %systemdrive%\Bionic\Hikaru\HikaruQM.exe
} Catch return
return
return

^!+a::
HikaruAM:
Try {
Run, %systemdrive%\Bionic\Hikaru\HikaruAM.exe
} Catch return
return
return