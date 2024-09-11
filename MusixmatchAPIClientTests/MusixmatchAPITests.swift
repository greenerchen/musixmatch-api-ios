//
//  MusixmatchAPITests.swift
//  MusixmatchAPIClientTests
//
//  Created by Greener Chen on 2024/9/11.
//

import XCTest
@testable import MusixmatchAPIClient

final class MusixmatchAPITests: XCTestCase {

    func test_search_withArtistNamesAndTitle_getSongLyrics() async throws {
        let track = "A Thousand Years"
        let artist = "Christina Perri"
        let client = MusixmatchAPIClient()
        
        let tracklist = try await client.searchTrack(track, artist: artist)
        
        XCTAssertGreaterThan(tracklist.count, 0)
        guard let track = tracklist.first else {
            XCTFail("No track found")
            return
        }
        XCTAssertEqual(track.commontrackId, 10074988, "commontrackId: \(track.commontrackId)")
    }

}
