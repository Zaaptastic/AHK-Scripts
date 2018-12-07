#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input

;;;;;;;;;;;;;;;;;;;;;;
; Scripts for consoles
;;;;;;;;;;;;;;;;;;;;;;

#IfWinActive ahk_class ConsoleWindowClass
^v::SendInput {RAW}%ClipBoard%        ; Ctrl-V paste