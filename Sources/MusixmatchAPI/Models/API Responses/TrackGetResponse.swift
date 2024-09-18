//
//  TrackGetResponse.swift
//  
//
//  Created by Greener Chen on 2024/9/16.
//

import Foundation

struct TrackGetResponse: Codable {
    let message: TrackGetMessage
}

struct TrackGetMessage: Codable {
    let header: ResponseMessageHeader
    let body: TrackGetBody
}

struct TrackGetBody: Codable {
    let track: Track
    
    enum CodingKeys: String, CodingKey {
        case track = "track"
    }
}
