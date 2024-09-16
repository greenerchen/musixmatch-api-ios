//
//  RequestQueuesStrategyTests.swift
//  
//
//  Created by Greener Chen on 2024/9/16.
//

import XCTest
@testable import MusixmatchAPI

final class RequestQueuesStrategyTests: XCTestCase {

    func test_basicRateLimiting() {
        let limitPerSecond = 2
        let requests = ["1, 192.168.1.1, 1694865600",    // First request at second 0
                        "2, 192.168.1.1, 1694865600",    // Second request at second 0
                        "3, 192.168.1.1, 1694865601",    // First request at second 1
                        "4, 192.168.1.1, 1694865601"]    // Second request at second 1
        
        let rejectedRequestsIds: [Int] = RequestQueuesStrategy(limitPerSecond: limitPerSecond).getRejectedRequests(requests)
        
        XCTAssertEqual(rejectedRequestsIds.count, 0)
    }

    func test_exceedRateLimit() {
        let limitPerSecond = 2
        let requests = ["1, 192.168.1.1, 1694865600",    // First request at second 0
                        "2, 192.168.1.1, 1694865600",    // Second request at second 0
                        "3, 192.168.1.1, 1694865600",    // Third request at second 0 (rate limit exceeded)
                        "4, 192.168.1.1, 1694865600",    // Four request at second 0 (rate limit exceeded)
                        "5, 192.168.1.1, 1694865601"]    // First request at second 1
        
        let rejectedRequestsIds: [Int] = RequestQueuesStrategy(limitPerSecond: limitPerSecond).getRejectedRequests(requests)
        
        XCTAssertEqual(rejectedRequestsIds.count, 2)
        XCTAssertEqual(rejectedRequestsIds[0], 3)
        XCTAssertEqual(rejectedRequestsIds[1], 4)
    }

    func test_rateLimitReset() {
        let limitPerSecond = 2
        let requests = ["1, 192.168.1.1, 1694865600",    // First request at second 0
                        "2, 192.168.1.1, 1694865600",    // Second request at second 0
                        "3, 192.168.1.1, 1694865600",    // Third request at second 0 (rate limit exceeded)
                        "4, 192.168.1.1, 1694865602"]    // First request at second 2 (after reset)
        
        let rejectedRequestsIds: [Int] = RequestQueuesStrategy(limitPerSecond: limitPerSecond).getRejectedRequests(requests)
        
        XCTAssertEqual(rejectedRequestsIds.count, 1)
        XCTAssertEqual(rejectedRequestsIds[0], 3)
    }
    
    func test_rateLimitingPerIPAddress() {
        let limitPerSecond = 2
        let requests = ["1, 192.168.1.1, 1694865600",    // First request from 192.168.1.1 at second 0
                        "2, 192.168.1.1, 1694865600",    // Second request from 192.168.1.1 at second 0
                        "3, 192.168.1.1, 1694865600",    // Third request from 192.168.1.1 at second 0 (rate limit exceeded)
                        "1, 192.168.1.2, 1694865600",    // First request from 192.168.1.2 at second 0
                        "2, 192.168.1.2, 1694865600"]    // Second request from 192.168.1.2 at second 0

        let rejectedRequestsIds: [Int] = RequestQueuesStrategy(limitPerSecond: limitPerSecond).getRejectedRequests(requests)
        
        XCTAssertEqual(rejectedRequestsIds.count, 1)
        XCTAssertEqual(rejectedRequestsIds[0], 3)
    }
    
    func test_burstRequestHandling() {
        let limitPerSecond = 2
        let requests = ["1, 192.168.1.1, 1694865600",    // First request at second 0
                        "2, 192.168.1.1, 1694865600",    // Second request at second 0
                        "3, 192.168.1.1, 1694865600",    // Third request at second 0 (rate limit exceeded)
                        "4, 192.168.1.1, 1694865600",    // Four request at second 0 (rate limit exceeded)
                        "5, 192.168.1.1, 1694865600",    // Five request at second 0 (rate limit exceeded)
                        "6, 192.168.1.1, 1694865600",    // Six request at second 0 (rate limit exceeded)
                        "7, 192.168.1.1, 1694865600",    // Seven request at second 0 (rate limit exceeded)
                        "8, 192.168.1.1, 1694865601"]    // First request at second 1

        let rejectedRequestsIds: [Int] = RequestQueuesStrategy(limitPerSecond: limitPerSecond).getRejectedRequests(requests)
        
        XCTAssertEqual(rejectedRequestsIds.count, 5)
        XCTAssertEqual(rejectedRequestsIds[0], 3)
        XCTAssertEqual(rejectedRequestsIds[4], 7)
    }
}
