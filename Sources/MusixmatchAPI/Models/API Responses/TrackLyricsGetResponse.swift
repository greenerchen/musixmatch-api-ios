//
//  TrackLyricsGetResponse.swift
//  MusixmatchAPIClient
//
//  Created by Greener Chen on 2024/9/11.
//

import Foundation

struct TrackLyricsGetResponse: Codable {
    let message: TrackLyricsGetMessage
}

struct TrackLyricsGetMessage: Codable {
    let header: ResponseMessageHeader
    let body: TrackLyricsBody
}

struct TrackLyricsBody: Codable {
    let lyrics: Lyrics
}
