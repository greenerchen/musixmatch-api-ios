//
//  MusixmatchAPIClient.swift
//  MusixmatchAPIClient
//
//  Created by Greener Chen on 2024/9/11.
//

import Foundation

public final class MusixmatchAPIClient {

    public enum Error: Swift.Error {
        case invalidServerResponse
        case invalidServerStatus(code: Int)
        case invalidAPIResponse(statusCode: Int)
        case decodingError
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
    }
    
    private var apiKey: String? = ProcessInfo().environment["MUSIXMATCH_APIKEY"]
    
    private var baseUrl: URL = URL(string: "https://api.musixmatch.com/ws/1.1/")!
    
    private let session: URLSession
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    @available(iOS 16.0, *)
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
        
        guard apiResponse.message.header.statusCode == StatusCode.OK.rawValue else {
            throw Error.invalidAPIResponse(statusCode: apiResponse.message.header.statusCode)
        }
        
        return apiResponse.message.body.trackList.map { $0.track }
    }
    
    @available(iOS 16.0, *)
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
        
        guard apiResponse.message.header.statusCode == StatusCode.OK.rawValue else {
            throw Error.invalidAPIResponse(statusCode: apiResponse.message.header.statusCode)
        }
        
        return apiResponse.message.body.lyrics
    }
    
    @available(iOS 15.0, *)
    func get(_ url: URL) async throws -> (data: Data, response: URLResponse) {
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw Error.invalidServerResponse
        }
        guard httpResponse.statusCode == StatusCode.OK.rawValue else {
            throw Error.invalidServerStatus(code: httpResponse.statusCode)
        }
        
        return (data, response)
    }
}

extension URL {
    @available(iOS 16.0, *)
    func appendingAuthentication(apiKey: String?) -> URL {
        appending(queryItems: [URLQueryItem(name: "apikey", value: apiKey)])
    }
}
