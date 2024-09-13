[![codecov](https://codecov.io/gh/greenerchen/musixmatch-api-ios/graph/badge.svg?token=H8LSDP6ADE)](https://codecov.io/gh/greenerchen/musixmatch-api-ios)

# musixmatch-api-ios
A Swift Package for searching lyrics using Musixmatch API

# Installation

MusixmatchAPI is packaged as a static Swift library.

## Support Swift Package Manager

```
let package = Package(
    name: "MyApp",
    dependencies: [
        .package(url: "git@github.com:greenerchen/musixmatch-api-ios.git",
            .upToNextMajor(from: "1.0.6"))
    ]
)
```

# How to
## Make A Request To Search Lyrics
Set the environment variable `MUSIXMATCH_APIKEY` before using this.

```
import MusixmatchAPI

let client = MusixmatchAPIClient()
let track = try await client.search("Lucky", artist: "Jason Mraz")
debugPrint("Artist name - \(track.trackArtist)")
debugPrint("Title - \(track.trackName)")
debugPrint("Track ID - \(track.id)")
let lyrics = try await client.getLyrics(trackId: track.id)
debugPrint(lyrics.body)
```

