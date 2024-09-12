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
}
