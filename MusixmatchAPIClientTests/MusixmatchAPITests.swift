//
//  MusixmatchAPITests.swift
//  MusixmatchAPIClientTests
//
//  Created by Greener Chen on 2024/9/11.
//

import XCTest
@testable import MusixmatchAPIClient

final class MusixmatchAPITests: XCTestCase {
    
    func test_trackSearch_withArtistAndTitle_getCorrectTrack() async throws {
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
    
    func test_trackSearch_withWrongCombinationOfArtistAndTitle_getIncorrectTrack() async throws {
        let track = "A Thousand Years"
        let artist = "Taylor Swift"
        let client = MusixmatchAPIClient()
        
        let tracklist = try await client.searchTrack(track, artist: artist)
        
        XCTAssertGreaterThan(tracklist.count, 0)
        guard let track = tracklist.first else {
            XCTFail("No track found")
            return
        }
        XCTAssertNotEqual(track.id, 274345545, "trackId: \(track.id)") // Track: A Thousand Years
    }
    
    func test_trackSearch_withNonexistentTrack_getAlternativeTrack() async throws {
        let track = "One hour"
        let artist = "Ed Sheeran"
        let client = MusixmatchAPIClient()
        
        let tracklist = try await client.searchTrack(track, artist: artist)
        
        XCTAssertGreaterThan(tracklist.count, 0)
        guard let track = tracklist.first else {
            XCTFail("No track found")
            return
        }
        XCTAssertEqual(track.id, 107955257, "trackId: \(track.id) \(track.trackName)") // track: One day, one hour
    }
    
    func test_trackLyricsGet_withTrackId_getLyrics() async throws {
        let trackId = 274345545
        let client = MusixmatchAPIClient()
        
        let lyrics = try await client.getLyrics(trackId: trackId)
        
        XCTAssertTrue(lyrics.body.hasPrefix("Heart beats fast"))
    }
}
