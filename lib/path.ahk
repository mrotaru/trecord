getGvimPath(program_title) {
    pRegExp = ([^/:*?<>""|\s]+)\s(?:([^\w]\s)?)((([a-zA-Z]\:)|(\\))(\\{1}|((\\{1})[^\\]([^/:*?<>"|]*))+))($)
    FoundPos := RegExMatch(info.window_title, pRegExp, SubPat)
    return FoundPos ? "CUStom " . SubPat : 0
}

; some programs require special instructions to obtain file name
fref := Func("getGvimPath")
;debug_tray("a: " ["gvimexe"])
pathExtractPrograms := { "gvim.exe": 22 }

; info - object with info about the program: program_name and window_title
isPath(info) {
    global pathExtractPrograms
    regExp = ((([a-zA-Z]\:)|(\\))(\\{1}|((\\{1})[^\\]([^/:*?<>"|]*))+))([\s]|$)
            ;^(([a-zA-Z]\:)|(\\))(\\{1}|((\\{1})[^\\]([^/:*?<>"|]*))+)$
    debug_tray("a: " pathExtractPrograms["gvim.exe"])
    if(pathExtractPrograms.hasKey(info.program_name)) {
        debug_tray("have key")
        return pathExtractPrograms[info.program_name](info.window_title)
    } else {
        FoundPos := RegExMatch(info.window_title, regExp, SubPat)
        return FoundPos ? SubPat : 0
    }
}
