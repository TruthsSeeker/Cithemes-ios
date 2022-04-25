//
//  NetworkManager.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 22/04/2022.
//

import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func requestPublisher<T:Codable>(for request: URLRequest, decoding type: T.Type, withDecoder decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse else {
                    throw APIError.other
                }
                guard response.statusCode == 200 else {
                    throw APIError.httpError(response.statusCode)
                }
                
                return data
            }
            .decode(type: RootResponse<T>.self, decoder: decoder)
            .map { $0.result }
            .eraseToAnyPublisher()
    }
    
    private func requestPublisher<T: Codable>(for request: URLRequest, withToken token: String, decoding type: T.Type, withDecoder decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, Error> {
        var authRequest = request
        authRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return requestPublisher(for: authRequest, decoding: type, withDecoder: decoder)
        
    }
    
    func authenticatedRequestPublisher<T: Codable>(for request: URLRequest, decoding type: T.Type, withDecoder decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, Error> {
        
        return Authenticator().validToken()
            .flatMap { [self] tokens in
                return requestPublisher(for: request, withToken: tokens.$accessToken, decoding: type, withDecoder: decoder)
            }
            .eraseToAnyPublisher()
    }
}
