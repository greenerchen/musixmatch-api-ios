//
//  Track.swift
//  MusixmatchAPIClient
//
//  Created by Greener Chen on 2024/9/11.
//

import Foundation

public struct Track: Decodable {
    public let id: Int
    public let commontrackId: Int
    public let trackName: String
    public let artistName: String
    public let restricted: Bool
    public let explicit: Bool
    public let hasLyrics: Bool
    public let hasSubtitles: Bool
    public let lyricsId: Int?
    public let subtitleId: Int?
    public let lyricsBody: String?
    public let lyricsCopyright: String?
    public let backlinkUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "track_id"
        case commontrackId = "commontrack_id"
        case trackName = "track_name"
        case artistName = "artist_name"
        case restricted
        case explicit
        case hasLyrics = "has_lyrics"
        case hasSubtitles = "has_subtitles"
        case lyricsId = "lyrics_id"
        case subtitleId = "subtitle_id"
        case lyricsBody = "lyrics_body"
        case lyricsCopyright = "lyrics_copyright"
        case backlinkUrl = "track_share_url"
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.commontrackId = try container.decode(Int.self, forKey: .commontrackId)
        self.trackName = try container.decode(String.self, forKey: .trackName)
        self.artistName = try container.decode(String.self, forKey: .artistName)
        self.restricted = ((try container.decode(Int.self, forKey: .restricted)) != 0)
        self.explicit = ((try container.decode(Int.self, forKey: .explicit)) != 0)
        self.hasLyrics = ((try container.decode(Int.self, forKey: .hasLyrics)) != 0)
        self.hasSubtitles = ((try container.decode(Int.self, forKey: .hasSubtitles)) != 0)
        self.lyricsId = try container.decodeIfPresent(Int.self, forKey: .lyricsId)
        self.subtitleId = try container.decodeIfPresent(Int.self, forKey: .subtitleId)
        self.lyricsBody = try container.decodeIfPresent(String.self, forKey: .lyricsBody)
        self.lyricsCopyright = try container.decodeIfPresent(String.self, forKey: .lyricsCopyright)
        self.backlinkUrl = try container.decodeIfPresent(String.self, forKey: .backlinkUrl)
    }
    
    public init(
        id: Int,
        commontrackId: Int,
        trackName: String,
        artistName: String,
        restricted: Bool,
        explicit: Bool,
        hasLyrics: Bool,
        hasSubtitles: Bool,
        lyricsId: Int?,
        subtitleId: Int?,
        lyricsBody: String?,
        lyricsCopyright: String?,
        backlinkUrl: String?
    ) {
        self.id = id
        self.commontrackId = commontrackId
        self.trackName = trackName
        self.artistName = artistName
        self.restricted = restricted
        self.explicit = explicit
        self.hasLyrics = hasLyrics
        self.hasSubtitles = hasSubtitles
        self.lyricsId = lyricsId
        self.subtitleId = subtitleId
        self.lyricsBody = lyricsBody
        self.lyricsCopyright = lyricsCopyright
        self.backlinkUrl = backlinkUrl
    }
}

extension Track: Encodable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(commontrackId, forKey: .commontrackId)
        try container.encode(trackName, forKey: .trackName)
        try container.encode(artistName, forKey: .artistName)
        try container.encode(restricted ? 1 : 0, forKey: .restricted)
        try container.encode(explicit ? 1 : 0, forKey: .explicit)
        try container.encode(hasLyrics ? 1 : 0, forKey: .hasLyrics)
        try container.encode(hasSubtitles ? 1 : 0, forKey: .hasSubtitles)
        try container.encodeIfPresent(lyricsId, forKey: .lyricsId)
        try container.encodeIfPresent(subtitleId, forKey: .subtitleId)
        try container.encodeIfPresent(lyricsBody, forKey: .lyricsBody)
        try container.encodeIfPresent(lyricsCopyright, forKey: .lyricsCopyright)
        try container.encodeIfPresent(backlinkUrl, forKey: .backlinkUrl)
    }
}
