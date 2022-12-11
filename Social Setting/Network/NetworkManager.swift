//
//  NetworkManager.swift
//  Social Setting
//
//  Created by Mettaworldj on 8/30/22.
//

import Foundation

protocol INetworkManager {
    func loadUnauthorized<T: Decodable>(
        _ urlRequest: URLRequest,
        decoder: JSONDecoder,
        allowRetry: Bool
    ) async throws -> T
    
    func loadAuthorized<T: Decodable>(
        _ url: URL,
        decoder: JSONDecoder,
        allowRetry: Bool
    ) async throws -> T
    
    func loadAuthorized<T: Decodable>(
        _ urlRequest: URLRequest,
        decoder: JSONDecoder,
        allowRetry: Bool
    ) async throws -> T
}

enum NetworkError: Error {
    case BadDecoding(data: Data)
}

class NetworkManager: INetworkManager {
    
    static let shared = NetworkManager(authManager: .init())
    
    let authManager: AuthManager
    
    init(authManager: AuthManager) {
        self.authManager = authManager
    }
    
    func loadUnauthorized<T: Decodable>(
        _ urlRequest: URLRequest,
        decoder: JSONDecoder = .social_setting_decoder,
        allowRetry: Bool = true
    ) async throws -> T {
        var urlRequest = urlRequest
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        return try decodeData(decoder, data)
    }
    
    func loadAuthorized<T: Decodable>(_ url: URL, decoder: JSONDecoder = .social_setting_decoder, allowRetry: Bool = true) async throws -> T {
        let request = try await authorizedRequest(from: url)
        let (data, urlResponse) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode == 401 {
            if allowRetry {
                _ = try await authManager.refreshToken()
                return try await loadAuthorized(url, allowRetry: false)
            }
            
            throw AuthManager.AuthError.InvalidToken
        }
        
        return try decodeData(decoder, data)
    }
    
    func loadAuthorized<T: Decodable>(
        _ urlRequest: URLRequest,
        decoder: JSONDecoder = .social_setting_decoder,
        allowRetry: Bool = true
    ) async throws -> T {
        let urlRequest = try await authorizedRequest(from: urlRequest)
        let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = urlResponse as? HTTPURLResponse, httpResponse.statusCode == 401 {
            if allowRetry {
                _ = try await authManager.refreshToken()
                return try await loadAuthorized(urlRequest, allowRetry: false)
            }
            
            throw AuthManager.AuthError.InvalidToken
        }
        
        return try decodeData(decoder, data)
    }
    
    private func authorizedRequest(from url: URL) async throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        let token = try await authManager.validToken()
        urlRequest.setValue("Bearer \(token.token)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
    
    private func authorizedRequest(from urlRequest: URLRequest) async throws -> URLRequest {
        var urlRequest = urlRequest
        let token = try await authManager.validToken()
        urlRequest.setValue("Bearer \(token.token)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return urlRequest
    }
    
    private func decodeData<T: Decodable>(_ decoder: JSONDecoder, _ data: Data) throws -> T {
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.BadDecoding(data: data)
        }
    }
}
