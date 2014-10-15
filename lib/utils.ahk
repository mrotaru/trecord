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
