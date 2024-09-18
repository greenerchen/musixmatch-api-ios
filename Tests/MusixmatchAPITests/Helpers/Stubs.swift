//
//  File.swift
//  
//
//  Created by Greener Chen on 2024/9/18.
//

import Foundation
@testable import MusixmatchAPI

let trackStub = Track(
    id: 100001,
    commontrackId: 200001,
    trackName: "Way Maker",
    artistName: "Leeland",
    restricted: false,
    explicit: false,
    hasLyrics: true,
    hasSubtitles: true,
    lyricsId: 123456,
    subtitleId: 234567,
    lyricsBody: "You are here, moving in our midst",
    lyricsCopyright: "Copyright",
    backlinkUrl: "link")

let trackItemStub = TrackItem(track: trackStub)
let trackSearchBodyStub = TrackSearchBody(trackList: [trackItemStub])
let trackSearchMsgSub = TrackSearchMessage(header: ResponseMessageHeader(statusCode: 200), body: trackSearchBodyStub)
let trackSearchResponseStub = TrackSearchResponse(message: trackSearchMsgSub)

let trackGetBodyStub = TrackGetBody(track: trackStub)
let trackGetMsgStub = TrackGetMessage(header: ResponseMessageHeader(statusCode: 200), body: trackGetBodyStub)
let trackGetResponseStub = TrackGetResponse(message: trackGetMsgStub)

let responseOKStub = HTTPURLResponse(
    url: URL(string: "https://anyurl.com")!,
    statusCode: 200,
    httpVersion: "1.1",
    headerFields: nil
)!

let response500Stub = HTTPURLResponse(
    url: URL(string: "https://anyurl.com")!,
    statusCode: 500,
    httpVersion: "1.1",
    headerFields: nil
)!

let lyricsStub = Lyrics(
    id: 1001,
    explicit: false,
    body: "Heart beats fast",
    scriptTrackingUrl: "http://a.com",
    copyright: "Copyright powered by musixmatch"
)

let trackLyricsGetMsg = TrackLyricsGetMessage(header: ResponseMessageHeader(statusCode: 200), body: TrackLyricsBody(lyrics: lyricsStub))
let trackLyricsGetResponseStub = TrackLyricsGetResponse(message: trackLyricsGetMsg)

let generalOKMsgStub = GeneralMessage(header: ResponseMessageHeader(statusCode: 200))
let generalOKResponseStub = GeneralResponse(message: generalOKMsgStub)
