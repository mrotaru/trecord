#Persistent
old_prog = StartUp
first_run = true

; set location and header row for the output file
;filename = %A_UserName%_%a_yyyy%-%a_mm%.txt
filename = log.txt

; set initial start time
;FormatTime, StartTime,,MM/dd/yy hh:mm:ss tt
SetTimer, ActiveProgLog, 500
SetTimer, RemoveTrayTip, 2000
return

RemoveTrayTip:
TrayTip
return

;--------------------------------------------------
ActiveProgLog:
if (old_prog = WinExist("A"))                ; if hWnd values match
   return                                    ; go back and wait for next execution of time

; get new program info
WinGet, program_name, ProcessName, A
WinGetActiveTitle, window_name

if (!first_run)
    first_run = false

; do not log certain windows
if (window_name = "")
    return
if (window_name = "Task Switching")
    return

; get time
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

; save values for output file
TrayTip, , Writing: %window_name% %Duration1%,1,1
datarow = {window: "%window_name%", duration: "%Duration1%", start: "%T_START_F%", end: "%T_NOW_F%", program: "%program_name%"}`r`n
FileAppend, %datarow%, %filename%

; set old_prog with hWnd of new active window
old_prog :=   WinExist("A")                   

; reset StartTime with new time
FormatTime, T_START_F,,MM/dd/yy hh:mm:ss tt
T_START=%A_now%

return
