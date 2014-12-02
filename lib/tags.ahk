; check dependecies
;IsFunc("SetTimerF") ? continue : MsgBox "Should have 'SetTimerF' function"
;IsFunc("StrObj")    ? continue : MsgBox "Should have 'StrObj' function"

; read config
if(!tag_config) {
    global tag_config
    tag_config := StrObj("tags.yml")
    ;MsgBox % StrObj(tag_config)
    ;debug_tray(StrObj(tag_config))
}

; Determine to which tags `info` corresponds
; ------------------------------------------
; info is an object about the current program, including at minimum
; program_name and window_title, but also can contain additional properties
; such as `url` or `path`. Return: array of matching tags
getAutoTags(info) {
    local tags := []
    ;MsgBox % JSON.stringify(info)
    ; tag - warband
    ; tagKeys - program_name, path, etc
    For tag, tagKeys in tag_config
        ; tagKey - path
        ; tagValue - [ "a.exe", "b.exe" ] || "c:\\code"
        For tagKey, tagValue in tagKeys
            ; check if `info` has `tagKey` property
            if(info[tagKey]) {
                ; if it's an array
                if(isObject(tag_config[tag][tagKey])) {
                    ;MsgBox % "an object: " tag "[" tagKey "]"
                    ; iterate
                    For index, regex in tag_config[tag][tagKey]
                        if(RegExMatch(info[tagKey], regex)) {
                            MsgBox % "found tag: " tag " for " info[tagKey]
                            tags.insert(tag)
                        } else {
                            MsgBox % "no match: " info[tagKey]
                        }
                } else {
                    pos := RegExMatch(info[tagKey], tag_config[tag][tagKey])
                    if(pos) {
                        MsgBox % "found tag: " tag " for " info[tagKey]
                        tags.insert(tag)
                    }
                }
            }
    return tags
}
