//
//  TrackSearchResponse.swift
//  MusixmatchAPIClient
//
//  Created by Greener Chen on 2024/9/11.
//

import Foundation

struct TrackSearchResponse: Decodable {
    let message: TrackSearchMessage
}

struct TrackSearchMessage: Decodable {
    let header: ResponseMessageHeader
    let body: TrackSearchBody
}

struct TrackSearchBody: Decodable {
    let trackList: [TrackItem]
    
    enum CodingKeys: String, CodingKey {
        case trackList = "track_list"
    }
}

struct TrackItem: Decodable {
    let track: Track
}
