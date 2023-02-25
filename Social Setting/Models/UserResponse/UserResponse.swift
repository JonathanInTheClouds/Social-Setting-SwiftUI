//
//  UserResponse.swift
//  Social Setting
//
//  Created by Mettaworldj on 9/6/22.
//

import Foundation

struct UserResponse: Codable, Hashable {
    let email: String
    let username: String
    let creationDate: Date
}
