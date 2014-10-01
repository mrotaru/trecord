#Persistent

; includes
#include %A_ScriptDir%/lib
#include set_timer_f.ahk
#include utils.ahk

; state
old_prog = StartUp
first_run = true

; settings
filename = time.txt ; output
debug_log_file = debug.log ; debug log
DEBUG_MODE = 0 ; tray notifications and logging

; set initial start time
SetTimer, ActiveProgLog, 500
return

;--------------------------------------------------
ActiveProgLog:
if (old_prog = WinExist("A"))                ; if hWnd values match
   return                                    ; go back and wait for next execution of time

debug()

; first run - skip writing
if (first_run) {
    first_run = 0
    goto SkipWriting
}

; do not log certain windows
WinGet, _program_name, ProcessName, A
WinGetActiveTitle, _window_name
if (_window_name = "")
    return
if (_window_name = "Task Switching")
    return

; get time
debug("After returns")
T_NOW=%A_now%

FormatTime, T_NOW_F,,MM/dd/yy hh:mm:ss tt
FormatTime, day_of_week,,dddd			;the full day of the week variable
FormatTime, day,,dd				;day of the month variable
FormatTime, month,,MMM				;month number variable
FormatTime, year,,yyyy				;full 4 digit year variable
FormatTime, week,,YWeek				;week number variable, in the format of YYYYWW

DIFF_SECONDS:=T_NOW
DIFF_SECONDS-=T_START,seconds

Transform hr,  floor, (DIFF_SECONDS/3600)
Transform min, floor, (DIFF_SECONDS/60) - hr*60
sec := DIFF_SECONDS - min*60 - hr*3600
If ( sec < 10 )
   sec = 0%sec%
If ( min < 10 )
   min = 0%min%

Duration1=%hr%:%min%:%sec%

debug_tray("Writing: " window_name Duration1)
debug("Writing : " window_name)

datarow = {window: "%window_name%", duration: "%Duration1%", start: "%T_START_F%", end: "%T_NOW_F%", program: "%program_name%"}`r`n
FileAppend, %datarow%, %filename%

SkipWriting:
WinGet, program_name, ProcessName, A
WinGetActiveTitle, window_name

; do not log certain windows
if (window_name = "")
    return
if (window_name = "Task Switching")
    return

debug("Set new window : " window_name)

; set old_prog with hWnd of new active window
old_prog :=   WinExist("A")                   

; reset StartTime with new time
FormatTime, T_START_F,,MM/dd/yy hh:mm:ss tt
T_START=%A_now%

return
