//
//  SubSettingResponse.swift
//  Social Setting
//
//  Created by Mettaworldj on 12/11/22.
//

import Foundation

struct SubSettingResponse: Codable, Hashable {
    let id: String
    let name: String
    var isFavorite: Bool?
}
