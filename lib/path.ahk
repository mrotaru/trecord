getGvimPath(window_title) {
    regExp = (?<FileName>[^/:*?<>"|\s]+)\s(?:([^\w]\s)?)\((?<FolderName>(([a-zA-Z]\:)|(\\))(\\{1}|((\\{1})[^\\]([^/:*?<>"|]*))+))\)\ -\ GVIM($)
    FoundPos := RegExMatch(window_title, regExp, SubPat)
    return FoundPos ? SubPatFolderName . "\" . SubPatFileName : 0
}

getMinGWPath(window_title) {
    regExp = MINGW32:(?<CurrentDirectory>(\/[^<>:"/\|?*]+)+)
    FoundPos := RegExMatch(window_title, regExp, SubPat)
    if(FoundPos) {
        winCurrentDirectory := RegExReplace(SubPatCurrentDirectory,"^/([a-zA-Z])/","$1:/")
        winCurrentDirectory := RegExReplace(winCurrentDirectory,"/","\")
        return winCurrentDirectory
    } else {
        return 0
    }
}

; some programs require special instructions to obtain file name
;fref := Func("getGvimPath")
;debug_tray("a: " ["gvimexe"])
pathExtractPrograms := {}
pathExtractPrograms["gvim.exe"] := Func("getGvimPath")
pathExtractPrograms["sh.exe"] := Func("getMinGWPath")

; info - object with info about the program: program_name and window_title
isPath(info) {
    global pathExtractPrograms
    if(pathExtractPrograms.hasKey(info.program_name)) {
        return pathExtractPrograms[info.program_name].(info.window_title)
    } else {
        regExp = ((([a-zA-Z]\:)|(\\))(\\{1}|((\\{1})[^\\]([^/:*?<>"|]*))+))([\s]|$)
        FoundPos := RegExMatch(info.window_title, regExp, SubPat)
        return FoundPos ? SubPat : 0
    }
}
