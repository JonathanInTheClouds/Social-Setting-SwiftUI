//
//  LogInUserRequest.swift
//  Social Setting
//
//  Created by Mettaworldj on 9/6/22.
//

import Foundation

struct LogInUserRequest: Codable {
    let username: String
    let password: String
    
    func isValid() throws {
        if username.isEmpty {
            throw InputError.NameRequired
        }
        
        if password.isEmpty {
            throw InputError.PasswordRequired
        }
        
        let passwordRegex = "^(?=.*[A-Z].*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8}$"
        if !NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password) {
            throw InputError.PasswordInvalid
        }
    }
}
