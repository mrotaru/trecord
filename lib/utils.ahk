; check dependecies
IsFunc("SetTimerF") ? continue : MsgBox "Should have 'SetTimerF' function"

; append `msg` to `debug_log_file`
debug(msg=""){
    global debug_log_file, DEBUG_MODE
    if(!DEBUG_MODE)
        return
    FileAppend, %msg%`r`n, %debug_log_file%
}

; show `msg` as a tray notification fo 2 seconds
debug_tray(msg=""){
    global DEBUG_MODE
    TrayTip, , DEBUG: %DEBUG_MODE%,1,1
    if(!DEBUG_MODE)
        return
    TrayTip, , DEBUG: %DEBUG_MODE% %msg%,1,1
    SetTimerF("remove_tray_tip", -2000) ; -2000 - run once after 2s
}

remove_tray_tip(){
    global DEBUG_MODE
    if(!DEBUG_MODE)
        return
    TrayTip
}
