//
//  AuthManager.swift
//  Social Setting
//
//  Created by Mettaworldj on 8/30/22.
//

import Foundation
import KeychainAccess

actor AuthManager {
    private var refreshTask: Task<TokenResponse, Error>?
    private var currentToken: TokenResponse? {
        return TokenResponse.load()
    }
    
    private var encoder = JSONEncoder()
    private var decoder = JSONDecoder()
    
    func validToken() async throws -> TokenResponse {
        if let handle = refreshTask {
            return try await handle.value
        }
        
        guard let token = currentToken else {
            throw AuthError.MissingToken
        }
        
        if token.isValid {
            return token
        }
        
        return try await refreshToken()
    }
    
    func refreshToken() async throws -> TokenResponse {
        if let refreshTask = refreshTask {
            return try await refreshTask.value
        }
        
        let task = Task { () throws -> TokenResponse in
            defer { refreshTask = nil }
            guard let url = URL(string: "http://localhost:5293/token/refresh") else { throw AuthError.BadURL }
            var urlRequest = URLRequest(url: url)
            guard let currentToken = currentToken else { throw AuthError.MissingToken }
            let encodedData = try? encoder.encode(RefreshTokenRequest(refreshToken: currentToken.refreshToken))
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = encodedData
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let resp = response as? HTTPURLResponse, resp.statusCode == 200 else { throw AuthError.BadResponse }
            guard let newToken = try? JSONDecoder.social_setting_decoder.decode(TokenResponse.self, from: data) else { throw AuthError.MissingToken }
            guard newToken.save() == true else { throw AuthError.UnsavedToken }
            return newToken
        }
        
        self.refreshTask = task
        
        return try await task.value
    }
}

extension AuthManager {
    enum AuthError: Error {
    case MissingToken, BadURL, BadResponse, BadEncoding, InvalidToken, UnsavedToken
    }
}
