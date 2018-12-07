#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%\..\tmp  ; Ensures a consistent starting directory

getWinDim(appDimensionFilePath)
{
	WinGet, currentProcess, ProcessName, A
	WinGetPos, currentX, currentY, currentW, currentH, A
	
	apps := readFromFileV2(appDimensionFilePath)
	currentDimensions := currentW . "," . currentH
	indexToUse := linearSearch(apps[currentProcess], currentDimensions) + 1
	if (indexToUse > apps[currentProcess].MaxIndex())
		indexToUse := 1
	
	appDimensions := StrSplit(apps[currentProcess][indexToUse], ",")
	appWidth := appDimensions[1]
	appHeight := appDimensions[2]

	WinMove, A, , currentX, currentY, appWidth, appHeight
}

setWinDim(appDimensionFilePath)
{
	WinGet, currentProcess, ProcessName, A
	WinGetPos, currentX, currentY, currentW, currentH, A
	appDimensions := currentW . "," . currentH
	
	apps := readFromFileV2(appDimensionFilePath)
	oldAppDimensions := apps[currentProcess]
	newAppDimensions := []
	
	;Copy over existing data
	for i,e in oldAppDimensions
	{
		; Don't copy duplicates
		if (e != appDimensions)
			newAppDimensions.Push(e)
	}
	newAppDimensions.Push(appDimensions)
	
	apps[currentProcess] := newAppDimensions
	writeToFileV2(apps,appDimensionFilePath)
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Utility Methods and Functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	
; Simple linear search for a value in an array, if it exists, return index, otherwise 0
; NB: AHK Arrays start at 1, idk why
linearSearch(array, value)
{
	for i, e in array
	{
		if (e == value)
			return i
	}
	return 0
}
	
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

; Writes an Object to a filepath, allowing for an array as value
writeToFileV2(obj, filepath)
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
		s .= "["
		
		; Add dimension values array (value)
		for i, e in v
		{
			if (i != 1)
				s.= ";"
			s .= v[i]
		}
		
		; Add delimiter
		s .= "]"
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

; Reads an Object from a filepath, assuming that the Object has array values
readFromFileV2(filepath)
{
	obj := Object()

	Loop, Read, %filepath%
	{
		lineTokens := StrSplit(A_LoopReadLine,"[")
		appProcess := lineTokens[1]
		appDimensionsString := lineTokens[2]
		appDimensionsString := SubStr(appDimensionsString, 1, -1)
		
		appDimensions := StrSplit(appDimensionsString,";")
		;appWidth := lineTokens[2]
		;appHeight := lineTokens[3]
		;appDimensions := appWidth . "," . appHeight
		
		obj[appProcess] := appDimensions
	}
	
	return obj
}