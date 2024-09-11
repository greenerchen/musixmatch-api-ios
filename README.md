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
            .upToNextMajor(from: "1.0.0"))
    ]
)
```

# How to
## Make A Request To Search Lyrics

```
import Combine
import MusixmatchAPI

var store = Set<AnyCancellable>()
let client = MusixmatchAPIClient()
                                
client.search("Lucky", artist: "Jason Mraz")
    .receive(on: DispatchQueue.main)
    .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
            debugPrint("Search failed - \(error.localizedDescription)")
        default:
            break
        }
    }, receiveValue: { track in
        debugPrint("Artist name - \(track.artistArtist)")
        debugPrint("Title - \(track.trackName)")
        debugPrint("Lyrics - \(track.lyricsBody)")
    })
    .store(in: &store)
```

