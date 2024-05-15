;@Ahk2Exe-UpdateManifest 1
;@Ahk2Exe-SetCompanyName Bionic Butter
;@Ahk2Exe-SetFileVersion 3.1.0.0
;@Ahk2Exe-SetVersion 3.1.0.0
;@Ahk2Exe-SetDescription BioniDKU Menus System Tray Application

#Requires AutoHotkey v2.0
#UseHook
#SingleInstance
#ErrorStdOut
Prod := RegRead("HKEY_CURRENT_USER\Software\Hikaru-chan", "ProductName")
SysDrive := EnvGet("SYSTEMDRIVE")
A_IconTip := Format("{1} Menus System Tray`n(Double-click for QM, Right-click for other menus)", Prod)
A_TrayMenu.Delete
A_TrayMenu.Add(Format("{1} Menus System", Prod), HikaruQML) 
A_TrayMenu.Disable(Format("{1} Menus System", Prod))
A_TrayMenu.Add()
A_TrayMenu.Add("Open Quick Menu", HikaruQML) 
A_TrayMenu.Add("Open Administrative Menu", HikaruAML) 
A_TrayMenu.Add()
A_TrayMenu.Add("Open On-Screen Keyboard", TouchKB) 
A_TrayMenu.Default := "Open Quick Menu"
A_TrayMenu.ClickCount := 2
Run Format("{1}\Windows\System32\sc.exe start HikaruQMLd", SysDrive), , "Hide"
Persistent


^!+Q::
{
	Run Format("{1}\Bionic\Hikaru\HikaruQM.exe", SysDrive)
}
^!+A::
{
	Run Format("{1}\Bionic\Hikaru\HikaruAM.exe", SysDrive)
}
HikaruQML(*)
{
	Run Format("{1}\Bionic\Hikaru\HikaruQM.exe", SysDrive)
}
HikaruAML(*)
{
	Run Format("{1}\Bionic\Hikaru\HikaruAM.exe", SysDrive)
}
TouchKB(*)
{
	Run Format("{1}\Windows\System32\osk.exe", SysDrive)
}
