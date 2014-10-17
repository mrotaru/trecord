getGvimPath(window_title) {
    regExp = (?<FileName>[^/:*?<>"|\s]+)\s(?:([^\w]\s)?)\((?<FolderName>(([a-zA-Z]\:)|(\\))(\\{1}|((\\{1})[^\\]([^/:*?<>"|]*))+))\)\ -\ GVIM($)

    ; pastable in www.regexr.com - with ahk-specific quotes removed
    ;regExp = ([^/:*?<>"|\s]+)\s(?:([^\w]\s)?)((([a-zA-Z]\:)|(\\))(\\{1}|((\\{1})[^\\]([^/:*?<>"|]*))+))($)

    FoundPos := RegExMatch(window_title, regExp, SubPat)
    debug("regex :" regExp)
    debug("found pattern :" FoundPos)
    debug("regex match: " SubPatFileName)
    debug("regex match: " SubPatFolderName)
    return FoundPos ? "CUStom " . SubPat : 0
}

; some programs require special instructions to obtain file name
fref := Func("getGvimPath")
;debug_tray("a: " ["gvimexe"])
pathExtractPrograms := { "gvim.exe": fref }

; info - object with info about the program: program_name and window_title
isPath(info) {
    global pathExtractPrograms
    regExp = ((([a-zA-Z]\:)|(\\))(\\{1}|((\\{1})[^\\]([^/:*?<>"|]*))+))([\s]|$)
            ;^(([a-zA-Z]\:)|(\\))(\\{1}|((\\{1})[^\\]([^/:*?<>"|]*))+)$
    if(pathExtractPrograms.hasKey(info.program_name)) {
        pathExtractPrograms[info.program_name].(info.window_title)
    } else {
        FoundPos := RegExMatch(info.window_title, regExp, SubPat)
        return FoundPos ? SubPat : 0
    }
}
