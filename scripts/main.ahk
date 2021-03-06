﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%\..\tmp  ; Ensures a consistent starting directory
#include %A_ScriptDir%\appDim.ahk
#include %A_ScriptDir%\appMove.ahk
#include %A_ScriptDir%\windowControl.ahk
#EscapeChar `
#CommentFlag ;

;;;;;;;;;;;;;;;;;;;;;;;
; Environment Variables
;;;;;;;;;;;;;;;;;;;;;;;
; Used to toggle Quick Commands Menu
quickCommandtoggle:=false 

; Used to obtain monitor width and height in pixels
SysGet, MonitorDimensions, MonitorWorkArea
; Used to leave some space when moving windows
bufferZoneX := Floor(MonitorDimensionsRight * .05) 
bufferZoneY := Floor(MonitorDimensionsBottom * .05)

; Filepath used to store application Dimensions
appDimensionFilePath := "applicationDimensions.txt" 

; List of Proccesses which already support Window Control commands
processesWithExistingWindowControlSupport := ["chrome.exe", "sublime_text.exe"]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Displays hardcoded menu of possible options
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#`::
	if quickCommandtoggle
	{
		Reload
		quickCommandtoggle:=false
	}
	else
	{
		GoSub, drawQuickCommandsDisplay
		quickCommandtoggle:=true
	}
	return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Toggles Audio input between sound devices named "Headphones" and "External Speakers"	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#1::
	; Toggles between audio output
	toggle := !toggle ; This toggles the variable between true/false
	if toggle
	{
		Run nircmd setdefaultsounddevice "Headphones"
		soundToggleBox("Headphones")
	}
	else
	{
		Run nircmd setdefaultsounddevice "External Speakers"
		soundToggleBox("Speakers")
	}

	return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Store/Restore Window Dimensions	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#2::
	getWinDim(appDimensionFilePath)

	return
	
#!2::
	setWinDim(appDimensionFilePath)
	
	return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The following commands manipulate window placement
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#Left::
	snapLeft()
	
	return
	
#^Left::
	bufferLeft(bufferZoneX)

	return	
	
#Right::
	snapRight(MonitorDimensionsRight)

	return
	
#^Right::
	bufferRight(MonitorDimensionsRight, bufferZoneX)

	return	

#+Left::
#+Right::
	centerHorizontal(MonitorDimensionsRight)

	Return
	
#Up::
	snapUp()

	return	
	
#^Up::
	bufferUp(bufferZoneY)

	return	
	
#Down::
	snapDown(MonitorDimensionsBottom)
	
	return
	
#^Down::
	bufferDown(MonitorDimensionsBottom, bufferZoneY)

	return

#+Up::
#+Down::
	centerVertical(MonitorDimensionsBottom)

	Return

;;;;;;;;;;;;;;;;;
; Window Control
;;;;;;;;;;;;;;;;;
!Q::
	closeApplication()
	Return

!H::
	minimizeApplication()
	Return

!W::
	Send {Alt Up}
	Send ^w
	Return

!T::
	Send {Alt Up}
	Send ^t
	Return

!N::
	Send {Alt Up}
	Send ^n
	Return

!+T::
	Send {Alt Up}
	Send ^+t
	Return

!+N::
	Send {Alt Up}
	Send ^+n
	Return

!A::
	Send {Alt Up}
	Send ^a
	Return

!C::
	Send {Alt Up}
	Send ^c
	Return

!V::
	Send {Alt Up}
	Send ^v
	Return

!Z::
	Send {Alt Up}
	Send ^z
	Return

!S::
	Send {Alt Up}
	Send ^s
	Return

!R::
	Send {Alt Up}
	Send ^r
	Return

!X::
	Send {Alt Up}
	Send ^x
	Return

!F::
	Send {Alt Up}
	Send ^f
	Return

!O::
	Send {Alt Up}
	Send ^o
	Return

!U::
	Send {Alt Up}
	Send ^u
	Return

!I::
	Send {Alt Up}
	Send ^i
	Return

!LButton::
	Send {Alt Up}
	Send ^{Click}
	Return

#!Left::
	Send {Alt Up}
	Send ^+{Tab}
	Return

#!Right::
	Send {Alt Up}
	Send ^{Tab}
	Return

!Space::
	WinActivate, ahk_class Shell_TrayWnd
    Send #s
    return

#Space::
    Send #S
    return

;;;;;;;;;;;;;;;;;;;
; Clipboard Control
;;;;;;;;;;;;;;;;;;;

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Utility Methods and Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	
; Draws the Quick Commands Display Menu, with a timeout
drawQuickCommandsDisplay:
	Gui, destroy
	
	OsdHeight := 100
	BottomCoord := MonitorDimensionsBottom - (OsdHeight * 1.5)
	
	CustomColor := grey  ; Can be any RGB color (it will be made transparent below).
	Gui +LastFound +AlwaysOnTop -Caption +ToolWindow  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	Gui, Color, %CustomColor%
	Gui, Font, s28 ; Set a large font size (32-point).
	Gui, Add, Text, cdarkblue, [Arrows - Move Active Window][1 - Toggle Audio] [2 - Re/Store Window Dims]
	
	; Make all pixels of this color transparent and make the text itself translucent:
	WinSet, TransColor, %CustomColor% 175
	
	Gui, Show, h%OsdHeight% y%BottomCoord% NoActivate  ; NoActivate avoids deactivating the currently active window.
	
	SetTimer, destroyQuickCommandsDisplay, 6000
	return
	
; Teardown the Quick Commands Display Menu and resets the toggle env var
destroyQuickCommandsDisplay:
	SetTimer, destroyQuickCommandsDisplay, off
	Gui, destroy
	
	quickCommandtoggle:=false
	return

	
; Display sound toggle menu
soundToggleBox(Device)
{
	Gui, destroy
	
	Gui, +ToolWindow -Caption +0x400000 +alwaysontop
	Gui, Add, text, x35 y8, Default sound: %Device%
	SysGet, screenx, 0
	SysGet, screeny, 1
	xpos:=screenx-275
	ypos:=screeny-100
	Gui, Show, NoActivate x%xpos% y%ypos% h30 w200, soundToggleWin
	
	SetTimer,soundToggleClose, 2000
}

; Teardown the sound toggle menu
soundToggleClose:
    SetTimer,soundToggleClose, off
    Gui, destroy
	Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Application-Specific Scripts
; These must be at the bottom due to setting active window requirements
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;
; Console applications
;;;;;;;;;;;;;;;;;;;;;;
#include %A_ScriptDir%\consoleScripts.ahk