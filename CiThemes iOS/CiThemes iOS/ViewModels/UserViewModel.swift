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
    
    private var subscriptions: [AnyCancellable] = []
    
    //MARK: Signup request
    func signup(success: @escaping ()->() = {}) {
        guard let url = getUrl(for: "/auth/signup") else { return }
        guard !email.isEmpty && !password.isEmpty else { return }
        
        var request = URLRequest(url: url)
        let encoded = try? JSONEncoder().encode(UserRequest(email: email, password: password))
        request.httpBody = encoded
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let publisher = NetworkManager.shared.requestPublisher(for: request, decoding: RootResponse<UserToken>.self)
            .map(\.result)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
            }, receiveValue: { [self] tokens in
                saveUserData(from: tokens)
                success()
            })
        subscriptions.append(publisher)
    }

    //MARK: Login request
    func login(success: @escaping ()->() = {}) {
        guard let url = getUrl(for: "/auth/login") else {
            return
        }
        guard !email.isEmpty && !password.isEmpty else {
            return
        }
        let encoded = try? JSONEncoder().encode(UserRequest(email: email, password: password))
        
        var request = URLRequest(url: url)
        request.httpBody = encoded
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let publisher = NetworkManager.shared.requestPublisher(for: request, decoding: RootResponse<UserToken>.self)
            .map(\.result)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    #if DEBUG
                    print(error)
                    #endif
                    break
                }
            }, receiveValue: { [self] tokens in
                
                saveUserData(from: tokens)
                
                success()
            })
        subscriptions.append(publisher)
    }
    
    func logout() {
        guard let url = getUrl(for: "/auth/logout") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let publisher = NetworkManager.shared.authenticatedRequestPublisher(for: request, decoding: RootResponse<String>.self)
            .map(\.result)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    #if DEBUG
                    print(error)
                    #endif
                    break
                }
            } receiveValue: { message in
                if message == "OK" {
                    KeychainHelper.standard.logout()
                }
            }
        subscriptions.append(publisher)
    }
    
    //TODO: these
    func update() {
    }
    
    func setHometown() {
    }
    
    private func saveUserData(from tokens: UserToken) {
        KeychainHelper.standard.save(email, service: .email, account: KeychainHelper.account)
        
        let userId = String(tokens.refreshToken.userId)
        KeychainHelper.standard.save(userId, service: .userId)
        
        KeychainHelper.standard.save(tokens, service: .tokens)
    }
}

fileprivate struct UserRequest: Encodable {
    var email: String
    var password: String
}
