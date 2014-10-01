; check dependecies
IsFunc("SetTimerF") ? continue : MsgBox "Should have 'SetTimerF' function"

isDebugging(){
    global DEBUG_MODE
    DEBUG_MODE ?  return 1 : return 0
}

; append `msg` to `debug_log_file`
debug(msg=""){
    global debug_log_file
    isDebugging ? continue : return
    FileAppend, %msg%`r`n, %debug_log_file%
}

; show `msg` as a tray notification fo 2 seconds
debug_tray(msg=""){
    isDebugging ? continue : return
    TrayTip, , %msg%,1,1
    SetTimerF("remove_tray_tip", -2000) ; -2000 - run once after 2s
}

remove_tray_tip(){
    isDebugging ? continue : return
    TrayTip
}
