; info - object with info about the program: program_name and window_title
isPath(info) {
    regExp = ((([a-zA-Z]\:)|(\\))(\\{1}|((\\{1})[^\\]([^/:*?<>"|]*))+))([\s]|$)
    FoundPos := RegExMatch(info.window_title, regExp, SubPat)
    return FoundPos ? SubPat : 0
}
