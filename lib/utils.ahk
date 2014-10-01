RemoveTrayTip:
if(!DEBUG_MODE)
    return
TrayTip
return

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
    if(!DEBUG_MODE)
        return
    TrayTip, , DEBUG: %DEBUG_MODE% %msg%,1,1
    SetTimer, RemoveTrayTip, 2000
}

