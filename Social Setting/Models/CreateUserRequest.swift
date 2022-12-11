//
//  CreateUserRequest.swift
//  Social Setting
//
//  Created by Mettaworldj on 9/6/22.
//

import Foundation

struct CreateUserRequest: Codable {
    let email: String
    let username: String
    let password: String
}
