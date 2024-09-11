//
//  Lyrics.swift
//  MusixmatchAPIClient
//
//  Created by Greener Chen on 2024/9/11.
//

import Foundation

public struct Lyrics: Decodable {
    public let id: Int
    public let explicit: Bool
    public let body: String
    public let scriptTrackingUrl: String
    public let copyright: String

    enum CodingKeys: String, CodingKey {
        case id = "lyrics_id"
        case explicit
        case body = "lyrics_body"
        case scriptTrackingUrl = "script_tracking_url"
        case copyright = "lyrics_copyright"
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.explicit = ((try container.decode(Int.self, forKey: .explicit)) != 0)
        self.body = try container.decode(String.self, forKey: .body)
        self.scriptTrackingUrl = try container.decode(String.self, forKey: .scriptTrackingUrl)
        self.copyright = try container.decode(String.self, forKey: .copyright)
    }
}
