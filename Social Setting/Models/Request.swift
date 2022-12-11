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
        guard let url = URL(string: "http://localhost:5293/user/signin") else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = data
        return urlRequest
    }
    
}

enum Method: String {
case GET, POST, PUT, DELETE
}

//guard let encodedData = try? JSONEncoder().encode(signUpObject) else { return }
//guard let url = URL(string: "http://localhost:5293/user/signin") else { return }
//var urlRequest = URLRequest(url: url)
//urlRequest.httpMethod = "POST"
//urlRequest.httpBody = encodedData
