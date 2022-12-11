//
//  ErrorResponse.swift
//  Social Setting
//
//  Created by Mettaworldj on 9/7/22.
//

import Foundation

struct ErrorResponse: Decodable {
    let statusCode: Int
    let message: String
}
