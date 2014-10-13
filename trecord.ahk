#Persistent

; includes
#include %A_ScriptDir%/lib
#include set-timer-f.ahk
#include get-active-browser-url.ahk
#include utils.ahk

; settings
filename = time.txt ; output
debug_log_file = debug.log ; debug log
DEBUG_MODE = 1 ; tray notifications and logging
TIMESTAMP_FORMAT = yyyy-MM-ddThh:mm:ssZ
PROGRAM_CHECK_FREQUENCY = 500
;IDLE_TIME = 30000 ; 5 minutes
IDLE_TIME = 3000 ; 3 seconds

; state
old_prog = StartUp
olt_title := ""
first_run = 1
store_prev = 1
is_away = 0
idle_start = 0 ; timestamp; not 100% accurate

; set initial start time
SetTimerF("checkCurrentProgram", PROGRAM_CHECK_FREQUENCY)

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
    return 1
}

; set g_program_name and g_window_title
; -------------------------------------
getWindowProgramInfo(window_ahk_id) {
    global

    ; store previous values
    if(store_prev) {
        g_prev_program_name := g_program_name
        g_prev_window_title := g_window_title
    }

    ; get new ones
    WinGet, g_program_name, ProcessName, ahk_id %window_ahk_id%
    WinGetTitle, g_window_title, ahk_id %window_ahk_id%
}

; returns url if `hwnd` is a browser
; -------------------------------------
getBrowserUrl(hwnd) {
    local url, windowClass
	WinGetClass, windowClass, ahk_id %hwnd%
	If windowClass In Chrome_WidgetWin_1,Chrome_WidgetWin_0,Maxthon3Cls_MainFrm
		Return GetBrowserURL_ACC(windowClass)
	Else
		Return GetBrowserURL_DDE(windowClass) ; empty string if DDE not supported (or not a browser)
}

; -------------------------------------
isABrowser(hwnd) {
	WinGetClass, windowClass, ahk_id %hwnd%
	If windowClass in IEFrame,MozillaWindowClass,OperaWindowClass,Chrome_WidgetWin_1,Chrome_WidgetWin_0,Maxthon3Cls_MainFrm
        return true

    return false
}

; log entry
; ---------
writeLogEntry() {
    global

    ; calc time difference
    T_NOW=%A_now%
    FormatTime, T_NOW_F,,%TIMESTAMP_FORMAT%
    T_DURATION := getTimeDifference(T_START, T_NOW)

    ; browser ? then extract URL
    if(isABrowser(old_prog)) {
        url := getBrowserUrl(old_prog)
    }

    ; build data
    datarow := "{window: """ . g_prev_window_title . ""","
    if(url != "") {
        datarow .= "url: """ . url . """"
    }
    datarow .= ", duration: " . T_DURATION . """, start: " . T_START_F . """" . ", end: """ . T_NOW_F . """, program: """ . g_prev_program_name . """}`r`n"
    
    ;debug_tray("Writing: " g_prev_window_title " " T_DURATION)

    ; write
    FileAppend, %datarow%, %filename%

    store_prev = 1
}

writeAwayEntry() {
    ; build data
    global
    away_end = %A_now%
    ;local away_duration := getTimeDifference(away_start,away_end)
    local away_duration := away_end - away_start
    FormatTime, away_duration_f,away_duration,hh:mm:ss
    FormatTime, away_end_f,,%TIMESTAMP_FORMAT%
    datarow := "{away: ""true"", start: """ . away_start_f . """, end: """ . away_end_f . """," . away_duration . """}`r`n"

    ;debug_tray("Writing: away: " away_duration)
    debug_tray("Writing: away: " away_duration, 5)

    ; write
    FileAppend, %datarow%, %filename%
}

checkCurrentProgram() {
    global

    ; check if idle
    if(A_TimeIdle > IDLE_TIME) {
        if(!is_away) {
            away_start := A_now
            away_start_before = %away_start%
            IDLE_TIME_SECONDS := Floor(IDLE_TIME/1000)
            ;away_start -= IDLE_TIME_SECONDS, seconds
            ;EnvSub, away_start, IDLE_TIME_SECONDS, seconds
            FormatTime, away_start_f,%away_start%,%TIMESTAMP_FORMAT%
            debug_tray("away: " . away_start_before . " - " . away_start . " s: " . IDLE_TIME_SECONDS)
            is_away = true
        }
    } else {
        if(is_away) {
            writeAwayEntry()
            is_away = 0
        }
    }

    ; check if title is different form previous when window id is the same
    ; ex: Firefox - will have the same window id, even though a different
    ; tab is opened.
    curr_ahk_id := WinExist("A")
    if (old_prog = curr_ahk_id) {                ; if hWnd values match
        WinGetTitle, curr_title, ahk_id %curr_ahk_id%
        if (old_title = curr_title) {
            return
        }
    }

    getWindowProgramInfo(curr_ahk_id)

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
    WinGetTitle, old_title, ahk_id %old_prog%

    ; reset StartTime with new time
    FormatTime, T_START_F,,%TIMESTAMP_FORMAT%
    T_START=%A_now%
}
