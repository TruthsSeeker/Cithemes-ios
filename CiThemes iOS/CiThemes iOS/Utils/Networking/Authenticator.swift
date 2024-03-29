//
//  Authenticator.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 20/04/2022.
//

import Foundation
import Combine

class Authenticator {
    private let session: URLSession
    private var userTokens: UserToken?
    private let queue = DispatchQueue(label: "Authenticator.\(UUID().uuidString)")
    
    private var refreshPublisher: AnyPublisher<UserToken, Error>?
    
    init(_ session: URLSession = URLSession.shared) {
        self.session = session
        if let data = KeychainHelper.standard.read(service: .tokens, type: UserToken.self) {
            print(data.$accessToken, data.$refreshToken)
            userTokens = data 
        }
    }
    
    func validToken() -> AnyPublisher<UserToken, Error> {
        return queue.sync { [weak self] in
            if let publisher = self?.refreshPublisher {
                return publisher
            }
            
            guard let token = userTokens else {
                return Fail(error: APIError.loginRequired).eraseToAnyPublisher()
            }
            
            if token.accessToken.isValid() {
                return Just(token)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            
            
            guard let url = URL.getUrl(for: "/auth/refresh") else {
                return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
            }
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token.$refreshToken)", forHTTPHeaderField: "Authorization")
            
            return session.dataTaskPublisher(for: request)
                .tryMap { data, response in
                    guard let response = response as? HTTPURLResponse else { throw APIError.other }
                    guard response.statusCode == 200 else {
                        if response.statusCode == 401 {
                            throw APIError.invalidAuth
                        }
                        throw APIError.httpError(response.statusCode)
                    }
                    return data
                }
                .decode(type: RootResponse<UserToken>.self, decoder: JSONDecoder())
                .map(\.result)
                .handleEvents(receiveOutput: { tokens in
                    KeychainHelper.standard.save(tokens, service: .tokens)
                }, receiveCompletion: { completion in
                    self?.refreshPublisher = nil
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        #if DEBUG
                        print(error)
                        #endif
                        break
                    }
                })
                .eraseToAnyPublisher()
        }
    }
}
