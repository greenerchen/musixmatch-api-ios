//
//  TrackLyricsGetResponse.swift
//  MusixmatchAPIClient
//
//  Created by Greener Chen on 2024/9/11.
//

import Foundation

struct TrackLyricsGetResponse: Decodable {
    let message: TrackLyricsGetMessage
}

struct TrackLyricsGetMessage: Decodable {
    let header: ResponseMessageHeader
    let body: TrackLyricsBody
}

struct TrackLyricsBody: Decodable {
    let lyrics: Lyrics
}
