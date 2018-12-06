#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%\tmp  ; Ensures a consistent starting directory
#include %A_ScriptDir%\lib\jsonParser.ahk
#EscapeChar `
#CommentFlag ;

; Environment Variables
quickCommandtoggle:=false ; Used to toggle Quick Commands Menu
SysGet, MonitorDimensions, MonitorWorkArea ; Used to obtain monitor width and height in pixels
bufferZoneX := Floor(MonitorDimensionsRight * .05) ; Used to leave some space when moving windows
bufferZoneY := Floor(MonitorDimensionsBottom * .05)
appDimensionFilePath := "applicationDimensions.txt"

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
	Progress Off
	
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
	WinGet, currentProcess, ProcessName, A
	WinGetPos, currentX, currentY, currentW, currentH, A
	
	apps := readFromFile(appDimensionFilePath)
	appDimensions := StrSplit(apps[currentProcess], ",")
	appWidth := appDimensions[1]
	appHeight := appDimensions[2]

	WinMove, A, , currentX, currentY, appWidth, appHeight

	return
	
#^2::
	WinGet, currentProcess, ProcessName, A
	WinGetPos, currentX, currentY, currentW, currentH, A
	appDimensions := currentW . "," . currentH
	
	apps := readFromFile(appDimensionFilePath)
	apps[currentProcess] := appDimensions
	writeToFile(apps, appDimensionFilePath)
	
	return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The following commands manipulate window placement
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#Left::
	WinGetPos, currentX, currentY, currentW, currentH, A
	
	WinMove, A, , 0, currentY, currentW, currentH
	
	return
	
#^Left::
	WinGetPos, currentX, currentY, currentW, currentH, A
	
	if (currentX == 0) {
		return
	} else if (currentX <= bufferZoneX) {
		WinMove, A, , 0, currentY, currentW, currentH
	} else {
		WinMove, A, , bufferZoneX, currentY, currentW, currentH
	}

	return	
	
#Right::
	WinGetPos, currentX, currentY, currentW, currentH, A
	newXCoord := MonitorDimensionsRight - currentW
	
	WinMove, A, , newXCoord, currentY, currentW, currentH

	return
	
#^Right::
	WinGetPos, currentX, currentY, currentW, currentH, A
	newXCoord := MonitorDimensionsRight - currentW
	
	if (currentX == newXCoord) {
		return
	} else if (currentX >= newXCoord - bufferZoneX) {
		WinMove, A, , newXCoord, currentY, currentW, currentH
	} else {
		WinMove, A, , newXCoord - bufferZoneX, currentY, currentW, currentH
	}	

	return	
	
#Up::
	WinGetPos, currentX, currentY, currentW, currentH, A
	
	WinMove, A, , currentX, 0, currentW, currentH

	return	
	
#^Up::
	WinGetPos, currentX, currentY, currentW, currentH, A
	
	if (currentY == 0) {
		return
	} else if (currentY <= bufferZoneY) {
		WinMove, A, , currentX, 0, currentW, currentH
	} else {
		WinMove, A, , currentX, bufferZoneY, currentW, currentH
	}
	return	
	
#Down::
	WinGetPos, currentX, currentY, currentW, currentH, A
	newYCoord := MonitorDimensionsBottom - currentH
	
	WinMove, A, , currentX, newYCoord, currentW, currentH
	
	return
	
#^Down::
	WinGetPos, currentX, currentY, currentW, currentH, A
	newYCoord := MonitorDimensionsBottom - currentH
	
	if (currentY == newYCoord) {
		return
	} else if (currentY >= newYCoord - bufferZoneY) {
		WinMove, A, , currentX, newYCoord, currentW, currentH
	} else {
		WinMove, A, , currentX, newYCoord - bufferZoneY, currentW, currentH
	}	
	return

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Utility Methods and Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	
; Writes an Object to a filepath
writeToFile(obj, filepath)
{
	; First delete the existing filepath
	FileDelete, %filepath%

	s := ""
	for k, v in obj
	{
	    ; Create a new line
        if (s != "")
			s .= "`n"
		
		; Add application name (key)
		s .= k
		
		; Add delimiter
		s .= ","
		
		; Add dimension value (value)
		s .= v
	}
	FileAppend, %s%, %filepath%
}

; Reads an Object from a filepath
readFromFile(filepath)
{
	obj := Object()

	Loop, Read, %filepath%
	{
		lineTokens := StrSplit(A_LoopReadLine,",")
		appProcess := lineTokens[1]
		appWidth := lineTokens[2]
		appHeight := lineTokens[3]
		appDimensions := appWidth . "," . appHeight
		
		obj[appProcess] := appDimensions
	}
	
	return obj
}
	
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;
; Console applications
;;;;;;;;;;;;;;;;;;;;;;
#IfWinActive ahk_class ConsoleWindowClass
^v::SendInput {RAW}%ClipBoard%        ; Ctrl-V paste