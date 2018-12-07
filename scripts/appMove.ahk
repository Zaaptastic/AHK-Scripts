snapLeft()
{
	WinGetPos, currentX, currentY, currentW, currentH, A
	
	WinMove, A, , 0, currentY, currentW, currentH
}

bufferLeft(bufferZoneX)
{
	WinGetPos, currentX, currentY, currentW, currentH, A
	
	if (currentX == 0) {
		return
	} else if (currentX <= bufferZoneX) {
		WinMove, A, , 0, currentY, currentW, currentH
	} else {
		WinMove, A, , bufferZoneX, currentY, currentW, currentH
	}
}

snapRight(MonitorDimensionsRight)
{
	WinGetPos, currentX, currentY, currentW, currentH, A
	newXCoord := MonitorDimensionsRight - currentW
	
	WinMove, A, , newXCoord, currentY, currentW, currentH	
}

bufferRight(MonitorDimensionsRight, bufferZoneX)
{
	WinGetPos, currentX, currentY, currentW, currentH, A
	newXCoord := MonitorDimensionsRight - currentW
	
	if (currentX == newXCoord) {
		return
	} else if (currentX >= newXCoord - bufferZoneX) {
		WinMove, A, , newXCoord, currentY, currentW, currentH
	} else {
		WinMove, A, , newXCoord - bufferZoneX, currentY, currentW, currentH
	}		
}

snapUp()
{
	WinGetPos, currentX, currentY, currentW, currentH, A
	
	WinMove, A, , currentX, 0, currentW, currentH
}

bufferUp(bufferZoneY)
{
	WinGetPos, currentX, currentY, currentW, currentH, A
	
	if (currentY == 0) {
		return
	} else if (currentY <= bufferZoneY) {
		WinMove, A, , currentX, 0, currentW, currentH
	} else {
		WinMove, A, , currentX, bufferZoneY, currentW, currentH
	}
}

snapDown(MonitorDimensionsBottom)
{
	WinGetPos, currentX, currentY, currentW, currentH, A
	newYCoord := MonitorDimensionsBottom - currentH
	
	WinMove, A, , currentX, newYCoord, currentW, currentH
}

bufferDown(MonitorDimensionsBottom, bufferZoneY)
{
	WinGetPos, currentX, currentY, currentW, currentH, A
	newYCoord := MonitorDimensionsBottom - currentH
	
	if (currentY == newYCoord) {
		return
	} else if (currentY >= newYCoord - bufferZoneY) {
		WinMove, A, , currentX, newYCoord, currentW, currentH
	} else {
		WinMove, A, , currentX, newYCoord - bufferZoneY, currentW, currentH
	}	
}

centerHorizontal(MonitorDimensionsRight)
{
	WinGetPos, currentX, currentY, currentW, currentH, A

	monitorMidpoint := MonitorDimensionsRight / 2
	windowOffset := currentW / 2

	WinMove, A, , monitorMidpoint - windowOffset, currentY, currentW, currentH
}

centerVertical(MonitorDimensionsBottom)
{
	WinGetPos, currentX, currentY, currentW, currentH, A

	monitorMidpoint := MonitorDimensionsBottom / 2
	windowOffset := currentH / 2

	WinMove, A, , currentX, monitorMidpoint - windowOffset, currentW, currentH
}