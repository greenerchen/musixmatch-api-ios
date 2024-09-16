//
//  TrackGetResponse.swift
//  
//
//  Created by Greener Chen on 2024/9/16.
//

import Foundation

struct TrackGetResponse: Decodable {
    let message: TrackGetMessage
}

struct TrackGetMessage: Decodable {
    let header: ResponseMessageHeader
    let body: TrackGetBody
}

struct TrackGetBody: Decodable {
    let track: Track
    
    enum CodingKeys: String, CodingKey {
        case track = "track"
    }
}
