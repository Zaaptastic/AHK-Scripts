closeApplication()
{
	WinClose, A
	WinActivate
}

minimizeApplication()
{
	WinMinimize, A
	WinActivate
}

; WARNING
; The remaining of these lead to pretty buggy behavior alongside Jarvis for Windows

closeApplicationOrInstance(processesWithExistingWindowControlSupport)
{
	WinGet, currentProcess, ProcessName, A
	Send ^w
	Send {Alt}
	if (!currentProcessIsInArray(currentProcess, processesWithExistingWindowControlSupport))
		WinClose, A
}

createApplication()
{
	Send ^n
	Send {Alt}
}

createApplicationOrInstance(processesWithExistingWindowControlSupport)
{
	WinGet, currentProcess, ProcessName, A
	Send ^t
	Send {Alt}
	if (!currentProcessIsInArray(currentProcess, processesWithExistingWindowControlSupport))
		Run, %currentProcess%
}

currentProcessIsInArray(processString, array)
{
	for i,e in array
	{
		if (processString == e)
			return true
	}
	return false
}