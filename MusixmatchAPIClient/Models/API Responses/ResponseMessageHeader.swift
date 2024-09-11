//
//  ResponseMessageHeader.swift
//  MusixmatchAPIClient
//
//  Created by Greener Chen on 2024/9/11.
//

import Foundation

struct ResponseMessageHeader: Decodable {
    let statusCode: Int
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
    }
}
