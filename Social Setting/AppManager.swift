//
//  AppManager.swift
//  Social Setting
//
//  Created by Mettaworldj on 11/26/22.
//

import Foundation
import Combine
import KeychainAccess

class AppManager: ObservableObject {
    static let Authenticated = PassthroughSubject<Bool, Never>()
    
    static func IsAuthenticated() -> Bool {
        return TokenResponse.load() != nil
    }
    
    static func logout() -> TokenResponse? {
        Authenticated.send(false)
        return TokenResponse.remove()
    }
}
