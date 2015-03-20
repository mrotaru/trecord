# trecord
A script that records in which windows time is spent.

Generates a json file, like:

```json
{"duration":"0:00:01","end":"2014-12-02T09:46:48Z","path":"c:\\code\\trecord","program":"sh.exe","start":"2014-12-02T09:46:47Z","tags":["trecord"],"window_title":"MINGW32:\/c\/code\/trecord"}
{"duration":"0:00:02","end":"2015-01-01T11:35:15Z","program":"haroopad.exe","start":"2015-01-01T11:35:13Z","tags":{},"window_title":"README.md"}
{"duration":"0:00:03","end":"2015-01-01T11:35:18Z","program":"chrome.exe","start":"2015-01-01T11:35:15Z","tags":{},"url":"https:\/\/github.com\/mrotaru\/trecord","window_title":"mrotaru\/trecord \u00B7 GitHub - Google Chrome"}
{"duration":"0:00:01","end":"2015-01-01T11:35:20Z","program":"firefox.exe","start":"2015-01-01T11:35:19Z","tags":{},"window_title":"mrotaru (Mihai Rotaru) - Vimperator"}
```

Tags can be configured in a `tags.json` file:

```json
{
    "trecord": {
        "path": [
            "c:\\\\code\\\\trecord.*"
        ]
    },
    "news": {
        "url": [
            ".*bbc\\.co\\.uk.*"
        ]
    }
}
```
