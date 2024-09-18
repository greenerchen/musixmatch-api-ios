//
//  RequestQueuesStrategy.swift
//
//
//  Created by Greener Chen on 2024/9/16.
//

import Foundation

/// `getRejectedRequests` is to compute requests in the queue and return rejected requests
///
/// Parameters:
/// - `requests` is a list of request string containing `request_id`, `ip_address` and `unix-type timestamp` ordered by timestamp
/// - `limitPerSecond` is an integer of requests limit per seconds
///
/// Returns:
/// A list of rejected request IDs in chronorical order as same as they appear in input
public struct RequestQueuesStrategy: APILimitStrategy {
    let limitPerSecond: Int
    
    public init(limitPerSecond: Int) {
        self.limitPerSecond = limitPerSecond
    }
    
    public func getRejectedRequests(_ requests: [String]) -> [Int] {
        var rejectedRequestIds: [Int] = []
        var requestTimesMap: [String:Int] = [:]
        var lastRequestTimestampMap: [String:TimeInterval] = [:]
        for r in requests {
            guard let request = Request(requestString: r) else { continue }
            if let requestTimes = requestTimesMap[request.ipAddress],
               let lastRequestTimestamp = lastRequestTimestampMap[request.ipAddress],
                Int(request.timestamp) == Int(lastRequestTimestamp) {
                requestTimesMap[request.ipAddress]! += 1
                if requestTimes >= limitPerSecond {
                    rejectedRequestIds.append(request.id)
                }
            } else {
                requestTimesMap[request.ipAddress] = 1
                lastRequestTimestampMap[request.ipAddress] = request.timestamp
            }
        }
        return rejectedRequestIds
    }
    
}

struct Request: Decodable {
    let id: Int
    let ipAddress: String
    let timestamp: TimeInterval
    
    init?(requestString: String) {
        let items = requestString.split(separator: ", ")
        guard items.count == 3 else { return nil }
        if let id = Int(items[0]),
           let timestamp = TimeInterval(items[2])
        {
            self.id = id
            let ipAddress = String(items[1])
            self.ipAddress = ipAddress
            self.timestamp = timestamp
        } else {
            return nil
        }
    }
}
