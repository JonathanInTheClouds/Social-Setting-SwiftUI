//
//  PostResponse.swift
//  Social Setting
//
//  Created by Mettaworldj on 12/11/22.
//

import Foundation

struct PostResponse: Codable, Hashable {
    let id: String
    let title: String
    let body: String
    let voteCount: Int
    let commentCount: Int
    let user: UserResponse
}
