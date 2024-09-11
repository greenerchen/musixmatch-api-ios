//
//  MusixmatchAPITests.swift
//  MusixmatchAPIClientTests
//
//  Created by Greener Chen on 2024/9/11.
//

import XCTest
@testable import MusixmatchAPIClient

final class MusixmatchAPITests: XCTestCase {

    func test_trackSearch_withArtistNamesAndTitle_getSongLyrics() async throws {
        let track = "A Thousand Years"
        let artist = "Christina Perri"
        let client = MusixmatchAPIClient()
        
        let tracklist = try await client.searchTrack(track, artist: artist)
        
        XCTAssertGreaterThan(tracklist.count, 0)
        guard let track = tracklist.first else {
            XCTFail("No track found")
            return
        }
        XCTAssertEqual(track.id, 274345545, "trackId: \(track.id)")
    }

    func test_trackSearch_withUnavailableArtistNamesAndTitle_getNoSongLyrics() async throws {
        let track = "A Thousand Years"
        let artist = "Christina Perri"
        let client = MusixmatchAPIClient()
        
        let tracklist = try await client.searchTrack(track, artist: artist)
        
        XCTAssertGreaterThan(tracklist.count, 0)
        guard let track = tracklist.first else {
            XCTFail("No track found")
            return
        }
        XCTAssertNotEqual(track.id, 274345545, "trackId: \(track.id)")
    }
    
    func test_trackLyricsGet_withTrackId_getLyrics() async throws {
        let trackId = 274345545
        let client = MusixmatchAPIClient()
        
        let lyrics = try await client.getLyrics(trackId: trackId)
        
        XCTAssertTrue(lyrics.body.contains("Heart beats fast"))
    }
}
