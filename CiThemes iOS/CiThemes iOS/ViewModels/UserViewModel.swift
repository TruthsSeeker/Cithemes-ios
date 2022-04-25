//
//  UserViewModel.swift
//  CiThemes iOS
//
//  Created by Loïc Heinrich on 12/04/2022.
//

import Foundation
import Combine

final class UserViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var email: String = ""
    @Published var password: String = ""
    
    lazy var decoder:JSONDecoder = {
        var dcdr = JSONDecoder()
        dcdr.keyDecodingStrategy = .convertFromSnakeCase
        return dcdr
    }()
    
    
    private var signUpSubscription: AnyCancellable?
    private var loginSubscription: AnyCancellable?
}

extension UserViewModel {
    private func signUpSubscriber() -> AnyPublisher<User, Error> {
        guard let url = getUrl(for: "/auth/signup") else {
            return Result.failure(APIError.invalidURL).publisher.eraseToAnyPublisher()
        }
        guard !email.isEmpty && !password.isEmpty else {
            return Result.failure(APIError.other).publisher.eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        let encoded = try? JSONEncoder().encode(UserRequest(email: email, password: password))
        request.httpBody = encoded
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap({ data, response in
                guard let response = response as? HTTPURLResponse else {
                    throw APIError.other
                }
                guard response.statusCode == 200 else {
                    throw APIError.httpError(response.statusCode)
                }
                
                return data
            })
            .decode(type: RootResponse<User>.self, decoder: decoder)
            .map {$0.result}
            .eraseToAnyPublisher()
    }
    
    func signup(success: @escaping ()->() = {}) {
        signUpSubscription = signUpSubscriber()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { token in
                print(token)
                KeychainHelper.standard.save(token, service: .tokens, account: KeychainHelper.account)
                success()
            })
    }
}

extension UserViewModel {
    private func loginSubscriber() -> AnyPublisher<UserToken, Error> {
        guard let url = getUrl(for: "/auth/login") else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        guard !email.isEmpty && !password.isEmpty else {
            
            return Fail(error:APIError.other).eraseToAnyPublisher()
        }
        let encoded = try? JSONEncoder().encode(UserRequest(email: email, password: password))
        
        var request = URLRequest(url: url)
        request.httpBody = encoded
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap({ data, response in
                guard let response = response as? HTTPURLResponse else {
                    throw APIError.other
                }
                guard response.statusCode == 200 else {
                    throw APIError.httpError(response.statusCode)
                }
                
                return data
            })
            .decode(type: RootResponse<UserToken>.self, decoder: decoder)
            .map {$0.result}
            .eraseToAnyPublisher()
    }
    
    func login(success: @escaping ()->() = {}) {
        loginSubscription = loginSubscriber()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                print(error)
                
            }, receiveValue: { [self] tokens in
                print(tokens)
                KeychainHelper.standard.save(email, service: .email, account: KeychainHelper.account)
                KeychainHelper.standard.save(tokens.refreshToken.userId, service: .userId)
                KeychainHelper.standard.save(tokens, service: .tokens)
                success()
            })
    }
}

fileprivate struct UserRequest: Encodable {
    var email: String
    var password: String
}
