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

    //MARK: Signup request
    func signup(success: @escaping ()->() = {}) {
        //TODO: Alert Error
        guard let url = getUrl(for: "/auth/signup") else { return }
        guard !email.isEmpty && !password.isEmpty else { return }
        
        var request = URLRequest(url: url)
        let encoded = try? JSONEncoder().encode(UserRequest(email: email, password: password))
        request.httpBody = encoded
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        signUpSubscription = NetworkManager.shared.requestPublisher(for: request, decoding: RootResponse<UserToken>.self)
            .map(\.result)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
            }, receiveValue: { [self] tokens in
                saveUserData(from: tokens)
                success()
            })
    }

    //MARK: Login request
    func login(success: @escaping ()->() = {}) {
        //TODO: Alert Error
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
        
        loginSubscription = NetworkManager.shared.requestPublisher(for: request, decoding: UserToken.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    break
                }
            }, receiveValue: { [self] tokens in
                
                saveUserData(from: tokens)
                
                success()
            })
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
