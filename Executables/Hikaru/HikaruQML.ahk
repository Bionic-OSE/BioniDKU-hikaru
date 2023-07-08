#Requires AutoHotkey v2.0
#UseHook
#SingleInstance
#ErrorStdOut
Prod := RegRead("HKEY_CURRENT_USER\Software\Hikaru-chan", "ProductName")
SysDrive := EnvGet("SYSTEMDRIVE")
A_IconTip := Format("{1} Quick Menu`n(Double-click or Ctrl+Shift+Alt+Q to open)", Prod)
A_TrayMenu.Delete
A_TrayMenu.Add("Open Quick Menu", HikaruQML) 
A_TrayMenu.Add("Open Administrative Menu", HikaruAML) 
A_TrayMenu.Default := "Open Quick Menu"
A_TrayMenu.ClickCount := 2
Persistent


^!+Q::Run Format("{1}\Bionic\Hikaru\HikaruQM.exe", SysDrive)
^!+A::Run Format("{1}\Bionic\Hikaru\HikaruAM.exe", SysDrive)
HikaruQML(*)
{
	Run Format("{1}\Bionic\Hikaru\HikaruQM.exe", SysDrive)
}
HikaruAML(*)
{
	Run Format("{1}\Bionic\Hikaru\HikaruAM.exe", SysDrive)
}
