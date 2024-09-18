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
    
    init(
        id: Int,
        explicit: Bool,
        body: String,
        scriptTrackingUrl: String,
        copyright: String
    ) {
        self.id = id
        self.explicit = explicit
        self.body = body
        self.scriptTrackingUrl = scriptTrackingUrl
        self.copyright = copyright
    }
}

extension Lyrics: Encodable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(explicit ? 1 : 0, forKey: .explicit)
        try container.encode(body, forKey: .body)
        try container.encode(scriptTrackingUrl, forKey: .scriptTrackingUrl)
        try container.encode(copyright, forKey: .copyright)
    }
}
