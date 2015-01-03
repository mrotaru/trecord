; includes
#include %A_ScriptDir%/lib
#include set-timer-f.ahk
#include path.ahk
#include utils.ahk
#include string-object.ahk
#include tags.ahk
#include vendor/json.ahk


;info := {duration: "0:00:03"}
info := {"duration":"0:00:01","end":"2014-12-02T09:46:48Z","path":"c:\\code\\trecord","program":"sh.exe","start":"2014-12-02T09:46:47Z","window_title":"MINGW32:\/c\/code\/trecord"}
tags := getAutoTags(info)
MsgBox % StrObj(tags)
