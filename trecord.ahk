#Persistent

; includes
#include %A_ScriptDir%/lib
#include set_timer_f.ahk
#include utils.ahk

; state
old_prog = StartUp
first_run = 1
store_prev = 1

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
shouldLog() {
    global

    if (g_window_title = "")
        return 0
    if (g_window_title = "Task Switching")
        return 0
    ;debug_tray("should log" windowTitle)
    return 1
}

; set g_program_name and g_window_title
; -------------------------------------
getCurrentProgramInfo() {
    global

    ; store previous values
    if(store_prev) {
        g_prev_program_name := g_program_name
        g_prev_window_title := g_window_title
    }

    ; get new ones
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
    datarow = {window: "%g_prev_window_title%", duration: "%T_DURATION%", start: "%T_START_F%", end: "%T_NOW_F%", program: "%g_prev_program_name%"}`r`n
    debug_tray("Writing: " g_prev_window_title " " T_DURATION)
    FileAppend, %datarow%, %filename%

    store_prev = 1
}

checkCurrentProgram() {
    global

    if (old_prog = WinExist("A"))                ; if hWnd values match
       return                                    ; go back and wait for next execution of time

    getCurrentProgramInfo()

    ; not first run - log previously recorded window
    if (!first_run) {
        if(shouldLog()) {
            writeLogEntry()
        } else {
            store_prev = 0
            return
        }
    } else {
        first_run = 0
    }

    ; set old_prog with hWnd of new active window
    old_prog := WinExist("A")                   

    ; reset StartTime with new time
    FormatTime, T_START_F,,MM/dd/yy hh:mm:ss tt
    T_START=%A_now%
}
