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
DEBUG_MODE = 1 ; tray notifications and logging

; set initial start time
SetTimerF("checkCurrentProgram", 500)

; return time difference in HH:MM:SS format
; -----------------------------------------
getTimeDifference(_T_START, _T_END){
    DIFF_SECONDS:=_T_END
    DIFF_SECONDS-=_T_START,seconds

    Transform hr,  floor, (DIFF_SECONDS/3600)
    Transform min, floor, (DIFF_SECONDS/60) - hr*60
    sec := DIFF_SECONDS - min*60 - hr*3600
    If ( sec < 10 )
       sec = 0%sec%
    If ( min < 10 )
       min = 0%min%

    return hr . ":" . min . ":" . sec
}

; return 1 if should be logged
; ----------------------------
shouldLog(programName, windowTitle) {
    if (windowTitle = "")
        return 0
    if (windowTitle = "Task Switching")
        return 0
    return 1
}

; set g_program_name and g_window_title
; -------------------------------------
getCurrentProgramInfo() {
    global g_program_name, g_window_title
    WinGet, g_program_name, ProcessName, A
    WinGetActiveTitle, g_window_title
}

; log entry
; ---------
writeLogEntry() {
    global

    ; calc time difference
    T_NOW=%A_now%
    FormatTime, T_NOW_F,,MM/dd/yy hh:mm:ss tt
    T_DURATION := getTimeDifference(T_START, T_NOW)

    ; write
    if(shouldLog(g_program_name, g_window_title)) {
        datarow = {window: "%g_window_title%", duration: "%T_DURATION%", start: "%T_START_F%", end: "%T_NOW_F%", program: "%g_program_name%"}`r`n
        debug_tray("Writing: " g_window_title T_DURATION)
        FileAppend, %datarow%, %filename%
    }
}

checkCurrentProgram() {
    global
    if (old_prog = WinExist("A"))                ; if hWnd values match
       return                                    ; go back and wait for next execution of time

    ; not first run - log previously recorded window
    if (!first_run) {
        writeLogEntry()
    } else {
        first_run = 0
        getCurrentProgramInfo()
    }

    ; set old_prog with hWnd of new active window
    old_prog := WinExist("A")                   

    ; reset StartTime with new time
    FormatTime, T_START_F,,MM/dd/yy hh:mm:ss tt
    T_START=%A_now%
}
