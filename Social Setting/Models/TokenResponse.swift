//
//  TokenResponse.swift
//  Social Setting
//
//  Created by Mettaworldj on 8/30/22.
//

import Foundation
import KeychainAccess

struct TokenResponse: Codable {
    let token: String
    let refreshToken: String
    let expireDate: Date
    
    var isValid: Bool {
        return expireDate > Date()
    }
    
    func save() -> Bool {
        let keychain = Keychain(service: Bundle.main.bundleId)
        
        do {
            let data = try JSONEncoder().encode(self)
            
            try keychain
                .set(data, key: "Server-Token")
            
        } catch {
            return false
        }
        
        return true
    }
    
    static func load() -> TokenResponse? {
        let keychain = Keychain(service: Bundle.main.bundleId)
        guard let data = try? keychain.getData("Server-Token") else { return nil }
        return try? JSONDecoder().decode(TokenResponse.self, from: data)
    }
}
