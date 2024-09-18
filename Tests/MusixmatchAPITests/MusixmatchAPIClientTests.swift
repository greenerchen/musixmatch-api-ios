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
        await XCTAssertAsyncThrowError(try await client.get(url), "Expect to throw an error of exceedAPIRateLimit") { error in
            XCTAssert(error is MusixmatchAPIClient.Error)
        }
    }

    
    func test_trackSearch_expectDecodingSuccessfuly() async throws {
        let dataStub = try JSONEncoder().encode(trackSearchResponseStub)
        let client = MusixmatchAPIClient(session: MusixmatchAPISessionMock(getUrlResultStub: (dataStub, responseOKStub)))
        
        guard let track = try await client.searchTrack("track", artist: "artics").first else {
            XCTFail("Track not found")
            return
        }
        
        XCTAssertEqual(track.id, 100001, "trackId: \(track.id)")
        XCTAssertEqual(track.commontrackId, 200001, "commontrackId: \(track.commontrackId)")
        XCTAssertEqual(track.trackName, "Way Maker")
    }
    
    func test_trackSearch_expectDecodingFailed() async throws {
        let dataStub = try JSONEncoder().encode(trackGetResponseStub)
        let client = MusixmatchAPIClient(session: MusixmatchAPISessionMock(getUrlResultStub: (dataStub, responseOKStub)))
        
        await XCTAssertAsyncThrowError(try await client.searchTrack("track", artist: "artics").first)
    }
    
    func test_trackSearch_expectServerResponseFailed() async throws {
        let dataStub = try JSONEncoder().encode(generalOKMsgStub)
        let client = MusixmatchAPIClient(session: MusixmatchAPISessionMock(getUrlResultStub: (dataStub, response500Stub)))
        
        await XCTAssertAsyncThrowError(try await client.searchTrack("track", artist: "artics").first)
    }
    
    func test_trackGet_expectDecodingSuccessfuly() async throws {
        let dataStub = try JSONEncoder().encode(trackGetResponseStub)
        let client = MusixmatchAPIClient(session: MusixmatchAPISessionMock(getUrlResultStub: (dataStub, responseOKStub)))
        
        let track = try await client.getTrack(isrc: "ISRC")
        
        XCTAssertEqual(track.id, 100001, "trackId: \(track.id)")
        XCTAssertEqual(track.commontrackId, 200001, "commontrackId: \(track.commontrackId)")
        XCTAssertEqual(track.trackName, "Way Maker")
    }
    
    func test_trackGet_expectDecodingFailed() async throws {
        let dataStub = try JSONEncoder().encode(trackSearchResponseStub)
        let client = MusixmatchAPIClient(session: MusixmatchAPISessionMock(getUrlResultStub: (dataStub, responseOKStub)))
        
        await XCTAssertAsyncThrowError(try await client.getTrack(isrc: "UEME"))
    }
    
    func test_trackGet_expectServerResponseFailed() async throws {
        let dataStub = try JSONEncoder().encode(generalOKMsgStub)
        let client = MusixmatchAPIClient(session: MusixmatchAPISessionMock(getUrlResultStub: (dataStub, response500Stub)))
        
        await XCTAssertAsyncThrowError(try await client.getTrack(isrc: "UEME"))
    }
    
    func test_trackLyricsGet_getByTrackId_expectDecodingSuccessfuly() async throws {
        let dataStub = try JSONEncoder().encode(trackLyricsGetResponseStub)
        let client = MusixmatchAPIClient(session: MusixmatchAPISessionMock(getUrlResultStub: (dataStub, responseOKStub)))
        
        let lyrics = try await client.getLyrics(trackId: 1001)
        
        XCTAssertEqual(lyrics.id, 1001, "lyricsId: \(lyrics.id)")
        XCTAssertEqual(lyrics.body, "Heart beats fast", "lyricsBody: \(lyrics.body)")
    }
    
    func test_trackLyricsGet_getByISRC_expectDecodingSuccessfuly() async throws {
        let dataStub = try JSONEncoder().encode(trackLyricsGetResponseStub)
        let client = MusixmatchAPIClient(session: MusixmatchAPISessionMock(getUrlResultStub: (dataStub, responseOKStub)))
        
        let lyrics = try await client.getLyrics(isrc: "UMED23")
        
        XCTAssertEqual(lyrics.id, 1001, "lyricsId: \(lyrics.id)")
        XCTAssertEqual(lyrics.body, "Heart beats fast", "lyricsBody: \(lyrics.body)")
    }
    
    func test_trackLyricsGet_expectServerResponseFailed() async throws {
        let dataStub = try JSONEncoder().encode(generalOKMsgStub)
        let client = MusixmatchAPIClient(session: MusixmatchAPISessionMock(getUrlResultStub: (dataStub, response500Stub)))
        
        await XCTAssertAsyncThrowError(try await client.getLyrics(isrc: "UEME"))
    }
    
    func test_trackLyricsGet_expectDecodingFailed() async throws {
        let dataStub = try JSONEncoder().encode(trackSearchResponseStub)
        let client = MusixmatchAPIClient(session: MusixmatchAPISessionMock(getUrlResultStub: (dataStub, responseOKStub)))
        
        await XCTAssertAsyncThrowError(try await client.getLyrics(isrc: "UEME"))
    }
}
