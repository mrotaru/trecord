; check dependecies
;IsFunc("SetTimerF") ? continue : MsgBox "Should have 'SetTimerF' function"
;IsFunc("StrObj")    ? continue : MsgBox "Should have 'StrObj' function"

; read config
debug_tray("AAAAAAAAAAAAAAAAAAAAA")
if(!tag_config) {
    tag_config := StrObj("tags.yml")
    MsgBox % StrObj(tag_config)
    ;debug_tray(StrObj(tag_config))
}

; Determine whether `info` corresponds to a tag
; ---------------------------------------------
; info is an object about the current program, including at minimum
; program_name and window_title, but also can contain additional properties
; such as `url` or `path`.
isAutoTag(info) {
}
