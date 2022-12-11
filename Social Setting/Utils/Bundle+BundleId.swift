//
//  Bundle.swift
//  Social Setting
//
//  Created by Mettaworldj on 9/13/22.
//

import Foundation

extension Bundle {
    var bundleId: String {
        return Bundle.main.bundleIdentifier ?? "com.example.app"
    }
}
