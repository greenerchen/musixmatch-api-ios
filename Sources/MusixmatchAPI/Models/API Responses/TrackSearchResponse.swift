//
//  TrackSearchResponse.swift
//  MusixmatchAPIClient
//
//  Created by Greener Chen on 2024/9/11.
//

import Foundation

struct TrackSearchResponse: Codable {
    let message: TrackSearchMessage
}

struct TrackSearchMessage: Codable {
    let header: ResponseMessageHeader
    let body: TrackSearchBody
}

struct TrackSearchBody: Codable {
    let trackList: [TrackItem]
    
    enum CodingKeys: String, CodingKey {
        case trackList = "track_list"
    }
}

struct TrackItem: Codable {
    let track: Track
}
