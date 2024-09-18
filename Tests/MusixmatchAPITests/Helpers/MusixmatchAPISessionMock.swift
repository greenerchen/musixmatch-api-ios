//
//  MusixmatchAPISessionMock.swift
//  
//
//  Created by Greener Chen on 2024/9/18.
//

import Foundation
@testable import MusixmatchAPI

final class MusixmatchAPISessionMock: URLSessionProtocol {
    
    var getUrlCallCount: Int = 0
    
    var getUrlResultStub: (data: Data, response: URLResponse)
    
    init(getUrlResultStub: (data: Data, response: URLResponse)) {
        self.getUrlResultStub = getUrlResultStub
    }
    
    func get(_ url: URL) async throws -> (data: Data, response: URLResponse) {
        getUrlCallCount += 1
        return getUrlResultStub
    }
}
