//
//  Request.swift
//  Social Setting
//
//  Created by Mettaworldj on 9/7/22.
//

import Foundation

struct Request {
    let url: URL?
    let data: Data?
    let method: Method
    
    var urlRequest: URLRequest? {
        guard let url = url else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = data
        return urlRequest
    }
    
}

extension Request {
    
    enum Method: String {
        case GET, POST, PUT, DELETE
    }
    
}

enum EndPoint {
    case SignUp(data: Codable)
    case SignIn(data: Codable)
    
    var request: URLRequest? {
        switch self {
        case .SignUp(let data):
            let data = try? JSONEncoder().encode(data)
            guard let url = URL(string: "http://localhost:5293/user/signup") else { return nil }
            let request = Request(url: url, data: data, method: .POST)
            return request.urlRequest
        case .SignIn(data: let data):
            let data = try? JSONEncoder().encode(data)
            guard let url = URL(string: "http://localhost:5293/user/signin") else { return nil }
            let request = Request(url: url, data: data, method: .POST)
            return request.urlRequest
        }
    }
}
//guard let encodedData = try? JSONEncoder().encode(signUpObject) else { return }
//guard let url = URL(string: "http://localhost:5293/user/signin") else { return }
//var urlRequest = URLRequest(url: url)
//urlRequest.httpMethod = "POST"
//urlRequest.httpBody = encodedData
