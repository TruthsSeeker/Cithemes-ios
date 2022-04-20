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
    @JWT private var accessToken: AccessToken?
    private let queue = DispatchQueue(label: "Authenticator.\(UUID().uuidString)")
    
    private var refreshPublisher: AnyPublisher<AccessToken, Error>?
    
    init(_ session: URLSession = URLSession.shared) {
        self.session = session
        if let data = KeychainHelper.standard.read(service: .tokens, type: String.self)?.data(using: .utf8),
           let token = try? JSONDecoder().decode(AccessToken.self, from: data){
            accessToken = token
        }
    }
    
    func validToken() -> AnyPublisher<AccessToken, Error> {
        return queue.sync { [weak self] in
            if let publisher = self?.refreshPublisher {
                return publisher
            }
            
            guard let token = accessToken else {
                return Fail(error: AuthenticationError.loginRequired).eraseToAnyPublisher()
            }
            
            if token.isValid() {
                return Just(token)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            
            guard let url = getURL(path: "/auth/refresh") else {
                return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
            }
            var request = URLRequest(url: url)
            request.setValue("Bearer \($accessToken)", forHTTPHeaderField: "Authorization")
            
            return session.dataTaskPublisher(for: request)
                .tryMap { data, response in
                    guard let response = response as? HTTPURLResponse else { throw APIError.other }
                    guard response.statusCode == 200 else {
                        throw APIError.httpError(response.statusCode)
                    }
                    return data
                }
                .decode(type: RootResponse<UserToken>.self, decoder: JSONDecoder())
                .map(\.result)
                .handleEvents(receiveOutput: { tokens in
                    KeychainHelper.standard.save(tokens.accessToken, service: .tokens)
                }, receiveCompletion: { completion in
                    self?.refreshPublisher = nil
                })
                .map(\.accessToken)
                .eraseToAnyPublisher()
            
            
        }
    }
    
    private func getURL(path: String) -> URL? {
        guard let listPath = Bundle.main.url(forResource: "env", withExtension: "plist") else { return nil }
        do {
            let listData = try Data(contentsOf: listPath)
            if let dict = try PropertyListSerialization.propertyList(from: listData, options: [], format: nil) as? [String:String] {
                var root: String = ""
                #if DEBUG
                root = dict["devUrl"] ?? ""
                #else
                root = dict["liveUrl"] ?? ""
                #endif
                return URL(string:root + path)
            }
        } catch { return nil }
        return nil
    }
}


enum AuthenticationError: Error {
    case loginRequired
}
