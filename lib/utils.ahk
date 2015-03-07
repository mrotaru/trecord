; check dependecies
IsFunc("SetTimerF") ? continue : MsgBox "Should have 'SetTimerF' function"

isDebugging(){
    global DEBUG_MODE
    return DEBUG_MODE
}

; append `msg` to `debug_log_file`
debug(msg=""){
    global debug_log_file
    if(!isDebugging())
        return
    FileAppend, %msg%`r`n, %debug_log_file%
}

; show `msg` as a tray notification fo 2 seconds
; `display_time` - number of seconds to show the tray message
debug_tray(msg="", display_time=2){
    display_time *= -1000
    if(!isDebugging())
        return
    TrayTip, , %msg%,1,1
    SetTimerF("remove_tray_tip", display_time) ; -2000 - run once after 2s
}

remove_tray_tip(){
    TrayTip
}

; logging

g_default_logging_method := "file"
g_log_file := "trecord_log.txt"
g_log_timestamp_format := "yyyy-MM-ddThh:mm:ssZ"

log(message, tag="*"){
    global g_log_file
    global g_log_timestamp_format
    T_NOW=%A_now%
    MsgBox % "log: " g_log_file
    FormatTime, T_NOW_F,,%g_log_timestamp_format%
    datarow := T_NOW_F . " " . message . "`n"
    FileAppend, %datarow%, %g_log_file%
}
