//
//  InMemoryLogger.swift
//
//
//  Created by Greener Chen on 2024/9/17.
//

import Foundation

struct InMemoryLogger {
    var messages: [String] = []
    
    mutating func log(_ message: String) {
        messages.append(message)
    }
}
