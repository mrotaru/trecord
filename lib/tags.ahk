; check dependecies
;IsFunc("SetTimerF") ? continue : MsgBox "Should have 'SetTimerF' function"
;IsFunc("StrObj")    ? continue : MsgBox "Should have 'StrObj' function"

; read tags into `tag_config`
; The file is formatted as yml, with 3 levels of indentation. Example:
; trecord: # tagName
;	  path: # tagProps (1+)
;		  - c:\\code\\trecord* # tagPropValue
; 
if(!tag_config) {
    global tag_config
    log("loading tag config...")
    FileRead, tags_str, tags.json
    tag_config := JSON.parse(tags_str)
    log(tag_config)
}

; Determine to which tags `info` corresponds
; ------------------------------------------
; info is an object about the current program, including at minimum
; program_name and window_title, but also can contain additional properties
; such as `url` or `path`. Return: array of matching tags
;
; This function checks the `info` object against each 
getAutoTags(info) {
    local tags := []
    log("parsing tags for:")
    log(JSON.stringify(info))

    ; for each tag loaded from the config file
    ; -----------------------------------------
    ; tagName - tagName from loaded yml file
    ; tagKeys - program_name, path, etc
    For tagName, tagProps in tag_config

        ; go over each type of property (path, url, etc)
        ; ----------------------------------------------
        ; tagProp - path | program_name | url ...
        ; tagPropValue - [ "a.exe", "b.exe" ] || "c:\\code"
        For tagProp, tagPropValue in tagProps

            log("iterating: " . tagProp . " - " . tagPropValue)

            ; and check if the object we're checking has any such property
            if(info[tagProp]) {

                ; if it's an array
                if(isObject(tag_config[tagName][tagProp])) {
                    log("an object: " . tagName . "[" . tagProp . "]")
                    ; iterate
                    For index, regex in tag_config[tagName][tagProp]
                        log("testing regex: " . regex . " against: " . info[tagProp])
                        if(RegExMatch(info[tagProp], regex)) {
                            log("--- match FOUND ---")
                            tags.insert(tagName)
                        } else {
                            log("no match")
                        }
                ; string
                } else {
                    log("a string: " . tagName . "[" . tagProp . "]")
                    pos := RegExMatch(info[tagProp], tag_config[tagName][tagProp])
                    if(pos) {
                        log("found tagName: " . tagName . " for " . info[property])
                        tags.insert(tagName)
                    }
                }
            }
    return tags
}
