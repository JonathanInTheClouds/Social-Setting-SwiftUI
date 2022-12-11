//
//  Decoder+SocialSetting.swift
//  Social Setting
//
//  Created by Mettaworldj on 9/6/22.
//

import Foundation

extension JSONDecoder {
    static let social_setting_decoder: JSONDecoder = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
}
