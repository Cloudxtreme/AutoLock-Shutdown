#NoTrayIcon
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#region - AutoIt3Wrapper Directives
#AutoIt3Wrapper_Icon=autoshutdown.ico
#AutoIt3Wrapper_Version=P
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=N
#AutoIt3Wrapper_UseX64=N
#AutoIt3Wrapper_Res_Comment=http://xan-manning.co.uk/
#AutoIt3Wrapper_Res_Description=AutoLock/Shutdown
#AutoIt3Wrapper_Res_Fileversion=1.0.0.2
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=P
#AutoIt3Wrapper_Res_Language=2057
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © 2010 Xan Manning
#AutoIt3Wrapper_Res_Field=Made By|Xan Manning
#AutoIt3Wrapper_Res_Field=Email|xan.manning at gmail .com
#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Res_Field=Compile Date|%date% %time%
#AutoIt3Wrapper_Run_cvsWrapper=Y
#endregion

Opt("GuiOnEventMode",1)
Opt("TrayOnEventMode",1)
Opt("TrayMenuMode",1); no default tray menuitems

;---------------Tray event values----------------

Global $TRAY_CHECKED					= 1
Global $TRAY_UNCHECKED					= 4
Global $Lock							= 0
Global $Shutdown						= 0
Global $Idle							= 0
Global $Time							= 0
Global $Hour							= 0
Global $Minutes							= 0
Global $IMinutes						= 0
Global $TimeoutAction					= IniRead("timeoutaction.ini", "config", "TimeoutAction", 0)
Global $TimeoutValue					= IniRead("timeoutaction.ini", "config", "TimeoutValue", 0)
Global $sleepTimeX						= IniRead("timeoutaction.ini", "config", "TimeoutMinutes", 5)
Global $actionTime						= IniRead("timeoutaction.ini", "config", "TimeoutTime", "02:30")

;---------------Set initial variables----------------

$sleepTime = (1000 * 60 * $sleepTimeX) - 1
$lastpos = MouseGetPos()
    
;---------------Build UI----------------
TraySetClick(16)

$tactionitem = TrayCreateItem("Timeout Action")
TrayItemSetOnEvent(-1, "DisplayTAction")
TrayItemSetState($tactionitem, $TRAY_UNCHECKED)
$tvalueitem = TrayCreateItem("Set Timeout")
TrayItemSetOnEvent(-1, "DisplayTValue")
TrayItemSetState($tvalueitem, $TRAY_UNCHECKED)
TrayCreateItem("")
$infoitem = TrayCreateItem("About")
TrayItemSetOnEvent(-1, "DisplayAbout")
TrayItemSetState($infoitem, $TRAY_UNCHECKED)
TrayCreateItem("")
$exititem = TrayCreateItem("Exit")
TrayItemSetOnEvent(-1,"ExitEvent")

TraySetIcon(@AutoItExe)

TraySetState()
TraySetToolTip("AutoLock/Shutdown")

;---------------Main loop----------------

While 1
	If $TimeoutValue < 1 Then
		$currentpos = MouseGetPos()
		$sleepTime = (1000 * 60 * $sleepTimeX)
		Sleep(Int($sleepTime/10))
		$currentpos = MouseGetPos()
		Sleep(Int($sleepTime/10))
		$currentpos = MouseGetPos()
		Sleep(Int($sleepTime/10))
		$currentpos = MouseGetPos()
		Sleep(Int($sleepTime/10))
		$currentpos = MouseGetPos()
		Sleep(Int($sleepTime/10))
		$currentpos = MouseGetPos()
		Sleep(Int($sleepTime/10))
		$currentpos = MouseGetPos()
		Sleep(Int($sleepTime/10))
		$currentpos = MouseGetPos()
		Sleep(Int($sleepTime/10))
		$currentpos = MouseGetPos()
		Sleep(Int($sleepTime/10))
		$currentpos = MouseGetPos()
		Sleep(Int($sleepTime/10))
		$currentpos = MouseGetPos()
		If $lastpos[0] = $currentpos[0] And $lastpos[1] = $currentpos[1] Then
			If $TimeoutAction < 1 Then
				Send("#l")
			Else
				Shutdown(12)
			EndIf
		EndIf
		$lastpos = $currentpos
	Else
		$currentTime = @HOUR & ":" & @MIN
		If $currentTime == $actionTime Then
			If $TimeoutAction < 1 Then
				Send("#l")
			Else
				Shutdown(12)
			EndIf
			Sleep(60000)
		EndIf
		Sleep(10000)
	EndIf
WEnd

Exit

;---------------Functions----------------

Func DisplayAbout()
	TrayItemSetState($infoitem, $TRAY_UNCHECKED)
	MsgBox(64, "About AutoLock/Shutdown.", "AutoLock/Shutdown" & @CRLF & "Written by Xan Manning, 2011" & @CRLF & @CRLF & "Locks workstation or shuts down at timeout." & @CRLF & @CRLF & "http://xan-manning.co.uk/", 300)
EndFunc

Func DisplayTAction()
	TrayItemSetState($tactionitem, $TRAY_UNCHECKED)
	$TAction = GUICreate("Timeout Action", 305, 86, 192, 124)
	$Lock = GUICtrlCreateRadio("Lock Screen (or Switch User)", 16, 32, 177, 17)
	If $TimeoutAction < 1 Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	EndIf
	$Shutdown = GUICtrlCreateRadio("Shutdown", 16, 56, 113, 17)
	If $TimeoutAction > 0 Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	EndIf
	$OK = GUICtrlCreateButton("OK", 192, 48, 91, 25)
	$Label1 = GUICtrlCreateLabel("Default action at timeout:", 16, 8, 122, 17)
	GUICtrlSetOnEvent($OK, "SaveTAction")
	GUISetState(@SW_SHOW)
EndFunc

Func DisplayTValue()
	TrayItemSetState($tvalueitem, $TRAY_UNCHECKED)
	$TValue = GUICreate("Set Timeout", 187, 187, 238, 185)
	$Label1 = GUICtrlCreateLabel("Set timeout", 24, 8, 57, 17)
	$Idle = GUICtrlCreateRadio("When the mouse is idle for:", 24, 32, 153, 17)
	If $TimeoutValue < 1 Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	EndIf
	$Label2 = GUICtrlCreateLabel("minutes", 80, 64, 40, 17)
	$IMinutes = GUICtrlCreateInput($sleepTimeX, 24, 56, 49, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_NUMBER,$WS_HSCROLL,$WS_VSCROLL))
	GUICtrlSetLimit(1, 3)
	$Time = GUICtrlCreateRadio("When the time is:", 24, 88, 113, 17)
	If $TimeoutValue > 0 Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	EndIf
	
	$savedTime = StringSplit($actionTime, ":")
	
	$Hour = GUICtrlCreateInput($savedTime[1], 24, 112, 49, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_NUMBER,$WS_HSCROLL,$WS_VSCROLL))
	GUICtrlSetLimit(1, 2)
	$Label3 = GUICtrlCreateLabel(":", 80, 112, 7, 25)
	$Minutes = GUICtrlCreateInput($savedTime[2], 88, 112, 49, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_NUMBER,$WS_HSCROLL,$WS_VSCROLL))
	GUICtrlSetLimit(1, 2)
	$OK = GUICtrlCreateButton("OK", 40, 144, 107, 25)
	GUICtrlSetOnEvent($OK, "SaveTValue")
	GUISetState(@SW_SHOW)
EndFunc

Func SaveTAction()
	$LockState = GUICtrlRead($Lock)
	$ShutdownState = GUICtrlRead($Shutdown)
	;MsgBox(64, "Shit", $ShutdownState)
	If $LockState == $GUI_CHECKED Then
		$TimeoutAction = 0
	Else
		$TimeoutAction = 1
	EndIf
	IniWrite("timeoutaction.ini", "config", "TimeoutAction", $TimeoutAction)
	OnClose()
EndFunc

Func SaveTValue()
	$IdleState = GUICtrlRead($Idle)
	$TimeState = GUICtrlRead($Time)
	;MsgBox(64, "Shit", $TimeState)
	If $IdleState == $GUI_CHECKED Then
		$TimeoutValue = 0
	Else
		$TimeoutValue = 1
	EndIf
	If GUICtrlRead($Hour) And Number(GUICtrlRead($Hour)) > 23 Then
		MsgBox(-1, "", "Maximum Value of Hours is 23")
		GUICtrlSetData($Hour, "23")
		Return False
	EndIf
	If GUICtrlRead($Minutes) And Number(GUICtrlRead($Minutes)) > 59 Then
		MsgBox(-1, "", "Maximum Value of Minutes is 59")
		GUICtrlSetData($Minutes, "59")
		Return False
	EndIf
	If GUICtrlRead($IMinutes) And Number(GUICtrlRead($IMinutes)) > 300 Then
		MsgBox(-1, "", "Maximum Value of Idle Minutes is 300")
		GUICtrlSetData($IMinutes, "300")
		Return False
	EndIf
	$rHour = Number(GUICtrlRead($Hour))
	$rMinutes = Number(GUICtrlRead($Minutes))
	
	If StringLen($rHour) < 2 Then
		$rHour = "0" & $rHour
	EndIf
	If StringLen($rMinutes) < 2 Then
		$rMinutes = "0" & $rMinutes
	EndIf
	
	$actionTime = $rHour & ":" & $rMinutes
	$sleepTimeX = Number(GUICtrlRead($IMinutes))
	IniWrite("timeoutaction.ini", "config", "TimeoutValue", $TimeoutValue)
	IniWrite("timeoutaction.ini", "config", "TimeoutTime", $actionTime)
	IniWrite("timeoutaction.ini", "config", "TimeoutMinutes", $sleepTimeX)
	OnClose()
EndFunc

Func ExitEvent()
    Exit
EndFunc

Func OnClose()
    GUIDelete()
EndFunc