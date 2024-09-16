//
//  GeneralResponse.swift
//
//
//  Created by Greener Chen on 2024/9/16.
//

import Foundation

struct GeneralResponse: Decodable {
    let message: GeneralMessage
}

struct GeneralMessage: Decodable {
    let header: ResponseMessageHeader
}
