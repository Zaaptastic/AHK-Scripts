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

closeApplicationOrInstance(processesWithExistingWindowControlSupport)
{
	WinGet, currentProcess, ProcessName, A
	ControlSend, , {CtrlDown}w{CtrlUp}, A
	Send {Alt}
	if (!currentProcessIsInArray(currentProcess, processesWithExistingWindowControlSupport))
		WinClose, A
}

createApplication()
{
	ControlSend, , {CtrlDown}n{CtrlUp}, A
	Send {Alt}
}

createApplicationOrInstance(processesWithExistingWindowControlSupport)
{
	WinGet, currentProcess, ProcessName, A
	ControlSend, , {CtrlDown}t{CtrlUp}, A
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