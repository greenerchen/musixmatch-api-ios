//
//  GeneralResponse.swift
//
//
//  Created by Greener Chen on 2024/9/16.
//

import Foundation

struct GeneralResponse: Codable {
    let message: GeneralMessage
}

struct GeneralMessage: Codable {
    let header: ResponseMessageHeader
}
