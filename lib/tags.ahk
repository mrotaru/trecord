; check dependecies
;IsFunc("SetTimerF") ? continue : MsgBox "Should have 'SetTimerF' function"
;IsFunc("StrObj")    ? continue : MsgBox "Should have 'StrObj' function"

; read config
if(!tag_config) {
    global tag_config
    log("loading tag config...")
    tag_config := StrObj("tags.yml")
    log(StrObj(tag_config), "tags")
}

; Determine to which tags `info` corresponds
; ------------------------------------------
; info is an object about the current program, including at minimum
; program_name and window_title, but also can contain additional properties
; such as `url` or `path`. Return: array of matching tags
getAutoTags(info) {
    local tags := []
    ;MsgBox % JSON.stringify(info)

    ; for each tag loaded from the config file
    ; -----------------------------------------
    ; tag - tag from loaded yml file
    ; tagKeys - program_name, path, etc
    For tag, tagKeys in tag_config

        ; go over each type of property (path, url, etc)
        ; ----------------------------------------------
        ; property - path | program_name | url ...
        ; tagValue - [ "a.exe", "b.exe" ] || "c:\\code"
        For property, value in tagKeys

            ; and check if the object we're checking has any such property
            if(info[property]) {

                ; if it's an array
                if(isObject(tag_config[tag][property])) {
                    MsgBox % "an object: " tag "[" property "]"
                    ; iterate
                    For index, regex in tag_config[tag][property]
                        if(RegExMatch(info[property], regex)) {
                            MsgBox % "found tag: " tag " for " info[property]
                            tags.insert(tag)
                        } else {
                            MsgBox % "no match: " info[property]
                        }
                ; string
                } else {
                    MsgBox % "an string: " tag "[" property "]"
                    pos := RegExMatch(info[property], tag_config[tag][property])
                    if(pos) {
                        MsgBox % "found tag: " tag " for " info[property]
                        tags.insert(tag)
                    }
                }
            }
    return tags
}
