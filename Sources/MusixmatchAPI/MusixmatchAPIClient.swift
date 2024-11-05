//
//  MusixmatchAPIClient.swift
//  MusixmatchAPIClient
//
//  Created by Greener Chen on 2024/9/11.
//

import Foundation
import OSLog

public protocol URLSessionProtocol {
    func get(_ url: URL) async throws -> (data: Data, response: URLResponse)
}

extension URLSession: URLSessionProtocol {
    public func get(_ url: URL) async throws -> (data: Data, response: URLResponse) {
        try await data(from: url)
    }
}

public final class MusixmatchAPIClient {

    static let shared: MusixmatchAPIClient = MusixmatchAPIClient()
    
    public enum Error: Swift.Error, Equatable {
        case invalidServerResponse
        case invalidServerStatus(code: Int)
        case invalidAPIResponse(statusCode: Int)
        case decodingError
        case exceedAPIRateLimit
    }
    
    public enum StatusCode: Int {
        /// The request was successful.
        case OK = 200
        /// The request has bad syntax or was inherently impossible to satisfied./
        case BAD_SYNTAX = 400
        /// Authentication failed, probably because of invalid/missing API key.
        case AUTH_FAILED = 401
        /// The usage limit has been reached, either you exceeded per day requests limits or your balance is insufficient.
        case USAGE_LIMIT_REACHED = 402
        /// You are not authorized to perform this operation.
        case NOT_AUTHORIZED = 403
        /// The request resource was not found.
        case RESOURCE_NOT_FOUND = 404
        /// The request method was not found.
        case METHOD_NOT_FOUND = 405
        /// Ooops, something was wrong.
        case SERVER_WRONG = 500
        /// Musixmatch system is a bit busy at the moment and your request can't be satisfied.
        case SERVER_BUSY = 503
    }
    
    enum Method: String, RawRepresentable {
        case trackSearch = "track.search"
        case trackLyricsGet = "track.lyrics.get"
        case trackGet = "track.get"
    }
    
    private var operationQueue = OperationQueue()
    private var concurrentQueue = DispatchQueue(label: "com.greenerchen.musixmatchapi.networking", attributes: .concurrent)
    
    private var apiCallCount: Int = 0
    
    private var logger = InMemoryLogger()
    
    private var apiKey: String? = ProcessInfo().environment["MUSIXMATCH_APIKEY"]
    
    private var baseUrl: URL = URL(string: "https://api.musixmatch.com/ws/1.1/")!
    
    private let session: URLSessionProtocol
    
    private let apiLimitStrategy: APILimitStrategy
    
    public init(
        session: URLSessionProtocol = URLSession.shared,
        apiKey: String? = nil,
        apiLimitStrategy: APILimitStrategy = RequestQueuesStrategy(limitPerSecond: 1)
    ) {
        self.session = session
        self.apiLimitStrategy = apiLimitStrategy
        if let apiKey = apiKey {
            self.apiKey = apiKey
        }
    }
    
    // MARK: track.search
    
    public func searchTrack(_ track: String, artist: String) async throws -> [Track] {
        let url = baseUrl
            .appending(path: Method.trackSearch.rawValue)
            .appendingAuthentication(apiKey: apiKey)
            .appending(queryItems: [
                URLQueryItem(name: "q_track", value: String(data: track.data(using: .utf8) ?? Data(), encoding: .utf8)),
                URLQueryItem(name: "q_artist", value: String(data: artist.data(using: .utf8) ?? Data(), encoding: .utf8)),
        ])
        let (data, _) = try await get(url)
        
        guard let apiResponse = try? JSONDecoder().decode(TrackSearchResponse.self, from: data) else {
            throw Error.decodingError
        }
        
        return apiResponse.message.body.trackList.map { $0.track }
    }
    
    // MARK: track.get
    
    public func getTrack(isrc: String) async throws -> Track {
        let url = baseUrl
            .appending(path: Method.trackGet.rawValue)
            .appendingAuthentication(apiKey: apiKey)
            .appending(queryItems: [
                URLQueryItem(name: "track_isrc", value: String(data: isrc.data(using: .utf8) ?? Data(), encoding: .utf8))
        ])
        let (data, _) = try await get(url)
        
        guard let apiResponse = try? JSONDecoder().decode(TrackGetResponse.self, from: data) else {
            throw Error.decodingError
        }
        
        return apiResponse.message.body.track
    }
    
    // MARK: track.lyrics.get
    
    public func getLyrics(trackId: Int) async throws -> Lyrics {
        let url = baseUrl
            .appending(path: Method.trackLyricsGet.rawValue)
            .appendingAuthentication(apiKey: apiKey)
            .appending(queryItems: [
                URLQueryItem(name: "track_id", value: String(trackId)),
        ])
        let (data, _) = try await get(url)
        
        guard let apiResponse = try? JSONDecoder().decode(TrackLyricsGetResponse.self, from: data) else {
            throw Error.decodingError
        }
        
        return apiResponse.message.body.lyrics
    }
    
    public func getLyrics(isrc: String) async throws -> Lyrics {
        let url = baseUrl
            .appending(path: Method.trackLyricsGet.rawValue)
            .appendingAuthentication(apiKey: apiKey)
            .appending(queryItems: [
                URLQueryItem(name: "track_isrc", value: String(data: isrc.data(using: .utf8) ?? Data(), encoding: .utf8))
        ])
        let (data, _) = try await get(url)
        
        guard let apiResponse = try? JSONDecoder().decode(TrackLyricsGetResponse.self, from: data) else {
            throw Error.decodingError
        }
        
        return apiResponse.message.body.lyrics
    }
    
    
    func get(_ url: URL) async throws -> (data: Data, response: URLResponse) {
        // TODO: purge logs when it's become massive
        try concurrentQueue.sync {
            self.apiCallCount += 1
            let address = url.host() ?? "api.musixmatch.com"
            self.logger.log("\(self.apiCallCount), \(address), \(Date().timeIntervalSince1970)")
            
            let rejectedIds = apiLimitStrategy.getRejectedRequests(logger.messages)
            guard !rejectedIds.contains(apiCallCount) else {
                throw Error.exceedAPIRateLimit
            }
        }
        
        let (data, response) = try await session.get(url)
        
        if let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode != StatusCode.OK.rawValue {
            throw Error.invalidServerStatus(code: httpResponse.statusCode)
        }
        
        if let apiResponse = try? JSONDecoder().decode(GeneralResponse.self, from: data),
           apiResponse.message.header.statusCode != StatusCode.OK.rawValue {
            throw Error.invalidAPIResponse(statusCode: apiResponse.message.header.statusCode)
        }
        
        return (data, response)
    }
}

extension URL {
    func appendingAuthentication(apiKey: String?) -> URL {
        appending(queryItems: [URLQueryItem(name: "apikey", value: apiKey)])
    }
}
