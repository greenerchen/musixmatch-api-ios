//
//  MusixmatchAPIClientTests.swift
//  
//
//  Created by Greener Chen on 2024/9/18.
//

import XCTest
@testable import MusixmatchAPI

final class MusixmatchAPIClientTests: XCTestCase {

    func test_get_givenAPIRateLimit1_when1RequestPerSecond_expectRequestSucceeded() async throws {
        let limitPerSecond = 1
        let client = MusixmatchAPIClient(apiLimitStrategy: RequestQueuesStrategy(limitPerSecond: limitPerSecond))
        
        let track = try await client.getTrack(isrc: "US25L1900253")
        
        XCTAssertEqual(track.trackName, "Way Maker - Live")
    }

    func test_get_givenAPIRateLimit1_when2RequestPerSecond_expectSecondRequestFailed() async throws {
        let limitPerSecond = 1
        let client = MusixmatchAPIClient(apiLimitStrategy: RequestQueuesStrategy(limitPerSecond: limitPerSecond))
        let apiKey = ProcessInfo().environment["MUSIXMATCH_APIKEY"]
        let isrc = "US25L1900253"
        let url = URL(string: "https://api.musixmatch.com/ws/1.1/")!
            .appending(path: "track.get")
            .appendingAuthentication(apiKey: apiKey)
            .appending(queryItems: [
                URLQueryItem(name: "track_isrc", value: String(data: isrc.data(using: .utf8) ?? Data(), encoding: .utf8))
                ])
        
        _ = try await client.get(url)
        await XCTAssertAsyncThrowError(try await client.get(url))
    }
}
