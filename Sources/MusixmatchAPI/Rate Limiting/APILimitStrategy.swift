//
//  File.swift
//  
//
//  Created by Greener Chen on 2024/9/16.
//

import Foundation

public protocol APILimitStrategy {
    func getRejectedRequests(_ requests: [String]) -> [Int]
}
