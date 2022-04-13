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
    
    private var signUpSubscription: AnyCancellable?
    private var loginSubscription: AnyCancellable?
}

extension UserViewModel {
    private func signUpSubscriber() -> AnyPublisher<User, URLError> {
        guard let url = getUrl(for: "/auth/signup") else {
            return Result.failure(URLError(.badURL)).publisher.eraseToAnyPublisher()
        }
        guard !email.isEmpty && !password.isEmpty else {
            return Result.failure(URLError(.userAuthenticationRequired)).publisher.eraseToAnyPublisher()
        }
        var request = URLRequest(url: url)
        let encoded = try? JSONEncoder().encode(UserRequest(email: email, password: password))
        request.httpBody = encoded
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return URLSession.shared.dataTaskPublisher(for: request)
            .map{ data, response in
                guard let decoded = try? JSONDecoder().decode(RootResponse<User>.self, from: data) else {return User(id: -1, email: "")}
                        
                return decoded.result
            }
            .eraseToAnyPublisher()
    }
    
    func signup() {
        signUpSubscription = signUpSubscriber()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { token in
                print(token)
                KeychainHelper.standard.save(token, service: KeychainHelper.service, account: KeychainHelper.account)
            })
    }
}

extension UserViewModel {
    private func loginSubscriber() -> AnyPublisher<User, URLError> {
        guard let url = getUrl(for: "/auth/login") else {
            return Result.failure(URLError(.badURL)).publisher.eraseToAnyPublisher()
        }
        guard !email.isEmpty && !password.isEmpty else {
            return Result.failure(URLError(.userAuthenticationRequired)).publisher.eraseToAnyPublisher()
        }
        let encoded = try? JSONEncoder().encode(UserRequest(email: email, password: password))
        var request = URLRequest(url: url)
        request.httpBody = encoded
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { data, response in
                guard let decoded = try? JSONDecoder().decode(RootResponse<User>.self, from: data) else { return User(id: -1, email: "")}
                return decoded.result
            }
            .eraseToAnyPublisher()
    }
    
    func login() {
        loginSubscription = loginSubscriber()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                print(error)
                
            }, receiveValue: { user in
                print(user)
                KeychainHelper.standard.save(user, service: KeychainHelper.service, account: KeychainHelper.account)
            })
    }
}

fileprivate struct UserRequest: Encodable {
    var email: String
    var password: String
}
